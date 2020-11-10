# Basic boot "Hello world"

## Dependencies

* Assumes a linux distribution or linux overlay
* Install Qemu
* Install GNU assembler 

## Compilation

If we compile using the normal method then we get a file that is larger than 512 bytes.

```
as -o boot.o boot.asm
```

We now strip all the excess stuff away to leave a plain binary file.

The ```-e``` indicates the explicit symbol to start at.

```
ld -o boot.bin --oformat binary -e _start boot.o
```

To investigate further use objdump and hexdump to explore the differences between boot.o and boot.bin.

You can run the boot.bin file by typing:

```
qemu-system-x86_64 boot.bin
```

You can do the same thing with our broken_boot.asm example.

```
as -o broken_boot.o broken_boot.asm
ld -o broken_boot.bin --oformat binary -e _start broken_boot.o
qemu-system-x86_64 broken_boot.bin
```

The broken boot will continue to look for bootable drives, where as the working boot loader succeeds.

Now try hello.asm:

```
as -o hello.o hello.asm
ld -o hello.bin --oformat binary -e _start hello.o
qemu-system-x86_64 hello.bin
```

Then try:

```
as -o helloworld1.o helloworld1.asm
ld -o helloworld1.bin --oformat binary -Ttext 0x7c00 -e _start helloworld1.o
qemu-system-x86_64 helloworld1.bin
```

Note the addition of the -Ttext 0x7c00, the BIOS will load our code (the MASTER BOOT RECORD or MBR) at position 0x7C00 so we make that the starting address.  The magic value of 0x7C00 is part of the BIOS specification.  Try removing this and seeing what the error is...

0x7C00 in decimal is 31744, which is 2^15 - 1024 (1KB). Our program is going to be in the first 512 bytes. 7FFF is the largest signed integer in 16 bits.  The program stack and the data area of the boot program is free to to use the memmory up to 0x7FFF.  Below this is the read only code from the BIOS for handling interrupts and other BIOS data.[3]

Helloworld1.asm will print a H as there is no loop to load the rest of the string.  In Helloworld2 we fix that.

```
as -o helloworld2.o helloworld2.asm
ld -o helloworld2.bin --oformat binary -Ttext 0x7c00 -e _start helloworld2.o
qemu-system-x86_64 helloworld2.bin
```

## References

[1] https://medium.com/@g33konaut/writing-an-x86-hello-world-boot-loader-with-assembly-3e4c5bdd96cf
[2] https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
[3] https://www.glamenv-septzen.net/en/view/6