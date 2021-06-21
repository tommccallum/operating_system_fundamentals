#!/bin/bash

as -o boot_with_switch.o boot_with_switch.s
ld -o boot_with_switch.bin --oformat binary -Ttext 0x7c00 -e _start boot_with_switch.o
qemu-system-x86_64 boot_with_switch.bin
