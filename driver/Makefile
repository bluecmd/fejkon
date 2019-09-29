.PHONY: test menuconfig

qemu:
	git clone https://github.com/qemu/qemu

build-qemu/x86_64-softmmu/qemu-system-x86_64: qemu
	(mkdir -p build-qemu; \
		cd build-qemu; \
		../qemu/configure --target-list=x86_64-softmmu --enable-virtfs; \
		make -j$(shell nproc))

linux:
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.1.tar.xz
	tar -xf linux-5.3.1.tar.xz
	mv linux-5.3.1 linux

root/sbin/init: $(wildcard test/*.go)
	go test -o root/sbin/init ./test

root:

menuconfig: linux
	make KCONFIG_CONFIG=$(PWD)/linux.config menuconfig -C linux/

linux/arch/x86/boot/bzImage: linux linux.config root
	make KCONFIG_CONFIG=$(PWD)/linux.config oldconfig -C linux/
	make KCONFIG_CONFIG=$(PWD)/linux.config -j$(shell nproc) -C linux/
	make KCONFIG_CONFIG=$(PWD)/linux.config INSTALL_MOD_PATH=$(PWD)/root/ modules_install -C linux/
	touch $@

test: build-qemu/x86_64-softmmu/qemu-system-x86_64 linux/arch/x86/boot/bzImage root/sbin/init
	build-qemu/x86_64-softmmu/qemu-system-x86_64 \
	 	-nographic -machine q35 \
		-fsdev local,id=root,path=$(PWD)/root,security_model=none,writeout=immediate \
		-device virtio-9p-pci,fsdev=root,mount_tag=/dev/root \
		-kernel linux/arch/x86/boot/bzImage \
		-append "root=hostfs rootfstype=9p rootflags=trans=virtio noinitrd console=ttyS0"
