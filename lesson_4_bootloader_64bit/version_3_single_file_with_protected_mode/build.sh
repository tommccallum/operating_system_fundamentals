#!/bin/bash

as -o boot.o boot.s
ld -o boot.bin --oformat binary -Ttext 0x7c00 -e _start boot.o
qemu-system-x86_64 boot.bin

