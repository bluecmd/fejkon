#ifndef _FEJKON_H_
#define _FEJKON_H_

#include <linux/i2c.h>
#include <linux/pci.h>

#define MAX_PORTS 4

struct net_device;
struct i2c_dev;
struct fejkon_port;

struct fejkon_card {
  struct pci_dev *pci;
  void __iomem *bar2;
  struct fejkon_port *port[MAX_PORTS];
};

struct fejkon_port {
  struct fejkon_card *card;
  struct device *dev;
  struct net_device *net;
  struct i2c_dev *i2c;
  int id;
};

#define PORT_RX_IRQ(x)      (1 + x * 4)
#define PORT_TX_IRQ(x)      (2 + x * 4)
#define PORT_SFP_IRQ(x)     (3 + x * 4)
#define PORT_SFP_I2C_IRQ(x) (4 + x * 4)

#define SFP_PRESENT    (1 << 0)
#define SFP_LOS        (1 << 1)
#define SFP_TX_FAIL    (1 << 2)
#define SFP_TX_DISABLE (1 << 3)
#define SFP_RATE_SEL   (1 << 4)
#define SFP_I2C_RESET  (1 << 6)

#define CLK 50 * 1000 * 1000

#define BAR2_SFP_I2C_OFFSET(x)    (0x1000 * (x + 1) + 0x40)
#define BAR2_SFP_STATUS_OFFSET(x) (0x1000 * (x + 1) + 0x0)

struct i2c_dev * fejkon_i2c_probe(struct device *dev, void __iomem *base, int irq);

int fejkon_i2c_remove(struct i2c_dev *idev);

struct i2c_adapter * fejkon_i2c_adapter(struct i2c_dev *idev);

extern struct class *fejkon_class;

#endif
