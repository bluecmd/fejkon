#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/netdevice.h>
#include <linux/if_arp.h>
#include <linux/pci.h>
#include <asm/uaccess.h>

#ifdef pr_fmt
#undef pr_fmt
#endif
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define MMIO_AREA_SIZE 0x5000

#define FEJKON_VENDOR_ID 0xf1c0
#define FEJKON_DEVICE_ID 0x0de5

struct fejkon_card {
  struct pci_dev *pci;
  void __iomem *bar0;
  struct net_device *net[4];
  struct altr_i2c_dev *i2c[4];
};

struct fejkon_port {
  struct fejkon_card *card;
  int id;
};

static const struct header_ops net_header_ops = {
};

static const struct ethtool_ops net_ethtool_ops = {
};

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
  netdev_notice(net, "%s tx len %d, bytes: %02x %02x %02x %02x\n",
      net->name, skb->len, skb->data[0], skb->data[1], skb->data[2], skb->data[3]);
  /* Loop the packet back for now */
  netif_rx(skb);
  return NETDEV_TX_OK;
}

static const struct net_device_ops net_netdev_ops = {
  .ndo_open       = net_open,
  .ndo_stop       = net_stop,
  .ndo_start_xmit = net_tx,
};

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
  pr_info("port_sfp_irq port = %d, irq = %d dev = %d\n", port->id, irq, *(int *)dev);
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

static int probe(struct pci_dev *pcidev, const struct pci_device_id *id)
{
  unsigned int version;
  int ret;
  int irqs;
  int irq;
  int i;
  int ports;
  struct fejkon_card *card;

  ret = pci_enable_device(pcidev);
  if (ret < 0) {
    dev_err(&pcidev->dev, "pci_enable_device\n");
    goto error;
  }

  ret = pci_request_region(pcidev, 0 /* bar */, KBUILD_MODNAME);
  if (ret < 0) {
    dev_err(&pcidev->dev, "pci_request_region\n");
    goto error;
  }

  card = devm_kzalloc(&pcidev->dev, sizeof(*card), GFP_KERNEL);
  if (!card)
    return -ENOMEM;
  card->pci = pcidev;
  card->bar0 = pci_iomap(pcidev, 0 /* bar */, MMIO_AREA_SIZE);

  version = ioread32(card->bar0 + 0x0);
  if ((version & 0xffff) != 0x0de5) {
    dev_dbg(&pcidev->dev, "ignoring card with unknown magic: %04x", version & 0xffff);
    goto error;
  }

  ports = version >> 24;
  version = (version >> 16) & 0xff;
  dev_notice(&pcidev->dev, "found card with version %d, ports = %d\n", version, ports);

  irqs = 1 + 4 * ports;
  ret = pci_alloc_irq_vectors(pcidev, irqs, irqs, PCI_IRQ_ALL_TYPES);
  if (ret < 0) {
    /* See the README.md for fejkon for more details about this */
    dev_err(&pcidev->dev, "pci_alloc_irq_vectors failed, is multiple "
        "MSI interrupts support enabled for your platform?\n");
    goto error;
  }
  dev_notice(&pcidev->dev, "pci_alloc_irq_vectors: %d", ret);

  irq = pci_irq_vector(pcidev, 0);
  ret = request_irq(irq, card_irq, IRQF_SHARED, KBUILD_MODNAME, card);
  if (ret < 0) {
    dev_err(&pcidev->dev, "request_irq\n");
    goto error;
  }

  /* card initialized, register netdev for ports */
  for (i = 0; i < ports; i++) {
    struct net_device *net;
    struct fejkon_port *port;
    net = alloc_netdev(sizeof(*port), "fc%d", NET_NAME_UNKNOWN, init_netdev);
    if (net == NULL) {
      return -ENOMEM;
    }

    SET_NETDEV_DEV(net, &pcidev->dev);
    port = netdev_priv(net);
    port->id = i;
    port->card = card;

    irq = pci_irq_vector(pcidev, 1 + i * 4);
    ret = request_irq(irq, port_rx_irq, IRQF_SHARED, KBUILD_MODNAME, port);
    if (ret < 0) {
      dev_err(&pcidev->dev, "request_irq for port_rx_irq\n");
      goto error;
    }

    irq = pci_irq_vector(pcidev, 2 + i * 4);
    ret = request_irq(irq, port_tx_irq, IRQF_SHARED, KBUILD_MODNAME, port);
    if (ret < 0) {
      dev_err(&pcidev->dev, "request_irq for port_tx_irq\n");
      goto error;
    }

    irq = pci_irq_vector(pcidev, 3 + i * 4);
    ret = request_irq(irq, port_sfp_irq, IRQF_SHARED, KBUILD_MODNAME, port);
    if (ret < 0) {
      dev_err(&pcidev->dev, "request_irq for port_sfp_irq\n");
      goto error;
    }

    ret = register_netdev(net);
    if (ret) {
      dev_err(&pcidev->dev, "unable to register netdev\n");
      goto error;
    }

    card->net[i] = net;
    dev_notice(&pcidev->dev, "registered port %d netdev %s\n", i, net->name);
  }

  return 0;
error:
  return ret;
}

static void remove(struct pci_dev *dev)
{
  pci_free_irq_vectors(dev);
  pci_release_region(dev, 0 /* bar */);
}

static struct pci_device_id id_table[] = {
  { PCI_DEVICE(FEJKON_VENDOR_ID, FEJKON_DEVICE_ID), },
  { 0, }
};

MODULE_DEVICE_TABLE(pci, id_table);

static struct pci_driver pci_driver = {
  .name     = KBUILD_MODNAME,
  .id_table = id_table,
  .probe    = probe,
  .remove   = remove,
};

static int minit(void)
{
  if (pci_register_driver(&pci_driver) < 0) {
    return 1;
  }
  return 0;
}

static void mexit(void)
{
  pci_unregister_driver(&pci_driver);
}

module_init(minit);
module_exit(mexit);

MODULE_LICENSE("GPL");
