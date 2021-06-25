#!/bin/bash

# C_ARCH="64"                         # generate 64-bit x86 code
# LD_ARCH="elf_x86_64"              # generate a i386 compatible ELF program file
# KERNEL_ADDRESS="0x1000"             # where to load our kernel
# KERNEL_IMAGE="os-image-64.img"          # what our kernel image will be called

# echo "Building 64-bit kernel image"

# gcc -m$C_ARCH -ffreestanding -c kernel_main.c -o kernel_main.o
# ld -m$LD_ARCH -o kernel_main.bin -Ttext ${KERNEL_ADDRESS} -e main --oformat binary kernel_main.o 

# as -o boot_with_switch.o boot_with_switch.s
# ld -o boot_with_switch.bin --oformat binary -Ttext 0x7c00 -e _start boot_with_switch.o

# # this file should be 512 bytes or less or the size will be negative and you will get this error:
# # boot_with_switch.s:74: Warning: .space, .nops or .fill with negative value, ignored
# ls -la boot_with_switch.bin

# cat boot_with_switch.bin kernel_main.bin > $KERNEL_IMAGE

# echo "Kernel Image: ${KERNEL_IMAGE}"
# qemu-system-x86_64 $KERNEL_IMAGE


as -o boot.o boot.s
ld -o boot.bin --oformat binary -Ttext 0x7c00 -e _start boot.o
qemu-system-x86_64 boot.bin