#!/bin/bash

as -o helloworld2.o helloworld2.s
ld -o helloworld2.bin --oformat binary -Ttext 0x7c00 -e _start helloworld2.o
#qemu-system-x86_64 helloworld2.bin
dd if=/dev/zero of=floppy.img bs=1024 count=1024
dd if=helloworld2.bin of=floppy.img conv=notrunc

#bochs-debugger -qf bochsrc.txt -dbglog bochs-debug.log -log bochs.log

echo "Type 'bochs' to run without debugging"
echo "Type 'bochs-debugger' to run with debugger"
echo "Type 'bochs-debugger -f bochsrc-gui.txt' to run with debugger"
