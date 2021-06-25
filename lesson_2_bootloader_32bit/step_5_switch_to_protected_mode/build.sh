#!/bin/bash

as -o boot_with_switch.o boot_with_switch.s
ld -o boot_with_switch.bin --oformat binary -Ttext 0x7c00 -e _start boot_with_switch.o
dd if=/dev/zero of=floppy.img bs=1024 count=1024
dd if=boot_with_switch.bin of=floppy.img conv=notrunc

qemu-system-x86_64 boot_with_switch.bin
