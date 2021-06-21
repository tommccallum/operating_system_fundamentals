#!/bin/bash

as -o broken_boot.o broken_boot.s
ld -o broken_boot.bin --oformat binary -e _start broken_boot.o
qemu-system-x86_64 broken_boot.bin
