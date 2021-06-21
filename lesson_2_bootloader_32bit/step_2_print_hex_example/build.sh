#!/bin/bash

as -o print_hex.o print_hex.s
ld -o print_hex.bin --oformat binary -Ttext 0x7c00 -e _start print_hex.o
qemu-system-x86_64 print_hex.bin
