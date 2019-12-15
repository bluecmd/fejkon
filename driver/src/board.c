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
#include <asm/uaccess.h>

#ifdef pr_fmt
#undef pr_fmt
#endif
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define BAR0_AREA_SIZE 0x50000

#define FEJKON_VENDOR_ID 0xf1c0
#define FEJKON_DEVICE_ID 0x0de5

static const struct header_ops net_header_ops = {
};

static const struct ethtool_ops net_ethtool_ops = {
};

struct class *fejkon_class;

static int net_open(struct net_device *net)
{
  netdev_notice(net, "%s up\n", net->name);
  return 0;
}

static int net_stop(struct net_device *net)
{
  netdev_notice(net, "%s close\n", net->name);
  return 0;
}

static netdev_tx_t net_tx(struct sk_buff *skb, struct net_device *net)
{
  netdev_notice(net, "tx len %d, bytes: %02x %02x %02x %02x\n",
      skb->len, skb->data[0], skb->data[1], skb->data[2], skb->data[3]);
  /* Loop the packet back for now */
  netif_rx(skb);
  return NETDEV_TX_OK;
}

static const struct net_device_ops net_netdev_ops = {
  .ndo_open       = net_open,
  .ndo_stop       = net_stop,
  .ndo_start_xmit = net_tx,
};

static void port_refresh_status(struct fejkon_port *port)
{
  int status;
  status = ioread32(port->card->bar0 + BAR0_SFP_STATUS_OFFSET(port->id));
  if ((status & SFP_PRESENT) == 0 || status & SFP_LOS || status & SFP_TX_FAIL) {
    netif_carrier_off(port->net);
  } else {
    netif_carrier_on(port->net);
  }
}

static irqreturn_t card_irq(int irq, void *dev)
{
  struct fejkon_card *card = dev;
  pr_info("card_irq irq = %d dev = %p\n", irq, card);
  return IRQ_HANDLED;
}

static irqreturn_t port_rx_irq(int irq, void *dev)
{
  struct fejkon_port *port = dev;
  pr_info("port_rx_irq port = %d, irq = %d dev = %d\n", port->id, irq, *(int *)dev);
  return IRQ_HANDLED;
}

static irqreturn_t port_tx_irq(int irq, void *dev)
{
  struct fejkon_port *port = dev;
  pr_info("port_tx_irq port = %d, irq = %d dev = %d\n", port->id, irq, *(int *)dev);
  return IRQ_HANDLED;
}

static irqreturn_t port_sfp_irq(int irq, void *dev)
{
  struct fejkon_port *port = dev;
  pr_info("port_sfp_irq port = %d, irq = %d dev = %d\n",
      port->id, irq, *(int *)dev);
  port_refresh_status(port);
  return IRQ_HANDLED;
}

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

  irq = pci_irq_vector(card->pci, PORT_RX_IRQ(port->id));
  ret = request_irq(irq, port_rx_irq, IRQF_SHARED, KBUILD_MODNAME, port);
  if (ret < 0) {
    dev_err(port->dev, "request_irq for port_rx_irq\n");
    goto error;
  }

  irq = pci_irq_vector(card->pci, PORT_TX_IRQ(port->id));
  ret = request_irq(irq, port_tx_irq, IRQF_SHARED, KBUILD_MODNAME, port);
  if (ret < 0) {
    dev_err(port->dev, "request_irq for port_tx_irq\n");
    goto error;
  }

  irq = pci_irq_vector(card->pci, PORT_SFP_IRQ(port->id));
  ret = request_irq(irq, port_sfp_irq, IRQF_SHARED, KBUILD_MODNAME, port);
  if (ret < 0) {
    dev_err(port->dev, "request_irq for port_sfp_irq\n");
    goto error;
  }

  irq = pci_irq_vector(card->pci, PORT_SFP_I2C_IRQ(port->id));
  port->i2c = fejkon_i2c_probe(
      port->dev, card->bar0 + BAR0_SFP_I2C_OFFSET(port->id), irq);
  if (port->i2c == NULL) {
    dev_err(port->dev, "fejkon_i2c_probe failed\n");
    goto error;
  }

  ret = register_netdev(net);
  if (ret) {
    dev_err(port->dev, "unable to register netdev\n");
    goto error;
  }

  card->port[port->id] = port;
  port_refresh_status(port);
  dev_notice(port->dev, "registered port %d netdev %s\n", port->id, net->name);

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
  unregister_netdevice(port->net);
  fejkon_i2c_remove(port->i2c);
  free_irq(pci_irq_vector(card->pci, PORT_RX_IRQ(port_id)), port);
  free_irq(pci_irq_vector(card->pci, PORT_TX_IRQ(port_id)), port);
  free_irq(pci_irq_vector(card->pci, PORT_SFP_IRQ(port_id)), port);
  device_unregister(port->dev);
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
  card->bar0 = pci_iomap(pcidev, 0 /* bar */, BAR0_AREA_SIZE);

  version = ioread32(card->bar0 + 0x0);
  dev_dbg(&pcidev->dev, "DEBUG RESULT: %08x", version);
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

  /* card initialized, register netdev for ports */
  for (port_init = 0; port_init < ports; port_init++) {
    ret = probe_port(card, port_init);
    if (ret < 0) {
      goto error_port_init;
    }
  }

  pci_set_drvdata(pcidev, card);
  return 0;
error_port_init:
  rtnl_lock();
  for (port_init--; port_init >= 0; port_init--) {
    remove_port(card, port_init);
  }
  rtnl_unlock();
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
  rtnl_lock();
  for (i = 0; i < MAX_PORTS; i++) {
    remove_port(card, i);
  }
  rtnl_unlock();
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
