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

#define FRAME_SIZE 4096

typedef struct {
  dma_addr_t start;
  dma_addr_t end;
  dma_addr_t write;
  dma_addr_t read;
} FejkonDmaBuf;

typedef struct {
  PCIDevice pdev;
  MemoryRegion bar0;
  struct avalon_i2c sfp1_i2c;
  struct avalon_i2c sfp2_i2c;
  bool stopping;
  QemuThread rx_thread;
  QemuThread rx_irq_thread;
  QemuThread tx_thread;
  FejkonDmaBuf rx_buf;
  FejkonDmaBuf tx_buf;
  QemuMutex rx_buf_mutex;
  QemuMutex tx_buf_mutex;
  bool rx_buf_irq_enabled;
} FejkonState;

static bool fejkon_msi_enabled(FejkonState *card)
{
  return msi_enabled(&card->pdev);
}

static void sfp1_i2c_intr(void *opaque) {
  FejkonState *card = opaque;
  if (!fejkon_msi_enabled(card)) {
    printf("fejkon: SFP1 I2C interrupt without MSI enabled\n");
    return;
  }
  msi_notify(&card->pdev, 4);
}

static void sfp2_i2c_intr(void *opaque) {
  FejkonState *card = opaque;
  if (!fejkon_msi_enabled(card)) {
    printf("fejkon: SFP2 I2C interrupt without MSI enabled\n");
    return;
  }
  msi_notify(&card->pdev, 6);
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
    case 0xA0C:
      qemu_mutex_lock(&card->rx_buf_mutex);
      val = card->rx_buf.write;
      qemu_mutex_unlock(&card->rx_buf_mutex);
      break;
    case 0xB08:
      qemu_mutex_lock(&card->tx_buf_mutex);
      val = card->tx_buf.read;
      qemu_mutex_unlock(&card->tx_buf_mutex);
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

  switch (addr) {
    case 0xA00:
      /* DMA RX Start */
      qemu_mutex_lock(&card->rx_buf_mutex);
      card->rx_buf.start = (uint32_t)val;
      card->rx_buf.read = (uint32_t)val;
      card->rx_buf.write = (uint32_t)val;
      card->rx_buf.end = (uint32_t)val;
      qemu_mutex_unlock(&card->rx_buf_mutex);
      break;
    case 0xA04:
      /* DMA RX End */
      qemu_mutex_lock(&card->rx_buf_mutex);
      card->rx_buf.end = (uint32_t)val;
      qemu_mutex_unlock(&card->rx_buf_mutex);
      break;
    case 0xA08:
      /* DMA RX Read pointer */
      qemu_mutex_lock(&card->rx_buf_mutex);
      card->rx_buf.read = (uint32_t)val;
      // Re-enable IRQ
      card->rx_buf_irq_enabled = 1;
      qemu_mutex_unlock(&card->rx_buf_mutex);
      break;
    case 0xB00:
      /* DMA TX Start */
      qemu_mutex_lock(&card->tx_buf_mutex);
      card->tx_buf.start = (uint32_t)val;
      card->tx_buf.read = (uint32_t)val;
      card->tx_buf.write = (uint32_t)val;
      card->tx_buf.end = (uint32_t)val;
      qemu_mutex_unlock(&card->tx_buf_mutex);
      break;
    case 0xB04:
      /* DMA TX End */
      qemu_mutex_lock(&card->tx_buf_mutex);
      card->tx_buf.end = (uint32_t)val;
      qemu_mutex_unlock(&card->tx_buf_mutex);
      break;
    case 0xB0C:
      /* DMA TX Write pointer */
      qemu_mutex_lock(&card->tx_buf_mutex);
      card->tx_buf.read = (uint32_t)val;
      qemu_mutex_unlock(&card->tx_buf_mutex);
      break;
    default:
      printf("fejkon: Write to unknown bar0 space: 0x%lx\n", addr);
      break;
  }
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

static dma_addr_t dma_incr(FejkonDmaBuf *b, dma_addr_t *var, size_t x)
{
  if (b->end > (*var+x))
    return *var + x;
  return b->start + ((*var + x) - b->end);
}

static void *fejkon_rx_thread(void *opaque)
{
  FejkonState *card = opaque;
  dma_addr_t new_write;
  char test[80] = "HELLO HELLO HELLO HELLO HELLO HELLO HELLO";
  while (!card->stopping) {
    usleep(1000);
    if (card->rx_buf.start == card->rx_buf.end) {
      continue;
    }
    pci_dma_write(&card->pdev, card->rx_buf.write, test, 32);
    // Write packet data to end of packet frame
    pci_dma_write(&card->pdev, card->rx_buf.write+4092, "\0\0\0\0", 4);   // Port
    pci_dma_write(&card->pdev, card->rx_buf.write+4088, "\0\0\0\x20", 4); // Length
    qemu_mutex_lock(&card->rx_buf_mutex);
    new_write = dma_incr(&card->rx_buf, &card->rx_buf.write, FRAME_SIZE);
    if (new_write == card->rx_buf.read) {
      msi_notify(&card->pdev, 2);
      hw_error("Fejkon RX buffer overflown, packets dropped\n");
    } else {
      card->rx_buf.write = new_write;
    }
    qemu_mutex_unlock(&card->rx_buf_mutex);
  }
  return NULL;
}

static void *fejkon_rx_irq_thread(void *opaque)
{
  FejkonState *card = opaque;
  while (!card->stopping) {
    usleep(100000);
    // Emulate FPGA IRQ behavior
    qemu_mutex_lock(&card->rx_buf_mutex);
    if (card->rx_buf.read != card->rx_buf.write && card->rx_buf_irq_enabled) {
      msi_notify(&card->pdev, 1);
      card->rx_buf_irq_enabled = 0;
    }
    qemu_mutex_unlock(&card->rx_buf_mutex);
  }
  return NULL;
}

static void *fejkon_tx_thread(void *opaque)
{
  FejkonState *card = opaque;
  while (!card->stopping) {
    sleep(1);
  }
  return NULL;
}

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
  card->sfp1_i2c.intr = sfp1_i2c_intr;
  card->sfp1_i2c.extra = card;
  card->sfp1_i2c.data[0] = 0x3;
  card->sfp1_i2c.data[1] = 0x4;
  strcpy((char*)&card->sfp1_i2c.data[20], "FEJKON TEST");
  card->sfp2_i2c.name = "sfp2";
  card->sfp2_i2c.intr = sfp2_i2c_intr;
  card->sfp2_i2c.extra = card;
  memcpy(&card->sfp2_i2c.data[0], &card->sfp1_i2c.data[0], 256);

  if (pcie_endpoint_cap_init(pdev, 0x80) < 0) {
    hw_error("Failed to initialize PCIe capability");
  }
  if (pcie_aer_init(pdev, PCI_ERR_VER, 0x100, PCI_ERR_SIZEOF, NULL) < 0) {
    hw_error("Failed to initialize AER capability");
  }

  qemu_mutex_init(&card->rx_buf_mutex);
  qemu_mutex_init(&card->tx_buf_mutex);
  qemu_thread_create(&card->rx_thread, "fejkon-port-rx", fejkon_rx_thread,
      card, QEMU_THREAD_JOINABLE);
  qemu_thread_create(&card->rx_irq_thread, "fejkon-port-rx-irq",
      fejkon_rx_irq_thread, card, QEMU_THREAD_JOINABLE);
  qemu_thread_create(&card->tx_thread, "fejkon-port-tx", fejkon_tx_thread,
      card, QEMU_THREAD_JOINABLE);
}

static void pci_fejkon_uninit(PCIDevice *pdev)
{
  FejkonState *card = FEJKON(pdev);
  msi_uninit(pdev);
  qemu_thread_join(&card->rx_thread);
  qemu_thread_join(&card->rx_irq_thread);
  qemu_thread_join(&card->tx_thread);
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
