#ifndef _FEJKON_H_
#define _FEJKON_H_

#include <linux/i2c.h>
#include <linux/netdevice.h>
#include <linux/pci.h>
#include <linux/timer.h>

#define MAX_PORTS 4

struct i2c_dev;
struct fejkon_port;

struct fejkon_card {
  struct pci_dev *pci;
  void __iomem *bar0;
  struct fejkon_port *port[MAX_PORTS];
  struct napi_struct napi;
  void *rx_buf_start;
  dma_addr_t rx_buf_start_dma;
  void *rx_buf_read;
  void *rx_buf_end;
  void *tx_buf_start;
  dma_addr_t tx_buf_start_dma;
  void *tx_buf_write;
  void *tx_buf_read_cached;
  void *tx_buf_end;
};

struct fejkon_port {
  struct fejkon_card *card;
  struct device *dev;
  struct net_device *net;
  struct i2c_dev *i2c;
  struct timer_list refresh_timer;
  int id;
};

#define PORT_SFP_I2C_IRQ(x) (3 + x)

#define SFP_PRESENT    (1 << 0)
#define SFP_LOS        (1 << 1)
#define SFP_TX_FAIL    (1 << 2)
#define SFP_TX_DISABLE (1 << 3)
#define SFP_RATE_SEL   (1 << 4)
#define SFP_I2C_RESET  (1 << 6)

#define CLK 50 * 1000 * 1000

#define BAR0_SFP_I2C_OFFSET(x)    (0x100 * ((x) + 1) + 0x40)
#define BAR0_SFP_STATUS_OFFSET(x) (0x100 * ((x) + 1) + 0x0)
#define BAR0_FC_STATE_OFFSET(x)   (0x2000 * (x) + 0x9000)

struct i2c_dev * fejkon_i2c_probe(struct device *dev, void __iomem *base, int irq);

int fejkon_i2c_remove(struct i2c_dev *idev);

struct i2c_adapter * fejkon_i2c_adapter(struct i2c_dev *idev);

extern struct class *fejkon_class;

#endif
