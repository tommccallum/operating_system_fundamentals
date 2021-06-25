#!/bin/bash

as -o multiboot_header.o multiboot_header.s
as -o boot.o boot.s
ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o

mkdir -p isofiles/boot/grub
cp grub.cfg isofiles/boot/grub
cp kernel.bin isofiles/boot
grub2-mkrescue -o os.iso isofiles

qemu-system-x86_64 -cdrom os.iso