package main

import (
	"golang.org/x/sys/unix"
	"log"
	"net"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
	"github.com/mdlayher/raw"
	"github.com/u-root/u-root/pkg/kmodule"
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
				log.Fatalf("failed to write frame: %v", err)
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
	for packet := range ps.Packets() {
		log.Printf("Packet: %v", packet)
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

func TestMain(m *testing.M) {
	if os.Getpid() != 1 || os.Getuid() != 0 {
		log.Fatalf("Test should be run inside VM as init")
	}

	insmod()
	ifup("fc0")

	m.Run()
	unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
}
