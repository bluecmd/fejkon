package main

import (
	"encoding/binary"
	"errors"
	"golang.org/x/sys/unix"
	"io/ioutil"
	"log"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"github.com/bluecmd/go-sff"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/afpacket"
	"github.com/mdlayher/raw"
	"github.com/u-root/u-root/pkg/kmodule"
	"github.com/u-root/u-root/pkg/mount"
	"github.com/vishvananda/netlink"
)

var (
	LayerTypeFC = gopacket.RegisterLayerType(8000, gopacket.LayerTypeMetadata{Name: "Fibre Channel", Decoder: gopacket.DecodeFunc(decodeFC)})
)

func TestSendPacket(t *testing.T) {
	ifi, err := net.InterfaceByName("fc0")
	if err != nil {
		log.Fatalf("failed to open interface: %v", err)
	}
	c, err := raw.ListenPacket(ifi, 0x0 /* ethertype */, nil)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	b := make([]byte, 2148)
	addr := &raw.Addr{HardwareAddr: []byte{0xff, 0xff, 0xff}}
	go func() {
		for i := 0; i < 10; i++ {
			if _, err := c.WriteTo(b, addr); err != nil {
				log.Fatalf("failed to write frame: %v", err)
			}
		}
	}()
}

// TODO: Move to fikonfarm
type FibreChannel struct {
	layers.BaseLayer
	SOF     uint32
	// TODO
	CRC     uint32
	EOF     uint32
}

func (l *FibreChannel) LayerType() gopacket.LayerType { return LayerTypeFC }

func decodeFC(data []byte, p gopacket.PacketBuilder) error {
	l := &FibreChannel{}
	err := l.DecodeFromBytes(data, p)
	if err != nil {
		return err
	}
	p.AddLayer(l)
	return p.NextDecoder(l.NextLayerType())
}

// DecodeFromBytes decodes the given bytes into this layer.
func (l *FibreChannel) DecodeFromBytes(data []byte, df gopacket.DecodeFeedback) error {
	c := len(data)
	if c < 36 {
		return errors.New("Fibre Channel frame size too small")
	}
	l.SOF = binary.BigEndian.Uint32(data[0:4])
	l.CRC = binary.BigEndian.Uint32(data[c-8:c-4])
	l.EOF = binary.BigEndian.Uint32(data[c-4:c])
	l.Contents = data[:28]
	l.Payload = data[28:c-8]
	return nil
}

func (l *FibreChannel) CanDecode() gopacket.LayerClass {
	return LayerTypeFC
}

func (l *FibreChannel) NextLayerType() gopacket.LayerType {
	return gopacket.LayerTypeZero
}

func TestReadPacket(t *testing.T) {
	handle, err := afpacket.NewTPacket(afpacket.OptInterface("fc0"))
	if err != nil {
		t.Fatalf("NewTPacket: %v", err)
	}
	// TODO: Figure out best way to filter from reading our own sent packets
	ps := gopacket.NewPacketSource(handle, LayerTypeFC)

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

func TestDumpEthtool(t *testing.T) {
	out, err := exec.Command("/bin/ethtool", "fc0").CombinedOutput()
	if err != nil {
		t.Errorf("ethtool fc0: err: %s, out: %s", err, string(out))
		return
	}
	log.Printf("ethtool fc0:\n%v", string(out))
}

func TestDumpEthtoolDriver(t *testing.T) {
	out, err := exec.Command("/bin/ethtool", "-i", "fc0").CombinedOutput()
	if err != nil {
		t.Errorf("ethtool -i fc0: err: %s, out: %s", err, string(out))
		return
	}
	log.Printf("ethtool -i fc0:\n%v", string(out))
}

func TestDumpIprouteStats(t *testing.T) {
	out, err := exec.Command("/bin/ip", "-s", "link", "show", "dev", "fc0").CombinedOutput()
	if err != nil {
		t.Errorf("ip -s link show dev fc0: err: %s, out: %s", err, string(out))
		return
	}
	log.Printf("ip -s link show dev fc0:\n%v", string(out))
}

// TODO: Implement?
//func TestDumpEthtoolSfp(t *testing.T) {
//	out, err := exec.Command("/bin/ethtool", "-m", "fc0").CombinedOutput()
//	if err != nil {
//		t.Errorf("ethtool -m fc0: err: %s, out: %s", err, string(out))
//		return
//	}
//	log.Printf("ethtool -m fc0:\n%v", string(out))
//}

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

func TestPHYFrequency(t *testing.T) {
	m, err := filepath.Glob("/sys/bus/pci/drivers/fejkon/*/phy_freq")
	if err != nil {
		t.Fatalf("glob: %v", err)
	}
	if len(m) != 1 {
		t.Fatalf("expected exactly one match, got %v", m)
	}
	freq, err := ioutil.ReadFile(m[0])
	if err != nil {
		t.Fatalf("freq ReadFile: %v", err)
	}
	f, err := strconv.Atoi(strings.TrimSpace(string(freq)))
	if err != nil {
		t.Fatalf("freq strconv: %v", err)
	}
	if f < 106249900 || f > 106250100 {
		t.Errorf("expected 106249900 < f < 106250100, got f = %v", f)
	}
}

func TestTempSensor(t *testing.T) {
	temp1, err := ioutil.ReadFile("/sys/class/hwmon/hwmon0/temp1_input")
	if err != nil {
		t.Fatalf("temp1_input: %v", err)
	}

	c, err := strconv.Atoi(strings.TrimSpace(string(temp1)))
	c = c / 1000
	if err != nil {
		t.Fatalf("temp1_input strconv: %v", err)
	}
	if (c < 50 || c > 80) {
		t.Errorf("temp1 expected to be between 50 and 80, got %d", c)
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
		if strings.Contains(string(b), "fejkon") {
			fi2c = append(fi2c, f)
		}
	}

	if len(fi2c) != 2 {
		t.Errorf("Expected 2 I2C buses, got %v", fi2c)
	}
}

func TestSFPPort(t *testing.T) {
	p, err := sff.Read("/dev/i2c-1")
	if err != nil {
		t.Fatalf("sff.Read failed: %v", err)
	}
	log.Printf("SFP 1: %v", p)

	p, err = sff.Read("/dev/i2c-2")
	if err != nil {
		t.Fatalf("sff.Read failed: %v", err)
	}
	log.Printf("SFP 2: %v", p)
}

func TestLOSIsNoCarrier(t *testing.T) {
	// fc1 is set up to have not-active state
	fc0, _ := netlink.LinkByName("fc0")
	if fc0.Attrs().OperState != netlink.OperUp {
		t.Errorf("fc0 expected to be up, is %s", fc0.Attrs().OperState)
	}
	fc1, _ := netlink.LinkByName("fc1")
	if fc1.Attrs().OperState != netlink.OperDormant {
		t.Errorf("fc1 expected to be dormant, is %s", fc1.Attrs().OperState)
	}
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
	if err := kmodule.Delete("fejkon", 0); err != nil {
		log.Fatalf("rmmod: could not unload: %v", err)
	}
	out, err := ioutil.ReadFile("/proc/modules")
	if err != nil {
		log.Fatalf("/proc/modules: %s", err)
	}
	if string(out) != "" {
		log.Fatalf("/proc/modules expected to be empty, contained:\n:%s", out)
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
	unix.Mknod("/dev/i2c-1", unix.S_IFCHR|0600, 0x5901)
	unix.Mknod("/dev/i2c-2", unix.S_IFCHR|0600, 0x5902)

	// Dump PCI state before module load
	out, err := exec.Command("/bin/lspci", "-vv", "-d", "f1c0:0de5").CombinedOutput()
	if err != nil {
		log.Fatalf("lspci: %s", err)
	}
	log.Printf("lspci before module load:\n%v", string(out))

	insmod()

	// Try to remove and re-load
	ifup("fc0")
	ifdown("fc0")
	log.Printf("Removing module")
	rmmod()
	if _, err := netlink.LinkByName("fc0"); err == nil {
		log.Fatalf("fc0 interface still around after module unloaded")
	}
	log.Printf("Re-loading module")
	insmod()

	// Dump PCI state after module load
	out, err = exec.Command("/bin/lspci", "-vv", "-d", "f1c0:0de5").CombinedOutput()
	if err != nil {
		log.Fatalf("lspci: %s", err)
	}
	log.Printf("lspci after module load:\n%v", string(out))

	ifup("fc0")
	ifup("fc1")

	// Run tests
	if m.Run() != 0 {
		log.Printf("Test failure")
		unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
	}

	// Test removing the module
	ifdown("fc0")

	// Dump all open files to help with debugging if rmmod fails
	ma, _ := filepath.Glob("/proc/self/fd/*")
	for _, a := range ma {
		f, _ := os.Readlink(a)
		log.Printf("open file: %v", f)
	}

	rmmod()

	unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
}
