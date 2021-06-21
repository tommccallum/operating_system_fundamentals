#!/bin/bash

as -o print_exe.o print_exe.s
ld -o print_exe.bin --oformat binary -Ttext 0x7c00 -e _start print_exe.o
qemu-system-x86_64 print_exe.bin
