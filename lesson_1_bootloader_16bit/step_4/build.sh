#!/bin/bash

as -o helloworld1.o helloworld1.s
ld -o helloworld1.bin --oformat binary -Ttext 0x7c00 -e _start helloworld1.o
qemu-system-x86_64 helloworld1.bin
