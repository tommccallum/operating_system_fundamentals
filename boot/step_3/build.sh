#!/bin/bash

as -o hello.o hello.s
ld -o hello.bin --oformat binary -e _start hello.o
qemu-system-x86_64 hello.bin
