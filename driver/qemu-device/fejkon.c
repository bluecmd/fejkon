/*
 * QEMU PCI device model for Fejkon
 *
 * Copyright (c) 2019 Christian Svensson
 * Copyright (c) 2012-2015 Jiri Slaby for the edu.c driver this is based upon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include "qemu/osdep.h"
#include "qemu/units.h"
#include "hw/pci/pci.h"
#include "hw/hw.h"
#include "hw/pci/msi.h"
#include "qemu/timer.h"
#include "qemu/module.h"
#include "qapi/visitor.h"

#include "i2c.h"

#define TYPE_PCI_FEJKON_DEVICE "fejkon"
#define FEJKON(obj) OBJECT_CHECK(FejkonState, obj, TYPE_PCI_FEJKON_DEVICE)

#define PCI_VENDOR_ID_FEJKON 0xf1c0
#define PCI_DEVICE_ID_FEJKON 0x0de5

typedef struct {
  PCIDevice pdev;
  MemoryRegion bar0;
  struct avalon_i2c sfp1_i2c;
  struct avalon_i2c sfp2_i2c;
} FejkonState;

static bool fejkon_msi_enabled(FejkonState *card)
{
  return msi_enabled(&card->pdev);
}

static void sfp1_intr(void *opaque) {
  FejkonState *card = opaque;
  if (!fejkon_msi_enabled(card)) {
    printf("fejkon: SFP1 interrupt without MSI enabled\n");
    return;
  }
  msi_notify(&card->pdev, 4);
}

static void sfp2_intr(void *opaque) {
  FejkonState *card = opaque;
  if (!fejkon_msi_enabled(card)) {
    printf("fejkon: SFP1 interrupt without MSI enabled\n");
    return;
  }
  msi_notify(&card->pdev, 8);
}

static uint32_t fejkon_temperature(void)
{
  // 65 +/- 15 C
  int local = 50 + rand() % 30;
  return (1 << 8) | ((128 + local) & 0xff);
}

static uint64_t fejkon_bar0_read(void *opaque, hwaddr addr, unsigned size)
{
  FejkonState *card = opaque;
  uint64_t val = 0ULL;

  if (size != 4) {
    printf("fejkon: Read from 0x%lx not QW: %d\n", addr, size);
    return val;
  }

  /* SFP I2C */
  if (addr >= 0x1040 && addr <= 0x1068) {
    return avalon_i2c_read(&card->sfp1_i2c, addr - 0x1040);
  }
  if (addr >= 0x2040 && addr <= 0x2068) {
    return avalon_i2c_read(&card->sfp2_i2c, addr - 0x2040);
  }

  switch (addr) {
    case 0x00:
      /* Version and card options */
      val = 0x02010de5u;
      break;
    case 0x04:
      /* Git hash */
      val = 0xdeadbeef;
      break;
    case 0x10:
      /* Temperature */
      val = fejkon_temperature();
      break;
    case 0x20:
      /* PHY frequency, report running close to 106.25 MHz */
      val = htole64(106249998);
      break;
    case 0x1000:
      /* Port status, SFP present and link OK */
      val = 0x1;
      break;
    case 0x2000:
      /* Port status, SFP present but link not present */
      val = 0x3;
      break;
    default:
      printf("fejkon: Read from unknown bar0 space: 0x%lx\n", addr);
      break;
  }

  return val;
}

static void fejkon_bar0_write(void *opaque, hwaddr addr, uint64_t val,
    unsigned size)
{
  FejkonState *card = opaque;
  if (size != 4) {
    printf("fejkon: Write to 0x%lx not QW: %d\n", addr, size);
    return;
  }

  /* SFP I2C */
  if (addr >= 0x1040 && addr <= 0x1068) {
    avalon_i2c_write(&card->sfp1_i2c, addr - 0x1040, val);
    return;
  }
  if (addr >= 0x2040 && addr <= 0x2068) {
    avalon_i2c_write(&card->sfp2_i2c, addr - 0x2040, val);
    return;
  }

  /* TODO */
  printf("fejkon: Write to unknown bar0 space: 0x%lx\n", addr);
}

static const MemoryRegionOps fejkon_bar0_ops = {
  .read = fejkon_bar0_read,
  .write = fejkon_bar0_write,
  .endianness = DEVICE_NATIVE_ENDIAN,
  .valid = {
    .min_access_size = 4,
    .max_access_size = 8,
  },
  .impl = {
    .min_access_size = 4,
    .max_access_size = 8,
  },

};

static void pci_fejkon_realize(PCIDevice *pdev, Error **errp)
{
  FejkonState *card = FEJKON(pdev);
  uint8_t *pci_conf = pdev->config;

  pci_config_set_interrupt_pin(pci_conf, 1);

  if (msi_init(pdev, 0, 32, true, false, errp)) {
    hw_error("Failed to initialize MSI interrupts");
    return;
  }

  memory_region_init_io(&card->bar0, OBJECT(card), &fejkon_bar0_ops, card,
      "fejkon-bar0", 512 * KiB);
  pci_register_bar(pdev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY, &card->bar0);

  card->sfp1_i2c.name = "sfp1";
  card->sfp1_i2c.intr = sfp1_intr;
  card->sfp1_i2c.extra = card;
  card->sfp1_i2c.data[0] = 0x3;
  card->sfp1_i2c.data[1] = 0x4;
  strcpy((char*)&card->sfp1_i2c.data[20], "FEJKON TEST");
  card->sfp2_i2c.name = "sfp2";
  card->sfp2_i2c.intr = sfp2_intr;
  card->sfp2_i2c.extra = card;
  memcpy(&card->sfp2_i2c.data[0], &card->sfp1_i2c.data[0], 256);

  if (pcie_endpoint_cap_init(pdev, 0x80) < 0) {
    hw_error("Failed to initialize PCIe capability");
  }
  if (pcie_aer_init(pdev, PCI_ERR_VER, 0x100, PCI_ERR_SIZEOF, NULL) < 0) {
    hw_error("Failed to initialize AER capability");
  }
}

static void pci_fejkon_uninit(PCIDevice *pdev)
{
  /* FejkonState *card = FEJKON(pdev); */
  msi_uninit(pdev);
}

static void fejkon_instance_init(Object *obj)
{
  /* FejkonState *card = FEJKON(obj); */
}

static void fejkon_class_init(ObjectClass *class, void *data)
{
  DeviceClass *dc = DEVICE_CLASS(class);
  PCIDeviceClass *k = PCI_DEVICE_CLASS(class);

  k->realize = pci_fejkon_realize;
  k->exit = pci_fejkon_uninit;
  k->vendor_id = PCI_VENDOR_ID_FEJKON;
  k->device_id = PCI_DEVICE_ID_FEJKON;
  k->revision = 0x10;
  k->class_id = PCI_CLASS_NETWORK_OTHER;
  set_bit(DEVICE_CATEGORY_NETWORK, dc->categories);
}

static void pci_fejkon_register_types(void)
{
  static InterfaceInfo interfaces[] = {
    { INTERFACE_PCIE_DEVICE },
    { },
  };
  static const TypeInfo fejkon_info = {
    .name          = TYPE_PCI_FEJKON_DEVICE,
    .parent        = TYPE_PCI_DEVICE,
    .instance_size = sizeof(FejkonState),
    .instance_init = fejkon_instance_init,
    .class_init    = fejkon_class_init,
    .interfaces = interfaces,
  };

  type_register_static(&fejkon_info);
}
type_init(pci_fejkon_register_types)
