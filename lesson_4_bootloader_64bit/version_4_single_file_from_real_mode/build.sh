#!/bin/bash

as -o boot.o boot.s
ld -o boot.bin --oformat binary -Ttext 0x7c00 -e _start boot.o
#qemu-system-x86_64 boot.bin

dd if=/dev/zero of=floppy.img bs=1024 count=1024
dd if=boot.bin of=floppy.img conv=notrunc