.PHONY: test menuconfig

KERNEL=5.3.1

test: build-qemu/x86_64-softmmu/qemu-system-x86_64 linux/arch/x86/boot/bzImage root/sbin/init root/lib/modules/$(KERNEL)/extra/fejkon.ko
	# The tail -n+9 is to skip the SeaBIOS clearing of the screen
	build-qemu/x86_64-softmmu/qemu-system-x86_64 \
		-nographic -m 1G \
		-machine q35,kernel-irqchip=split \
		-device intel-iommu,intremap=on,device-iotlb=on \
		-fsdev local,id=root,path=$(CURDIR)/root,security_model=none,writeout=immediate \
		-device virtio-9p-pci,fsdev=root,mount_tag=/dev/root \
		-kernel linux/arch/x86/boot/bzImage \
		-device fejkon \
		-append "earlyprintk=serial root=hostfs rootfstype=9p rootflags=trans=virtio noinitrd console=ttyS0 loglevel=8" \
		| tail -n+10
	stty sane

qemu/.git/config:
	git clone https://github.com/qemu/qemu

qemu/hw/fejkon/Makefile.objs: qemu/.git/config
	rm -f qemu/hw/fejkon
	ln -sf $(CURDIR)/qemu-device qemu/hw/fejkon
	echo "devices-dirs-y += fejkon/" >> qemu/hw/Makefile.objs
	echo "common-obj-y += fejkon/" >> qemu/hw/Makefile.objs
	echo "obj-y += fejkon/" >> qemu/hw/Makefile.objs
	touch $@

build-qemu/config-all-devices.mak: qemu/.git/config qemu/hw/fejkon/Makefile.objs qemu-device/Makefile.objs
	(mkdir -p build-qemu && \
		cd build-qemu && \
		../qemu/configure \
			--target-list=x86_64-softmmu \
			--enable-virtfs)
	touch $@

build-qemu/x86_64-softmmu/qemu-system-x86_64: build-qemu/config-all-devices.mak $(wildcard qemu-device/*.c qemu-device/*.h)
	(cd build-qemu && make -j$(shell nproc))

linux-$(KERNEL).tar.xz:
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$(KERNEL).tar.xz

linux: linux-$(KERNEL).tar.xz
	tar -xf linux-$(KERNEL).tar.xz
	mv linux-$(KERNEL) linux

root/sbin/init: $(wildcard test/*.go)
	go get -t ./test/...
	go test -ldflags '-extldflags -static' -c -o root/sbin/init ./test

root: root/dev root/proc root/sys

root/dev:
	mkdir -p $@

root/proc:
	mkdir -p $@

root/sys:
	mkdir -p $@

root/lib/modules/5.3.1/extra/fejkon.ko: $(wildcard src/*.c src/*.h)
	(cd src/ && make && make install)

menuconfig: linux
	make KCONFIG_CONFIG=$(CURDIR)/linux.config menuconfig -C linux/
	make KCONFIG_CONFIG=$(CURDIR)/linux.config savedefconfig -C linux/

linux/arch/x86/boot/bzImage: linux linux.config root
	make KCONFIG_CONFIG=$(CURDIR)/linux.config olddefconfig -C linux/
	make KCONFIG_CONFIG=$(CURDIR)/linux.config -j$(shell nproc) -C linux/
	make KCONFIG_CONFIG=$(CURDIR)/linux.config INSTALL_MOD_PATH=$(CURDIR)/root/ modules_install -C linux/
	make KCONFIG_CONFIG=$(CURDIR)/linux.config savedefconfig -C linux/
	mv linux/defconfig linux.config
	touch $@
