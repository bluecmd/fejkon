package main

import (
	"testing"
	"os"
	"golang.org/x/sys/unix"
)

func TestTest(t *testing.T) {
	t.Errorf("Hello")
}

func TestMain(m *testing.M) {
	m.Run()
	if os.Getpid() == 1 && os.Getuid() == 0 {
		unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
	}
}
