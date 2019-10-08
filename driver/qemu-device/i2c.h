#ifndef _FEJKON_I2C_H_
#define _FEJKON_I2C_H_

struct avalon_i2c {
  const char *name;
  bool enable;
  uint8_t read_off;
  int fifo_level;
  bool is_writing;
  bool rx_intr;
  bool tx_intr;
  void (*intr)(void*);
  void *extra;
  uint8_t data[256];
};

uint64_t avalon_i2c_read(struct avalon_i2c *, hwaddr);
void avalon_i2c_write(struct avalon_i2c *, hwaddr, uint64_t);

#endif
