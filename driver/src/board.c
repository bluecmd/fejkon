#include "fejkon.h"

#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/hwmon.h>
#include <linux/if_arp.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/netdevice.h>
#include <linux/rtnetlink.h>
#include <linux/aer.h>
#include <asm/uaccess.h>

#ifdef pr_fmt
#undef pr_fmt
#endif
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define FEJKON_VENDOR_ID 0xf1c0
#define FEJKON_DEVICE_ID 0x0de5

#define PORT_REFRESH_INTERVAL_MS 100

struct packet_meta {
  __be32 length;
  __be32 port_id;
};

static const struct header_ops net_header_ops = {
};

struct class *fejkon_class;

static void port_refresh_status(struct timer_list *timer)
{
  // The port refresh is polled to reduce complexity of the hardware design.
  // It seems silly to introduce either a 8 IRQs for SFP and FC state, or
  // an IRQ controller just to get the port state a little bit faster.
  // Polling every 100 ms seems like a good trade-off.
  struct fejkon_port *port = from_timer(port, timer, refresh_timer);
  int status;
  int state;
  status = ioread32(port->card->bar0 + BAR0_SFP_STATUS_OFFSET(port->id));
  state = ioread32(port->card->bar0 + BAR0_FC_STATE_OFFSET(port->id));
  if ((status & SFP_PRESENT) == 0 || status & SFP_LOS || status & SFP_TX_FAIL) {
    netif_carrier_off(port->net);
    netif_dormant_off(port->net);
  } else {
    netif_carrier_on(port->net);
    if (state == 0) {
      netif_dormant_off(port->net);
    } else {
      netif_dormant_on(port->net);
    }
  }
  if (mod_timer(&port->refresh_timer,
        jiffies + msecs_to_jiffies(PORT_REFRESH_INTERVAL_MS))) {
    dev_err(port->dev, "failed to reschedule port_refresh_status");
  }
}

static irqreturn_t card_irq(int irq, void *opaque)
{
  struct fejkon_card *card = opaque;
  pr_info("card_irq irq = %d dev = %p\n", irq, card);
  return IRQ_HANDLED;
}

static int poll(struct napi_struct *napi, int budget)
{
  struct fejkon_card *card = container_of(napi, struct fejkon_card, napi);
  // "The poll() function may also process TX completions, in which case if
  // it processes the entire TX ring then it should count that work as the rest
  // of the budget. Otherwise, TX completions are not counted."
  // TODO: TX
  int work_done = 0;

  int write_ptr = ioread32(card->bar0 + 0xA0C) - card->rx_buf_start_dma;
  void *rx_buf_write = card->rx_buf_start + write_ptr;
  while(rx_buf_write != card->rx_buf_read) {
    int port_id;
    int len;
    struct sk_buff *skb;
    struct fejkon_port *port;
    struct packet_meta *meta;
    if (work_done >= budget)
      return work_done;

    // We don't use RX descriptors, we store all metadata in known positions
    // inside the ring buffer. For RX this is at the end of the element.
    meta = card->rx_buf_read + 4096 - sizeof(*meta);
    port_id = be32_to_cpu(meta->port_id);
    len = be32_to_cpu(meta->length);
    port = card->port[port_id];
    if (!netif_oper_up(port->net)) {
      // TODO(bluecmd): drop counter
      dev_notice(port->dev,
          "received packet on inactive interface, dropping");
    } else if (len < 36) {
      // TODO(bluecmd): drop counter
      dev_notice(port->dev,
          "received undersized packet on interface, dropping");
    } else {
      skb = netdev_alloc_skb(port->net, len);
      if (!skb) {
        // TODO(bluecmd): drop counter
        dev_warn(port->dev, "failed to allocate skb, len %d", len);
        return work_done;
      }
      skb_put_data(skb, card->rx_buf_read, len);
      // Since we're not doing Ethernet we have to set these manually or
      // the kernel will try to guess them (incorrectly)
      skb_set_mac_header(skb, 0);
      skb_set_network_header(skb, 0);
      skb_set_transport_header(skb, 0);
      skb_reset_mac_len(skb);
      netif_receive_skb(skb);
    }
    work_done++;
    card->rx_buf_read += 4096;
    if (card->rx_buf_read == card->rx_buf_end) {
      card->rx_buf_read = card->rx_buf_start;
    }
  }

  pr_info("poll budget = %d, processed = %d\n", budget, work_done);
  if (work_done < budget) {
    napi_complete(napi);
    // Update read pointer and re-enable IRQ
    iowrite32(
        card->rx_buf_start_dma + (card->rx_buf_read - card->rx_buf_start),
        card->bar0 + 0xA08);
  }
  return work_done;
}

static irqreturn_t rx_irq(int irq, void *opaque)
{
  struct fejkon_card *card = opaque;
  napi_schedule(&card->napi);
  return IRQ_HANDLED;
}

static irqreturn_t rx_dropped_irq(int irq, void *opaque)
{
  struct fejkon_card *card = opaque;
  dev_err(&card->pci->dev, "packet dropped");
  // TODO: Counters
  return IRQ_HANDLED;
}

static int net_open(struct net_device *net)
{
  struct fejkon_port *port = netdev_priv(net);
  // Enable TX
  iowrite32(0, port->card->bar0 + BAR0_SFP_STATUS_OFFSET(port->id));
  // Try to trigger refresh of port status ASAP
  mod_timer(&port->refresh_timer, jiffies + 1);
  return 0;
}

static int net_stop(struct net_device *net)
{
  struct fejkon_port *port = netdev_priv(net);
  // Disable TX
  iowrite32(1 << 3, port->card->bar0 + BAR0_SFP_STATUS_OFFSET(port->id));
  return 0;
}

static netdev_tx_t net_tx(struct sk_buff *skb, struct net_device *net)
{
  netdev_notice(net, "tx len %d, bytes: %02x %02x %02x %02x\n",
      skb->len, skb->data[0], skb->data[1], skb->data[2], skb->data[3]);
  // TODO
  return NETDEV_TX_OK;
}

static const struct net_device_ops net_netdev_ops = {
  .ndo_open       = net_open,
  .ndo_stop       = net_stop,
  .ndo_start_xmit = net_tx,
};

static void ethtool_get_drvinfo(struct net_device *net,
    struct ethtool_drvinfo *info)
{
  struct fejkon_port *port = netdev_priv(net);
  unsigned int githash;
  strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));

  githash = ioread32(port->card->bar0 + 0x4);
  snprintf(info->fw_version, sizeof(info->fw_version), "git:%08x", githash);
  strlcpy(info->bus_info, dev_name(port->dev), sizeof(info->bus_info));
  // TODO: There are probably many more interesting fields to fill in
}

static u32 ethtool_get_link(struct net_device *net)
{
  return netif_carrier_ok(net);
}

static const struct ethtool_ops net_ethtool_ops = {
  .get_link = ethtool_get_link,
  .get_drvinfo = ethtool_get_drvinfo,
};

static void init_netdev(struct net_device *net)
{
  net->header_ops = &net_header_ops;
  net->netdev_ops = &net_netdev_ops;
  net->ethtool_ops = &net_ethtool_ops;
  net->addr_len = 3;
  net->type = ARPHRD_FCFABRIC;
  net->mtu = 2148;
  net->min_mtu = 2148;
  net->flags = IFF_NOARP;
  memset(net->broadcast, 0xff, 3);
}

static int fejkon_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
    u32 attr, int channel, long *val)
{
  struct fejkon_card *card = dev_get_drvdata(dev);
  int reg;
  switch (type) {
  case hwmon_chip:
    switch (attr) {
    case hwmon_chip_update_interval:
      // We are refreshing faster than 1 kHz but this is how fast we can say
      *val = 1;
      break;
    default:
      return -EINVAL;
    }
    break;
  case hwmon_temp:
    switch (attr) {
    case hwmon_temp_input:
      // Unit is millidegree C
      reg = ioread16(card->bar0 + 0x10);
      if ((reg & (1<<8)) == 0) {
        // No value available
        return -ERANGE;
      }
      *val = ((ioread16(card->bar0 + 0x10) & 0xff) - 128) * 1000;
      break;
    default:
      return -EINVAL;
    }
    break;
  default:
    return -EINVAL;
  }
  return 0;
}

static umode_t fejkon_hwmon_is_visible(const void *data,
    enum hwmon_sensor_types type, u32 attr, int channel)
{
  switch (type) {
    case hwmon_chip:
      switch (attr) {
        case hwmon_chip_update_interval:
          return 0444;
      }
      break;
    case hwmon_temp:
      switch (attr) {
        case hwmon_temp_input:
          return 0444;
      }
      break;
    default:
      break;
  }
  return 0;
}

static const struct hwmon_channel_info *fejkon_hwmon_info[] = {
  HWMON_CHANNEL_INFO(chip, HWMON_C_REGISTER_TZ | HWMON_C_UPDATE_INTERVAL),
  HWMON_CHANNEL_INFO(temp, HWMON_T_INPUT | HWMON_T_MAX | HWMON_T_MAX_HYST),
  NULL
};

static const struct hwmon_ops fejkon_hwmon_ops = {
  .is_visible = fejkon_hwmon_is_visible,
  .read = fejkon_hwmon_read,
};

static const struct hwmon_chip_info fejkon_hwmon_chip_info = {
  .ops = &fejkon_hwmon_ops,
  .info = fejkon_hwmon_info,
};

static ssize_t phy_freq_show(struct device *dev, struct device_attribute *attr,
    char *buf)
{
  struct fejkon_card *card = pci_get_drvdata(to_pci_dev(dev));
  return sprintf(buf, "%u\n", ioread32(card->bar0 + 0x20));
}

static DEVICE_ATTR_RO(phy_freq);

static int probe_port(struct fejkon_card *card, int port_id)
{
  int ret;
  int irq;
  struct net_device *net;
  struct fejkon_port *port;

  net = alloc_netdev(sizeof(*port), "fc%d", NET_NAME_UNKNOWN, init_netdev);
  if (net == NULL) {
    ret = -ENOMEM;
    goto error;
  }

  port = netdev_priv(net);
  port->id = port_id;
  port->card = card;
  port->net = net;
  port->dev = device_create(
      fejkon_class, &card->pci->dev, MKDEV(0, 0), NULL,
      "%s port%d", dev_name(&card->pci->dev), port->id);
  SET_NETDEV_DEV(net, port->dev);

  irq = pci_irq_vector(card->pci, PORT_SFP_I2C_IRQ(port->id));
  port->i2c = fejkon_i2c_probe(
      port->dev, card->bar0 + BAR0_SFP_I2C_OFFSET(port->id), irq);
  if (port->i2c == NULL) {
    dev_err(port->dev, "fejkon_i2c_probe failed\n");
    ret = -EIO;
    goto error;
  }

  netif_napi_add(net, &card->napi, poll, 64 /* weight */);

  ret = register_netdev(net);
  if (ret) {
    dev_err(port->dev, "unable to register netdev\n");
    goto error_register_netdev;
  }

  card->port[port->id] = port;
  timer_setup(&port->refresh_timer, port_refresh_status, 0);
  ret = mod_timer(&port->refresh_timer, jiffies + 1);
  if (ret) {
    dev_err(port->dev, "unable to register refresh timer");
    goto error_timer_setup;
  }
  dev_notice(port->dev, "registered port %d netdev %s\n", port->id, net->name);
  return 0;

error_timer_setup:
  unregister_netdevice(net);
error_register_netdev:
  netif_napi_del(&card->napi);
error:
  /* TODO: Error breakdown and cleanup */
  return ret;
}

/* Note: Requires the caller to have the RTNL lock */
static void remove_port(struct fejkon_card *card, int port_id)
{
  struct fejkon_port *port = card->port[port_id];
  if (port == NULL) {
    return;
  }
  del_timer_sync(&port->refresh_timer);
  unregister_netdevice(port->net);
  netif_napi_del(&port->card->napi);
  fejkon_i2c_remove(port->i2c);
  device_unregister(port->dev);
}

static int setup_buffers(struct fejkon_card *card)
{
  dma_addr_t rx_dma;
  dma_addr_t tx_dma;
  // TODO(bluecmd): There appears to be a number of rx/tx queues in the
  // net_device structure, figure out what the idea is with those
  card->rx_buf_start = dma_alloc_coherent(
      &card->pci->dev, 4096 * 128, &rx_dma, GFP_KERNEL);
  card->rx_buf_read = card->rx_buf_start;
  card->rx_buf_end = card->rx_buf_start + 4096 * 128;
  card->tx_buf_start = dma_alloc_coherent(
      &card->pci->dev, 4096 * 128, &tx_dma, GFP_KERNEL);
  card->tx_buf_write = card->tx_buf_start;
  card->tx_buf_end = card->tx_buf_start + 4096 * 128;
  // Set RX buffer start and end
  iowrite32(rx_dma, card->bar0 + 0xA00);
  iowrite32(rx_dma + 4096 * 128, card->bar0 + 0xA04);
  // Set TX buffer start and end
  iowrite32(rx_dma, card->bar0 + 0xB00);
  iowrite32(rx_dma + 4096 * 128, card->bar0 + 0xB04);
  // Enable RX by confirming our read pointer at the start
  iowrite32(rx_dma, card->bar0 + 0xA08);

  // Save DMA addresses for later calculations
  card->rx_buf_start_dma = rx_dma;
  card->tx_buf_start_dma = tx_dma;
  return 0;
}

static int probe(struct pci_dev *pcidev, const struct pci_device_id *id)
{
  unsigned int phy_clock;
  unsigned int version;
  unsigned int githash;
  int ret;
  int irqs;
  int irq;
  int port_init;
  int ports;
  struct fejkon_card *card;
  struct device *hwm;

  card = devm_kzalloc(&pcidev->dev, sizeof(*card), GFP_KERNEL);
  if (!card) {
    ret = -ENOMEM;
    goto error_card_alloc;
  }

  ret = pci_enable_device(pcidev);
  if (ret < 0) {
    dev_err(&pcidev->dev, "pci_enable_device\n");
    goto error_enable;
  }

  ret = pci_enable_pcie_error_reporting(pcidev);
  if (ret < 0) {
    dev_err(&pcidev->dev, "pci_enable_pcie_error_reporting\n");
    goto error_enable_aer;
  }

  ret = pci_request_region(pcidev, 0 /* bar */, KBUILD_MODNAME);
  if (ret < 0) {
    dev_err(&pcidev->dev, "pci_request_region\n");
    goto error_request_region;
  }

  ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
  if (ret < 0) {
    dev_err(&pcidev->dev, "pci_set_dma_mask\n");
    goto error_set_dma_mask;
  }

  pci_set_master(pcidev);

  card->pci = pcidev;
  card->bar0 = pci_iomap(pcidev, 0 /* bar */, 0);

#if 1
  /* Temporary performance benchmark */
  {
    ktime_t start = ktime_get();
    ktime_t end;
    int perf;
    for (ret = 0; ret < 0x80000; ret++) {
      if (ioread32(card->bar0 + 0x0) == ~0) {
        dev_err(&pcidev->dev, "stress test failed");
        ret = -EIO;
        goto error_sanity;
      }
    }
    end = ktime_get();
    perf = (0x80000*4*8)/((end - start) / 1000);
    dev_dbg(&pcidev->dev, "debug performance result: %d Mbit/s", perf);
  }
#endif

  version = ioread32(card->bar0 + 0x0);
  if ((version & 0xffff) != 0x0de5) {
    dev_dbg(&pcidev->dev, "ignoring card with unknown magic: %04x", version & 0xffff);
    ret = -EINVAL;
    goto error_sanity;
  }

  ports = (version >> 24) & 0xff;
  if (ports > MAX_PORTS) {
    dev_err(&pcidev->dev, "card has too many ports: %d\n", ports);
    ret = -EINVAL;
    goto error_sanity;
  }
  version = (version >> 16) & 0xff;
  githash = ioread32(card->bar0 + 0x4);
  dev_notice(&pcidev->dev, "found card with version %d (%08x), ports = %d\n",
      version, githash, ports);

  phy_clock = ioread32(card->bar0 + 0x20);
  dev_notice(&pcidev->dev, "PHY clock running at %d.%03d MHz",
      phy_clock / 1000000, (phy_clock / 1000) % 1000);

  irqs = 2 + 4 * ports;
  ret = pci_alloc_irq_vectors(pcidev, irqs, irqs, PCI_IRQ_ALL_TYPES);
  if (ret < 0) {
    /* See the README.md for fejkon for more details about this */
    dev_err(&pcidev->dev, "pci_alloc_irq_vectors failed, is multiple "
        "MSI interrupts support enabled for your platform?");
    goto error_irq_vectors;
  }

  irq = pci_irq_vector(pcidev, 0);
  ret = request_irq(irq, card_irq, IRQF_SHARED, KBUILD_MODNAME, card);
  if (ret < 0) {
    dev_err(&pcidev->dev, "request_irq\n");
    goto error_request_irq;
  }

  hwm = devm_hwmon_device_register_with_info(
      &pcidev->dev, "fejkon", card, &fejkon_hwmon_chip_info, NULL);
  if (IS_ERR(hwm)) {
    dev_err(&pcidev->dev, "devm_hwmon_device_register_with_info\n");
    ret = PTR_ERR(hwm);
    goto error_hwmon_register;
  }

  ret = device_create_file(&pcidev->dev, &dev_attr_phy_freq);
  if (ret) {
    dev_err(&pcidev->dev, "unable to create sysfs file\n");
    goto error_sysfs_register;
  }

  irq = pci_irq_vector(card->pci, 1);
  ret = request_irq(irq, rx_irq, IRQF_SHARED, KBUILD_MODNAME, card);
  if (ret < 0) {
    dev_err(&pcidev->dev, "request_irq for rx_irq\n");
    goto error_rx_irq;
  }

  irq = pci_irq_vector(card->pci, 2);
  ret = request_irq(irq, rx_dropped_irq, IRQF_SHARED, KBUILD_MODNAME, card);
  if (ret < 0) {
    dev_err(&pcidev->dev, "request_irq for rx_dropped_irq\n");
    goto error_rx_dropped_irq;
  }

  pci_set_drvdata(pcidev, card);

  /* card initialized, register netdev for ports */
  for (port_init = 0; port_init < ports; port_init++) {
    ret = probe_port(card, port_init);
    if (ret < 0) {
      goto error_port_init;
    }
  }

  pci_set_master(pcidev);
  napi_enable(&card->napi);
  ret = setup_buffers(card);
  if (ret < 0) {
    goto error_setup_buffers;
  }

  return 0;
error_setup_buffers:
  napi_disable(&card->napi);
  pci_clear_master(pcidev);
error_port_init:
  rtnl_lock();
  for (port_init--; port_init >= 0; port_init--) {
    remove_port(card, port_init);
  }
  rtnl_unlock();
  free_irq(pci_irq_vector(pcidev, 2), card);
error_rx_dropped_irq:
  free_irq(pci_irq_vector(pcidev, 1), card);
error_rx_irq:
  device_remove_file(&pcidev->dev, &dev_attr_phy_freq);
error_sysfs_register:
  /* hwmon is deregistered with device, nothing to clean up*/
error_hwmon_register:
  free_irq(pci_irq_vector(pcidev, 0), card);
error_request_irq:
  pci_free_irq_vectors(pcidev);
error_irq_vectors:
error_sanity:
error_set_dma_mask:
  pci_release_region(pcidev, 0 /* bar */);
error_request_region:
error_enable_aer:
  pci_disable_device(pcidev);
error_enable:
error_card_alloc:
  return ret;
}

static void remove(struct pci_dev *pcidev)
{
  struct fejkon_card *card = pci_get_drvdata(pcidev);
  int i;
  if (!card) {
    return;
  }
  napi_disable(&card->napi);
  // Disable buffers
  iowrite32(0, card->bar0 + 0xA00);
  iowrite32(0, card->bar0 + 0xB00);
  pci_clear_master(pcidev);
  // TODO: dma_free_coherent
  rtnl_lock();
  for (i = 0; i < MAX_PORTS; i++) {
    remove_port(card, i);
  }
  rtnl_unlock();
  free_irq(pci_irq_vector(pcidev, 2), card);
  free_irq(pci_irq_vector(pcidev, 1), card);
  device_remove_file(&pcidev->dev, &dev_attr_phy_freq);
  free_irq(pci_irq_vector(pcidev, 0), card);
  pci_free_irq_vectors(pcidev);
  pci_release_region(pcidev, 0 /* bar */);
  pci_disable_device(pcidev);
}

static pci_ers_result_t error_detected(struct pci_dev *pcidev,
    enum pci_channel_state unused_state)
{
  dev_err(&pcidev->dev, "Error detected, disconnecting device");
  /* assume the worst for now and just shut the device down */
  remove(pcidev);
  return PCI_ERS_RESULT_DISCONNECT;
}

static struct pci_device_id id_table[] = {
  { PCI_DEVICE(FEJKON_VENDOR_ID, FEJKON_DEVICE_ID), },
  { 0, }
};

MODULE_DEVICE_TABLE(pci, id_table);

static struct pci_error_handlers pci_error_handlers = {
  .error_detected = error_detected,
};

static struct pci_driver pci_driver = {
  .name        = KBUILD_MODNAME,
  .id_table    = id_table,
  .probe       = probe,
  .remove      = remove,
  .err_handler = &pci_error_handlers,
};

static int minit(void)
{
  fejkon_class = class_create(THIS_MODULE, "fejkon");
  if (IS_ERR(fejkon_class)) {
    return PTR_ERR(fejkon_class);
  }
  if (pci_register_driver(&pci_driver) < 0) {
    return 1;
  }
  return 0;
}

static void mexit(void)
{
  pci_unregister_driver(&pci_driver);
  class_destroy(fejkon_class);
}

module_init(minit);
module_exit(mexit);

MODULE_LICENSE("GPL");
