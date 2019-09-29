#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/module.h>
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

static struct pci_dev *pdev;
static void __iomem *mmio;

static irqreturn_t irq_handler(int irq, void *dev)
{
  pr_info("irq_handler irq = %d dev = %d\n", irq, *(int *)dev);
  iowrite32(0, mmio + 4);
  return IRQ_HANDLED;
}

static int probe(struct pci_dev *dev, const struct pci_device_id *id)
{
  unsigned int version;
  pdev = dev;
  if (pci_enable_device(dev) < 0) {
    dev_err(&(pdev->dev), "pci_enable_device\n");
    goto error;
  }

  if (pci_request_region(dev, 0 /* bar */, KBUILD_MODNAME)) {
    dev_err(&(pdev->dev), "pci_request_region\n");
    goto error;
  }

  mmio = pci_iomap(pdev, 0 /* bar */, MMIO_AREA_SIZE);
  if (request_irq(dev->irq, irq_handler, IRQF_SHARED, KBUILD_MODNAME, dev) < 0) {
    dev_err(&(dev->dev), "request_irq\n");
    goto error;
  }

  version = ioread32(mmio + 0x0);
  if ((version & 0xff) != 0xed) {
    pr_debug("tried to load driver for unknown card: %02x", version & 0xff);
    goto error;
  }

  pr_info("found card with version %d.%d\n", version >> 24, (version >> 16) & 0xff);
  return 0;
error:
  return 1;
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
