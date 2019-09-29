package main

import (
	"log"
	"testing"
	"os"
	"golang.org/x/sys/unix"
)

func TestTest(t *testing.T) {
	t.Errorf("Hello")
}

func TestMain(m *testing.M) {
	if os.Getpid() != 1 || os.Getuid() != 0 {
		log.Fatalf("Test should be run inside VM as init")
	}
	m.Run()
	unix.Reboot(unix.LINUX_REBOOT_CMD_POWER_OFF)
}
