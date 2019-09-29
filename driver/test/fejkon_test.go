package main

import (
	"github.com/u-root/u-root/pkg/kmodule"
	"golang.org/x/sys/unix"
	"log"
	"os"
	"path/filepath"
	"testing"
)

func TestTest(t *testing.T) {
	t.Errorf("Hello")
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

	m.Run()
	unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
}
