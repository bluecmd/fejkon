obj-m += fejkon.o
ccflags-y := -Wall -DDEBUG
fejkon-objs := i2c.o board.o

ABS_ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/

.PHONY: all clean

all:
	make -C ../linux/ M="$(ABS_ROOT_DIR)" modules

clean:
	make -C ../linux/ M="$(ABS_ROOT_DIR)" clean

install:
	make -C ../linux/ M="$(ABS_ROOT_DIR)" INSTALL_MOD_PATH=$(ABS_ROOT_DIR)/../root modules_install
