package main

import (
	"fmt"
	"log"

	"github.com/bluecmd/go-sff"
)

func main() {
	// TODO: Check for /sys/class/i2c-dev/i2c-*/name == fejkon
	p, err := sff.Read("/dev/i2c-2")
	if err != nil {
		log.Fatalf("sff.Read failed: %v", err)
	}
	fmt.Printf("==== SFP 1 ====\n\n%v", p)

	p, err = sff.Read("/dev/i2c-3")
	if err != nil {
		log.Fatalf("sff.Read failed: %v", err)
	}
	fmt.Printf("\n==== SFP 2 ====\n\n%v", p)
}
