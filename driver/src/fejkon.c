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

#define MMIO_AREA_SIZE 0x100

/* TODO: Change */
#define EDU_DEVICE_ID 0x11e8
#define QEMU_VENDOR_ID 0x1234

struct fejkon_net {
  struct pci_dev *dev;
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
  // Loop the packet back for now
  netif_rx(skb);
  return NETDEV_TX_OK;
}

static const struct net_device_ops net_netdev_ops = {
  .ndo_open       = net_open,
  .ndo_stop       = net_stop,
  .ndo_start_xmit = net_tx,
};

static struct pci_dev *pdev;
static void __iomem *mmio;

static irqreturn_t irq_handler(int irq, void *dev)
{
  pr_info("irq_handler irq = %d dev = %d\n", irq, *(int *)dev);
  iowrite32(0, mmio + 4);
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

static int probe(struct pci_dev *dev, const struct pci_device_id *id)
{
  unsigned int version;
  int ret;
  int i;
  struct net_device *net;

  pdev = dev;
  ret = pci_enable_device(dev);
  if (ret < 0) {
    dev_err(&pdev->dev, "pci_enable_device\n");
    goto error;
  }

  ret = pci_request_region(dev, 0 /* bar */, KBUILD_MODNAME);
  if (ret < 0) {
    dev_err(&pdev->dev, "pci_request_region\n");
    goto error;
  }

  mmio = pci_iomap(pdev, 0 /* bar */, MMIO_AREA_SIZE);
  ret = request_irq(dev->irq, irq_handler, IRQF_SHARED, KBUILD_MODNAME, dev);
  if (ret < 0) {
    dev_err(&dev->dev, "request_irq\n");
    goto error;
  }

  version = ioread32(mmio + 0x0);
  if ((version & 0xff) != 0xed) {
    dev_dbg(&dev->dev, "tried to load driver for unknown card: %02x", version & 0xff);
    goto error;
  }

  dev_notice(&dev->dev, "found card with version %d.%d\n", version >> 24, (version >> 16) & 0xff);

  /* card initialized, register netdev for ports */
  /* TODO: Read from card */
  for (i = 0; i < 1; i++) {
    net = alloc_netdev(sizeof(*dev), "fc%d", NET_NAME_UNKNOWN, init_netdev);
    if (net == NULL) {
      return -ENOMEM;
    }

    SET_NETDEV_DEV(net, &dev->dev);
    ((struct fejkon_net *)netdev_priv(net))->dev = dev;

    ret = register_netdev(net);
    if (ret) {
      dev_err(&dev->dev, "unable to register netdev\n");
      goto error;
    }

    dev_notice(&dev->dev, "registered port %d netdev %s\n", i, net->name);
  }

  return 0;
error:
  return ret;
}

static void remove(struct pci_dev *dev)
{
  free_irq(dev->irq, dev);
  pci_release_region(dev, 0 /* bar */);
}

static struct pci_device_id id_table[] = {
  { PCI_DEVICE(QEMU_VENDOR_ID, EDU_DEVICE_ID), },
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
