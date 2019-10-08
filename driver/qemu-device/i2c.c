/*
 * QEMU I2C of Intel Avalon I2C master
 *
 * Copyright (c) 2019 Christian Svensson
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
#include "exec/hwaddr.h"

#include "i2c.h"

#define REG_TX         0x0
#define REG_RX         0x4
#define REG_CTRL       0x8
#define REG_ISER       0xC
#define REG_ISR        0x10
#define REG_STATUS     0x14
#define REG_TX_LVL     0x18
#define REG_RX_LVL     0x1C
#define REG_SCL_LOW    0x20
#define REG_SCL_HIGH   0x24
#define REG_SDA_HOLD   0x28


uint64_t avalon_i2c_read(struct avalon_i2c *i2c, hwaddr reg) {
  uint64_t val = 0ULL;
  switch (reg) {
    case REG_RX:
      if (i2c->fifo_level == 0) {
        return 0;
      }
      i2c->fifo_level--;
      return i2c->data[i2c->read_off++];
    case REG_CTRL:
      return i2c->enable ? 1ULL : 0ULL;
    case REG_ISER:
      return (i2c->rx_intr << 1) | i2c->tx_intr;
    case REG_ISR:
      /* Always set TX ready, RX is dependent on fifo level */
      return ((i2c->fifo_level > 0) << 1) | 1;
    case REG_STATUS:
      return 0ULL;
    case REG_TX_LVL:
      /* Always TX space available */
      return 0ULL;
    case REG_RX_LVL:
      return i2c->fifo_level;
    default:
      printf("fejkon: Read from unknown I2C register: 0x%lx\n", reg);
      break;
  }

  return val;
}

void avalon_i2c_write(struct avalon_i2c *i2c, hwaddr reg, uint64_t val) {
  switch (reg) {
    case REG_TX:
      /* No write support implemented, so assume any write is an address
       * followed by reads */
      if ((val & (1<<9))) {
        i2c->is_writing = ((val & 0x1) == 0);
      } else if (i2c->is_writing) {
        i2c->read_off = val & 0xff;
        /* Consume all TX bytes straight away */
        if (i2c->enable && i2c->tx_intr) {
          i2c->intr(i2c->extra);
        }
      } else {
        i2c->fifo_level++;
        /* RX is available straight away */
        if (i2c->enable && i2c->rx_intr) {
          i2c->intr(i2c->extra);
        }
      }
      break;
    case REG_CTRL:
      if (val == 0) {
        i2c->enable = false;
      } else if (val == 1) {
        i2c->enable = true;
        i2c->fifo_level = 0;
      } else {
        printf("fejkon: Unknown ctrl write: 0x%lx\n", val);
      }
      break;
    case REG_ISER:
      i2c->tx_intr = (val & 1);
      i2c->rx_intr = (val & 2);
      break;
    case REG_ISR:
      /* Ignore interrupt ACKs */
      break;
    case REG_SCL_LOW:
    case REG_SCL_HIGH:
    case REG_SDA_HOLD:
      /* Timing setup ignored in simulation */
      break;
    default:
      printf("fejkon: Write to unknown I2C register: 0x%lx\n", reg);
      break;
  }
}
