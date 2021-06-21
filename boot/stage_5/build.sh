#!/bin/bash

as -o helloworld2.o helloworld2.s
ld -o helloworld2.bin --oformat binary -Ttext 0x7c00 -e _start helloworld2.o
qemu-system-x86_64 helloworld2.bin
