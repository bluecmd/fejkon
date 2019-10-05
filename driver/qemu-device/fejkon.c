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

#define TYPE_PCI_FEJKON_DEVICE "fejkon"
#define FEJKON(obj) OBJECT_CHECK(FejkonState, obj, TYPE_PCI_FEJKON_DEVICE)

#define PCI_VENDOR_ID_FEJKON 0xf1c0
#define PCI_DEVICE_ID_FEJKON 0x0de5

typedef struct {
  PCIDevice pdev;
  MemoryRegion mmio;
} FejkonState;

#if 0
static bool fejkon_msi_enabled(FejkonState *card)
{
  return msi_enabled(&card->pdev);
}
#endif

static uint32_t fejkon_temperature(void)
{
  // Center around 50 C
  int base = 50 * 128;

  // Add up to +30 C for in-die sensor
  int local = base + rand() % (10 * 128);

  // Add up to +10 C for remote sensor
  int remote = base + rand() % (30 * 128);

  return (remote & 0xffff) << 16 | (local & 0xffff);
}

static uint64_t fejkon_mmio_read(void *opaque, hwaddr addr, unsigned size)
{
  /* FejkonState *card = opaque; */
  uint64_t val = 0ULL;

  if (size != 4) {
    return val;
  }

  switch (addr) {
    case 0x00:
      /* Version and card options */
      val = 0x02010de5u;
      break;
    case 0x04:
      /* Temperature */
      val = fejkon_temperature();
      break;
    default:
      printf("fejkon: Read from unknown bar0 space: 0x%lx\n", addr);
      break;
  }

  return val;
}

static void fejkon_mmio_write(void *opaque, hwaddr addr, uint64_t val,
    unsigned size)
{
  /* TODO */
  printf("fejkon: Write to unknown bar0 space: 0x%lx\n", addr);
}

static const MemoryRegionOps fejkon_mmio_ops = {
  .read = fejkon_mmio_read,
  .write = fejkon_mmio_write,
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
    return;
  }

  memory_region_init_io(&card->mmio, OBJECT(card), &fejkon_mmio_ops, card,
      "fejkon-mmio", 512 * KiB);
  pci_register_bar(pdev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY, &card->mmio);
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
    { INTERFACE_CONVENTIONAL_PCI_DEVICE },
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
