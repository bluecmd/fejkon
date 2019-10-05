obj-m += fejkon.o
ccflags-y := -Wall -DDEBUG
fejkon-objs := i2c.o board.o

.PHONY: all clean

all:
	make -C ../linux/ M="$(PWD)" modules

clean:
	make -C ../linux/ M="$(PWD)" clean

install:
	make -C ../linux/ M="$(PWD)" INSTALL_MOD_PATH=$(PWD)/../root modules_install
