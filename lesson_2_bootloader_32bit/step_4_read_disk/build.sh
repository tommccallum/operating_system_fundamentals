#!/bin/bash

as -o read_disk.o read_disk.s
ld -o read_disk.bin --oformat binary -Ttext 0x7c00 -e _start read_disk.o
qemu-system-x86_64 read_disk.bin
