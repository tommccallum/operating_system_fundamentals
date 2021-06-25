#!/bin/bash

as -o multiboot_header.o multiboot_header.s
as -o boot.o boot.s
#as -o bss.o bss.s
#as -o gdt64.o gdt64.s
ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o #bss.o

mkdir -p isofiles/boot/grub
cp grub.cfg isofiles/boot/grub
cp kernel.bin isofiles/boot
grub2-mkrescue -o os.iso isofiles

qemu-system-x86_64 -cdrom os.iso