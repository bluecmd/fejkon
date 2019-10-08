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
  struct net_device *net[MAX_PORTS];
  struct i2c_dev *i2c[MAX_PORTS];
  struct fejkon_port *port[MAX_PORTS];
  struct i2c_dev *temp_i2c;
	struct i2c_client *hwmon_client;
};

struct fejkon_port {
  struct fejkon_card *card;
  struct device *dev;
  int id;
};

/**
 * i2c_dev - I2C device context
 * @base: pointer to register struct
 * @msg: pointer to current message
 * @msg_len: number of bytes transferred in msg
 * @msg_err: error code for completed message
 * @msg_complete: xfer completion object
 * @dev: device reference
 * @adapter: core i2c abstraction
 * @bus_clk_rate: current i2c bus clock rate
 * @buf: ptr to msg buffer for easier use.
 * @fifo_size: size of the FIFO passed in.
 * @isr_mask: cached copy of local ISR enables.
 * @isr_status: cached copy of local ISR status.
 * @lock: spinlock for IRQ synchronization.
 */
struct i2c_dev {
  void __iomem *base;
  int irq;
  struct i2c_msg *msg;
  size_t msg_len;
  int msg_err;
  struct completion msg_complete;
  struct device *dev;
  struct i2c_adapter adapter;
  u32 bus_clk_rate;
  u8 *buf;
  u32 fifo_size;
  u32 isr_mask;
  u32 isr_status;
  spinlock_t lock;  /* IRQ synchronization */
};

#define PORT_RX_IRQ(x)      (2 + x * 4)
#define PORT_TX_IRQ(x)      (3 + x * 4)
#define PORT_SFP_IRQ(x)     (4 + x * 4)
#define PORT_SFP_I2C_IRQ(x) (5 + x * 4)

#define CLK 50 * 1000 * 1000

#define BAR2_SFP_I2C_OFFSET(x) (0x1000 * (x + 1) + 0x40)

struct i2c_dev * fejkon_i2c_probe(struct device *dev, void __iomem *base, int irq);

int fejkon_i2c_remove(struct i2c_dev *idev);

extern struct class *fejkon_class;

#endif
