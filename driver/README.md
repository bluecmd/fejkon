# Fejkon Driver

Development of the Fejkon kernel driver is done by using a custom QEMU device.
The QEMU device (found under `qemu-device`) emulates the behavior of the FPGA
allowing easy and quick development of the kernel driver (found under `src`).

The test harness (found under `test`) contains the test suite that will run
under emulated user space. It contains a bunch of functions that test the
various driver operations and return a test status.

## Usage

Dependencies: `libattr1-dev build-essential flex bison libssl-dev libelf-dev
libglib2.0-dev libpixman-1-dev libcap-ng-dev libpcap-dev bc golang wget`

Run the tests by running `make`.

After the initial compile, any incremental change should take around ~5-10 seconds
to compile and run. This has been a huge improvement for the usual 45 min turn-around
time when having to compile a new FPGA bitstream and work with a physical server.

## Kernel requirements

These are known requirements for fejkon:

 * `CONFIG_I2C_CHARDEV`
 * `CONFIG_IRQ_REMAP`

## Known Issues

If you get the following error make sure to upgrade linux-libc-dev to 4.19.118-2+deb10u1 or newer.
The bug report can [be found here](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=960271).

```
/usr/include/linux/swab.h: In function ‘__swab’:
/home/bluecmd/fejkon/driver/qemu/include/qemu/bitops.h:20:34: warning: "sizeof" is not defined, evaluates to 0 [-Wundef]
 #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
                                  ^~~~~~
/home/bluecmd/fejkon/driver/qemu/include/qemu/bitops.h:20:41: error: missing binary operator before token "("
 #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
 ```
