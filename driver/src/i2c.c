// SPDX-License-Identifier: GPL-2.0-only
/*
 * I2C port driver for SFP ports on Fejkon.
 *
 * Based on the i2c-altera.c driver.
 */
#include "fejkon.h"

#include <linux/clk.h>
#include <linux/clkdev.h>
#include <linux/device.h>
#include <linux/err.h>
#include <linux/i2c.h>
#include <linux/iopoll.h>
#include <linux/interrupt.h>
#include <linux/module.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>

#define ALTR_I2C_TFR_CMD  0x00  /* Transfer Command register */
#define     ALTR_I2C_TFR_CMD_STA  BIT(9)  /* send START before byte */
#define     ALTR_I2C_TFR_CMD_STO  BIT(8)  /* send STOP after byte */
#define     ALTR_I2C_TFR_CMD_RW_D BIT(0)  /* Direction of transfer */
#define ALTR_I2C_RX_DATA  0x04  /* RX data FIFO register */
#define ALTR_I2C_CTRL   0x08  /* Control register */
#define     ALTR_I2C_CTRL_RXT_SHFT  4 /* RX FIFO Threshold */
#define     ALTR_I2C_CTRL_TCT_SHFT  2 /* TFER CMD FIFO Threshold */
#define     ALTR_I2C_CTRL_BSPEED  BIT(1)  /* Bus Speed (1=Fast) */
#define     ALTR_I2C_CTRL_EN  BIT(0)  /* Enable Core (1=Enable) */
#define ALTR_I2C_ISER   0x0C  /* Interrupt Status Enable register */
#define     ALTR_I2C_ISER_RXOF_EN BIT(4)  /* Enable RX OVERFLOW IRQ */
#define     ALTR_I2C_ISER_ARB_EN  BIT(3)  /* Enable ARB LOST IRQ */
#define     ALTR_I2C_ISER_NACK_EN BIT(2)  /* Enable NACK DET IRQ */
#define     ALTR_I2C_ISER_RXRDY_EN  BIT(1)  /* Enable RX Ready IRQ */
#define     ALTR_I2C_ISER_TXRDY_EN  BIT(0)  /* Enable TX Ready IRQ */
#define ALTR_I2C_ISR    0x10  /* Interrupt Status register */
#define     ALTR_I2C_ISR_RXOF   BIT(4)  /* RX OVERFLOW IRQ */
#define     ALTR_I2C_ISR_ARB    BIT(3)  /* ARB LOST IRQ */
#define     ALTR_I2C_ISR_NACK   BIT(2)  /* NACK DET IRQ */
#define     ALTR_I2C_ISR_RXRDY    BIT(1)  /* RX Ready IRQ */
#define     ALTR_I2C_ISR_TXRDY    BIT(0)  /* TX Ready IRQ */
#define ALTR_I2C_STATUS   0x14  /* Status register */
#define     ALTR_I2C_STAT_CORE    BIT(0)  /* Core Status (0=idle) */
#define ALTR_I2C_TC_FIFO_LVL  0x18  /* Transfer FIFO LVL register */
#define ALTR_I2C_RX_FIFO_LVL  0x1C  /* Receive FIFO LVL register */
#define ALTR_I2C_SCL_LOW  0x20  /* SCL low count register */
#define ALTR_I2C_SCL_HIGH 0x24  /* SCL high count register */
#define ALTR_I2C_SDA_HOLD 0x28  /* SDA hold count register */

#define ALTR_I2C_ALL_IRQ  (ALTR_I2C_ISR_RXOF | ALTR_I2C_ISR_ARB | \
         ALTR_I2C_ISR_NACK | ALTR_I2C_ISR_RXRDY | \
         ALTR_I2C_ISR_TXRDY)

#define ALTR_I2C_THRESHOLD  0 /* IRQ Threshold at 1 element */
#define ALTR_I2C_DFLT_FIFO_SZ 4
#define ALTR_I2C_TIMEOUT  100000  /* 100ms */
#define ALTR_I2C_XFER_TIMEOUT (msecs_to_jiffies(250))

static void
altr_i2c_int_enable(struct i2c_dev *idev, u32 mask, bool enable)
{
  unsigned long flags;
  u32 int_en;

  spin_lock_irqsave(&idev->lock, flags);

  int_en = readl(idev->base + ALTR_I2C_ISER);
  if (enable)
    idev->isr_mask = int_en | mask;
  else
    idev->isr_mask = int_en & ~mask;

  writel(idev->isr_mask, idev->base + ALTR_I2C_ISER);

  spin_unlock_irqrestore(&idev->lock, flags);
}

static void altr_i2c_int_clear(struct i2c_dev *idev, u32 mask)
{
  u32 int_en = readl(idev->base + ALTR_I2C_ISR);

  writel(int_en | mask, idev->base + ALTR_I2C_ISR);
}

static void altr_i2c_core_disable(struct i2c_dev *idev)
{
  u32 tmp = readl(idev->base + ALTR_I2C_CTRL);

  writel(tmp & ~ALTR_I2C_CTRL_EN, idev->base + ALTR_I2C_CTRL);
}

static void altr_i2c_core_enable(struct i2c_dev *idev)
{
  u32 tmp = readl(idev->base + ALTR_I2C_CTRL);

  writel(tmp | ALTR_I2C_CTRL_EN, idev->base + ALTR_I2C_CTRL);
}

static void altr_i2c_reset(struct i2c_dev *idev)
{
  altr_i2c_core_disable(idev);
  altr_i2c_core_enable(idev);
}

static inline void altr_i2c_stop(struct i2c_dev *idev)
{
  writel(ALTR_I2C_TFR_CMD_STO, idev->base + ALTR_I2C_TFR_CMD);
}

static void altr_i2c_init(struct i2c_dev *idev)
{
  u32 divisor = CLK / idev->bus_clk_rate;
  u32 clk_mhz = CLK / 1000000;
  u32 tmp = (ALTR_I2C_THRESHOLD << ALTR_I2C_CTRL_RXT_SHFT) |
      (ALTR_I2C_THRESHOLD << ALTR_I2C_CTRL_TCT_SHFT);
  u32 t_high, t_low;

  if (idev->bus_clk_rate <= 100000) {
    tmp &= ~ALTR_I2C_CTRL_BSPEED;
    /* Standard mode SCL 50/50 */
    t_high = divisor * 1 / 2;
    t_low = divisor * 1 / 2;
  } else {
    tmp |= ALTR_I2C_CTRL_BSPEED;
    /* Fast mode SCL 33/66 */
    t_high = divisor * 1 / 3;
    t_low = divisor * 2 / 3;
  }
  writel(tmp, idev->base + ALTR_I2C_CTRL);

  dev_dbg(idev->dev, "rate=%uHz per_clk=%uMHz -> ratio=1:%u\n",
    idev->bus_clk_rate, clk_mhz, divisor);

  /* Reset controller */
  altr_i2c_reset(idev);

  /* SCL High Time */
  writel(t_high, idev->base + ALTR_I2C_SCL_HIGH);
  /* SCL Low Time */
  writel(t_low, idev->base + ALTR_I2C_SCL_LOW);
  /* SDA Hold Time, 300ns */
  writel(div_u64(300 * clk_mhz, 1000), idev->base + ALTR_I2C_SDA_HOLD);

  /* Mask all master interrupt bits */
  altr_i2c_int_enable(idev, ALTR_I2C_ALL_IRQ, false);
}

/**
 * altr_i2c_transfer - On the last byte to be transmitted, send
 * a Stop bit on the last byte.
 */
static void altr_i2c_transfer(struct i2c_dev *idev, u32 data)
{
  /* On the last byte to be transmitted, send STOP */
  if (idev->msg_len == 1)
    data |= ALTR_I2C_TFR_CMD_STO;
  if (idev->msg_len > 0)
    writel(data, idev->base + ALTR_I2C_TFR_CMD);
}

/**
 * altr_i2c_empty_rx_fifo - Fetch data from RX FIFO until end of
 * transfer. Send a Stop bit on the last byte.
 */
static void altr_i2c_empty_rx_fifo(struct i2c_dev *idev)
{
  size_t rx_fifo_avail = readl(idev->base + ALTR_I2C_RX_FIFO_LVL);
  int bytes_to_transfer = min(rx_fifo_avail, idev->msg_len);

  while (bytes_to_transfer-- > 0) {
    *idev->buf++ = readl(idev->base + ALTR_I2C_RX_DATA);
    idev->msg_len--;
    altr_i2c_transfer(idev, 0);
  }
}

/**
 * altr_i2c_fill_tx_fifo - Fill TX FIFO from current message buffer.
 * @return: Number of bytes left to transfer.
 */
static int altr_i2c_fill_tx_fifo(struct i2c_dev *idev)
{
  size_t tx_fifo_avail = idev->fifo_size - readl(idev->base +
                   ALTR_I2C_TC_FIFO_LVL);
  int bytes_to_transfer = min(tx_fifo_avail, idev->msg_len);
  int ret = idev->msg_len - bytes_to_transfer;

  while (bytes_to_transfer-- > 0) {
    altr_i2c_transfer(idev, *idev->buf++);
    idev->msg_len--;
  }

  return ret;
}

static irqreturn_t altr_i2c_isr_quick(int irq, void *_dev)
{
  struct i2c_dev *idev = _dev;
  irqreturn_t ret = IRQ_HANDLED;

  /* Read IRQ status but only interested in Enabled IRQs. */
  idev->isr_status = readl(idev->base + ALTR_I2C_ISR) & idev->isr_mask;
  if (idev->isr_status)
    ret = IRQ_WAKE_THREAD;

  return ret;
}

static irqreturn_t altr_i2c_isr(int irq, void *_dev)
{
  int ret;
  bool read, finish = false;
  struct i2c_dev *idev = _dev;
  u32 status = idev->isr_status;

  if (!idev->msg) {
    dev_warn(idev->dev, "unexpected interrupt\n");
    altr_i2c_int_clear(idev, ALTR_I2C_ALL_IRQ);
    return IRQ_HANDLED;
  }
  read = (idev->msg->flags & I2C_M_RD) != 0;

  /* handle Lost Arbitration */
  if (unlikely(status & ALTR_I2C_ISR_ARB)) {
    altr_i2c_int_clear(idev, ALTR_I2C_ISR_ARB);
    idev->msg_err = -EAGAIN;
    finish = true;
  } else if (unlikely(status & ALTR_I2C_ISR_NACK)) {
    dev_dbg(idev->dev, "Could not get ACK\n");
    idev->msg_err = -ENXIO;
    altr_i2c_int_clear(idev, ALTR_I2C_ISR_NACK);
    altr_i2c_stop(idev);
    finish = true;
  } else if (read && unlikely(status & ALTR_I2C_ISR_RXOF)) {
    /* handle RX FIFO Overflow */
    altr_i2c_empty_rx_fifo(idev);
    altr_i2c_int_clear(idev, ALTR_I2C_ISR_RXRDY);
    altr_i2c_stop(idev);
    dev_err(idev->dev, "RX FIFO Overflow\n");
    finish = true;
  } else if (read && (status & ALTR_I2C_ISR_RXRDY)) {
    /* RX FIFO needs service? */
    altr_i2c_empty_rx_fifo(idev);
    altr_i2c_int_clear(idev, ALTR_I2C_ISR_RXRDY);
    if (!idev->msg_len)
      finish = true;
  } else if (!read && (status & ALTR_I2C_ISR_TXRDY)) {
    /* TX FIFO needs service? */
    altr_i2c_int_clear(idev, ALTR_I2C_ISR_TXRDY);
    if (idev->msg_len > 0)
      altr_i2c_fill_tx_fifo(idev);
    else
      finish = true;
  } else {
    dev_warn(idev->dev, "Unexpected interrupt: 0x%x\n", status);
    altr_i2c_int_clear(idev, ALTR_I2C_ALL_IRQ);
  }

  if (finish) {
    /* Wait for the Core to finish */
    ret = readl_poll_timeout_atomic(idev->base + ALTR_I2C_STATUS,
            status,
            !(status & ALTR_I2C_STAT_CORE),
            1, ALTR_I2C_TIMEOUT);
    if (ret)
      dev_err(idev->dev, "message timeout\n");
    altr_i2c_int_enable(idev, ALTR_I2C_ALL_IRQ, false);
    altr_i2c_int_clear(idev, ALTR_I2C_ALL_IRQ);
    complete(&idev->msg_complete);
  }

  return IRQ_HANDLED;
}

static int altr_i2c_xfer_msg(struct i2c_dev *idev, struct i2c_msg *msg)
{
  u32 imask = ALTR_I2C_ISR_RXOF | ALTR_I2C_ISR_ARB | ALTR_I2C_ISR_NACK;
  unsigned long time_left;
  u32 value;
  u8 addr = i2c_8bit_addr_from_msg(msg);

  idev->msg = msg;
  idev->msg_len = msg->len;
  idev->buf = msg->buf;
  idev->msg_err = 0;
  reinit_completion(&idev->msg_complete);
  altr_i2c_core_enable(idev);

  /* Make sure RX FIFO is empty */
  do {
    readl(idev->base + ALTR_I2C_RX_DATA);
  } while (readl(idev->base + ALTR_I2C_RX_FIFO_LVL));

  writel(ALTR_I2C_TFR_CMD_STA | addr, idev->base + ALTR_I2C_TFR_CMD);

  if ((msg->flags & I2C_M_RD) != 0) {
    imask |= ALTR_I2C_ISER_RXOF_EN | ALTR_I2C_ISER_RXRDY_EN;
    altr_i2c_int_enable(idev, imask, true);
    /* write the first byte to start the RX */
    altr_i2c_transfer(idev, 0);
  } else {
    imask |= ALTR_I2C_ISR_TXRDY;
    altr_i2c_int_enable(idev, imask, true);
    altr_i2c_fill_tx_fifo(idev);
  }

  time_left = wait_for_completion_timeout(&idev->msg_complete,
            ALTR_I2C_XFER_TIMEOUT);
  altr_i2c_int_enable(idev, imask, false);

  value = readl(idev->base + ALTR_I2C_STATUS) & ALTR_I2C_STAT_CORE;
  if (value)
    dev_err(idev->dev, "Core Status not IDLE...\n");

  if (time_left == 0) {
    idev->msg_err = -ETIMEDOUT;
    dev_dbg(idev->dev, "Transaction timed out.\n");
  }

  altr_i2c_core_disable(idev);

  return idev->msg_err;
}

static int
altr_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
{
  struct i2c_dev *idev = i2c_get_adapdata(adap);
  int i, ret;

  for (i = 0; i < num; i++) {
    ret = altr_i2c_xfer_msg(idev, msgs++);
    if (ret)
      return ret;
  }
  return num;
}

static u32 altr_i2c_func(struct i2c_adapter *adap)
{
  return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
}

static const struct i2c_algorithm altr_i2c_algo = {
  .master_xfer = altr_i2c_xfer,
  .functionality = altr_i2c_func,
};

struct i2c_dev * fejkon_i2c_probe(struct device *dev, void __iomem *base, int irq)
{
  struct i2c_dev *idev = NULL;
  int ret;

  idev = devm_kzalloc(dev, sizeof(*idev), GFP_KERNEL);
  if (!idev)
    return NULL;

  idev->base = base;
  idev->dev = device_create(
      fejkon_class, dev, MKDEV(0, 0), NULL, "%s i2c", dev_name(dev));
  init_completion(&idev->msg_complete);
  spin_lock_init(&idev->lock);

  idev->fifo_size = 64;
  idev->bus_clk_rate = 100000;  /* 100 kHz */
  ret = devm_request_threaded_irq(dev, irq, altr_i2c_isr_quick,
          altr_i2c_isr, IRQF_ONESHOT, KBUILD_MODNAME, idev);
  if (ret) {
    dev_err(idev->dev, "failed to claim IRQ %d\n", irq);
    return NULL;
  }

  altr_i2c_init(idev);

  i2c_set_adapdata(&idev->adapter, idev);
  strlcpy(idev->adapter.name, KBUILD_MODNAME, sizeof(idev->adapter.name));
  idev->adapter.owner = THIS_MODULE;
  idev->adapter.algo = &altr_i2c_algo;
  idev->adapter.dev.parent = dev;
  idev->adapter.dev.of_node = dev->of_node;

  if (i2c_add_adapter(&idev->adapter) < 0) {
    return NULL;
  }
  return idev;
}

int fejkon_i2c_remove(struct i2c_dev *idev)
{
  i2c_del_adapter(&idev->adapter);
  device_unregister(idev->dev);
  return 0;
}
