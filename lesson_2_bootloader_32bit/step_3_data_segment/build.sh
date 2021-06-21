#!/bin/bash

as -o data_segment.o data_segment.s
ld -o data_segment.bin --oformat binary -Ttext 0x0000 -e _start data_segment.o
qemu-system-x86_64 data_segment.bin
