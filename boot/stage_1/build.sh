#!/bin/bash

as -o boot.o boot.s
ld -o boot.bin --oformat binary -e _start boot.o
qemu-system-x86_64 boot.bin
