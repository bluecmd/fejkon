package main

import (
	"golang.org/x/sys/unix"
	"io/ioutil"
	"log"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
	"time"

	"github.com/bluecmd/go-sff"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
	"github.com/mdlayher/raw"
	"github.com/u-root/u-root/pkg/kmodule"
	"github.com/u-root/u-root/pkg/mount"
	"github.com/vishvananda/netlink"
)

func TestSemdPacket(t *testing.T) {
	ifi, err := net.InterfaceByName("fc0")
	if err != nil {
		log.Fatalf("failed to open interface: %v", err)
	}
	c, err := raw.ListenPacket(ifi, 0x0 /* ethertype */, nil)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	b := []byte{1, 2, 3, 4}
	addr := &raw.Addr{HardwareAddr: []byte{0xff, 0xff, 0xff}}
	if _, err := c.WriteTo(b, addr); err != nil {
		log.Fatalf("failed to write frame: %v", err)
	}

	// Continue to send this packet in the background for now
	go func() {
		for {
			if _, err := c.WriteTo(b, addr); err != nil {
				log.Printf("failed to write frame: %v", err)
			}
			time.Sleep(time.Millisecond * 100)
		}
	}()
}

func TestReadPacket(t *testing.T) {
	handle, err := pcap.OpenLive("fc0", 4096, true, pcap.BlockForever)
	if err != nil {
		t.Fatalf("OpenLive: %v", err)
	}
	// TODO: https://github.com/google/gopacket/pull/712
	err = handle.SetLinkType(layers.LinkType(225))
	if err != nil {
		t.Fatalf("SetLinkType: %v", err)
	}
	ps := gopacket.NewPacketSource(handle, handle.LinkType())

	i := 0
	for packet := range ps.Packets() {
		log.Printf("Packet: %v", packet)
		i++
		if i > 10 {
			return
		}
	}
}

func TestDumpLinkState(t *testing.T) {
	out, err := exec.Command("/bin/ip", "link").CombinedOutput()
	if err != nil {
		log.Fatalf("ip: %s", err)
	}
	log.Printf("ip link:\n%v", string(out))
}

func TestDumpInterrupts(t *testing.T) {
	t.Skip("needs to be manually enabled")
	out, err := ioutil.ReadFile("/proc/interrupts")
	if err != nil {
		log.Fatalf("/proc/interrupts: %s", err)
	}
	log.Printf("interrupts:\n%v", string(out))
}

func TestDumpDevices(t *testing.T) {
	t.Skip("needs to be manually enabled")
	out, err := ioutil.ReadFile("/proc/devices")
	if err != nil {
		log.Fatalf("/proc/devices: %s", err)
	}
	log.Printf("devices:\n%v", string(out))
}

func TestTestTempSensor(t *testing.T) {
	temp1, err := ioutil.ReadFile("/sys/class/hwmon/hwmon0/temp1_input")
	if err != nil {
		t.Fatalf("temp1_input: %v", err)
	}
	temp2, err := ioutil.ReadFile("/sys/class/hwmon/hwmon0/temp2_input")
	if err != nil {
		t.Fatalf("temp1_input: %v", err)
	}

	if (string(temp1) != "0\n") {
		t.Fatalf("temp1 expected to be 0, got '%v'", string(temp1))
	}
	if (string(temp2) != "0\n") {
		t.Fatalf("temp2 expected to be 0, got '%v'", string(temp2))
	}
}

func TestDumpI2C(t *testing.T) {
	m, err := filepath.Glob("/sys/class/i2c-dev/i2c-*/name")
	if err != nil {
		t.Fatalf("glob: %v", err)
	}
	fi2c := []string{}
	for _, f := range m {
		b, _ := ioutil.ReadFile(f)
		if string(b) == "fejkon\n" {
			fi2c = append(fi2c, f)
		}
	}

	if len(fi2c) != 3 {
		t.Fatalf("Expected 2 I2C buses, got %v", fi2c)
	}
}

func TestSFPPort(t *testing.T) {
	p, err := sff.Read("/dev/i2c-2")
	if err != nil {
		t.Fatalf("sff.Read failed: %v", err)
	}
	log.Printf("SFP 1: %v", p)

	p, err = sff.Read("/dev/i2c-3")
	if err != nil {
		t.Fatalf("sff.Read failed: %v", err)
	}
	log.Printf("SFP 2: %v", p)
}

func ifup(iface string) {
	l, err := netlink.LinkByName(iface)
	if err != nil {
		log.Fatalf("Unable to get interface %s: %v", iface, err)
	}
	h, err := netlink.NewHandle(unix.NETLINK_ROUTE)
	if err != nil {
		log.Fatalf("netlink.NewHandle: %v", err)
	}
	defer h.Delete()
	if err := h.LinkSetUp(l); err != nil {
		log.Fatalf("handle.LinkSetUp: %v", err)
	}
}

func ifdown(iface string) {
	l, err := netlink.LinkByName(iface)
	if err != nil {
		log.Fatalf("Unable to get interface %s: %v", iface, err)
	}
	h, err := netlink.NewHandle(unix.NETLINK_ROUTE)
	if err != nil {
		log.Fatalf("netlink.NewHandle: %v", err)
	}
	defer h.Delete()
	if err := h.LinkSetDown(l); err != nil {
		log.Fatalf("handle.LinkSetDown: %v", err)
	}
}

func insmod() {
	m, err := filepath.Glob("/lib/modules/*/extra/fejkon.ko")
	if err != nil {
		log.Fatalf("could not glob: %v", err)
	}
	f, err := os.Open(m[0])
	if err != nil {
		log.Fatalf("could not open %q: %v", m[0], err)
	}
	defer f.Close()

	if err := kmodule.FileInit(f, "", 0); err != nil {
		log.Fatalf("insmod: could not load %q: %v", m[0], err)
	}
}

func rmmod() {
	out, err := ioutil.ReadFile("/proc/modules")
	if err != nil {
		log.Fatalf("/proc/modules: %s", err)
	}
	log.Printf("modules:\n%v", string(out))

	if err := kmodule.Delete("fejkon", 0); err != nil {
		log.Fatalf("rmmod: could not unload: %v", err)
	}
}

func TestMain(m *testing.M) {
	if os.Getpid() != 1 || os.Getuid() != 0 {
		log.Fatalf("Test should be run inside VM as init")
	}

	// Set up environment
	mount.Mount("none", "/dev", "tmpfs", "", 0)
	mount.Mount("none", "/sys", "sysfs", "", 0)
	mount.Mount("none", "/proc", "proc", "", 0)

	unix.Mknod("/dev/null", unix.S_IFCHR|0600, 0x0103)
	unix.Mknod("/dev/i2c-2", unix.S_IFCHR|0600, 0x5902)
	unix.Mknod("/dev/i2c-3", unix.S_IFCHR|0600, 0x5903)

	// Dump PCI state before module load
	out, err := exec.Command("/bin/lspci", "-vv", "-d", "f1c0:0de5").CombinedOutput()
	if err != nil {
		log.Fatalf("lspci: %s", err)
	}
	log.Printf("lspci before module load:\n%v", string(out))

	insmod()

	// Dump PCI state after module load
	out, err = exec.Command("/bin/lspci", "-vv", "-d", "f1c0:0de5").CombinedOutput()
	if err != nil {
		log.Fatalf("lspci: %s", err)
	}
	log.Printf("lspci after module load:\n%v", string(out))

	ifup("fc0")

	// Run tests
	if m.Run() != 0 {
		log.Printf("Test failure")
		unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
	}

	// Test removing the module
	ifdown("fc0")
	rmmod()

	unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
}
