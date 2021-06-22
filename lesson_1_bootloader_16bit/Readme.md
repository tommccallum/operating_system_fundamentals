# Basic boot "Hello world"

## Dependencies

* Assumes a linux distribution or linux overlay
* Install Qemu
* Install GNU assembler 

## Compilation

## Step 1

If we compile using the normal method then we get a file that is larger than 512 bytes.

```
as -o boot.o boot.s
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

## Step 2

You can do the same thing with our broken_boot.s example.

```
as -o broken_boot.o broken_boot.s
ld -o broken_boot.bin --oformat binary -e _start broken_boot.o
qemu-system-x86_64 broken_boot.bin
```

The broken boot will continue to look for bootable drives, in step 3 the working boot loader succeeds.

## Step 3

Now try hello.s:

```
as -o hello.o hello.s
ld -o hello.bin --oformat binary -e _start hello.o
qemu-system-x86_64 hello.bin
```

## Step 4

Then try:

```
as -o helloworld1.o helloworld1.s
ld -o helloworld1.bin --oformat binary -Ttext 0x7c00 -e _start helloworld1.o
qemu-system-x86_64 helloworld1.bin
```

Note the addition of the -Ttext 0x7c00, the BIOS will load our code (the MASTER BOOT RECORD or MBR) at position 0x7C00 so we make that the starting address.  The magic value of 0x7C00 is part of the BIOS specification.  Try removing this and seeing what the error is...

0x7C00 in decimal is 31744, which is 2^15 - 1024 (1KB). Our program is going to be in the first 512 bytes. 7FFF is the largest signed integer in 16 bits.  The program stack and the data area of the boot program is free to to use the memmory up to 0x7FFF.  Below this is the read only code from the BIOS for handling interrupts and other BIOS data. Above this the are more BIOS data and video memory [2,3]

Helloworld1.s will print a H as there is no loop to load the rest of the string.  In Helloworld2 we fix that.

## Step 5

```
as -o helloworld2.o helloworld2.s
ld -o helloworld2.bin --oformat binary -Ttext 0x7c00 -e _start helloworld2.o
qemu-system-x86_64 helloworld2.bin
```

## Step 6

### Method 1 using QEMU and GDB together

In one terminal start the QEMU process.  The -S makes it wait until the gdb starts it and the -s makes it open a debug port on 1234.
```
qemu-system-x86_64 -s -S helloworld2.bin
```

In another window start the gdb process as follows:
```
$ gdb
(gdb) target remote localhost:1234
(gdb) set architecture i8086
(gdb) break *0x7c00
# to disassemble the current instruction
(gdb) x
# use si to step 1 instruction at a time
# continue to end of program
(gdb) c
```

### Method 2 using BOCHS

```
dnf -y install bochs bochs-debugger
```

Each output line looks like this:
```
(0) [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
```

* (0) is the line number
* 0x0000fffffff0 is the 64-bit memory address
* f000:fff0 is the value of CS - Code Segment register - (0xf000) and IP - Instruction Pointer register - (0xfff0)
* (unk. ctxt)
* jmpf is the instruction, in this case a far jump
* 0xf000:e05b is the argument to the far jump
* ea5be000f0 is the hex machine code (ea is a far jump), you read this in little endian style 5b,e0,00,F0 => e05b 00f0.  The code is 5 bytes (each byte is 2 hex digits).

> IMPORTANT: If you find that the BOCHS machine keeps resetting over and over.  Try using the legacy BIOS rather than the latest.  This should solve your issue.

## References

[1] https://medium.com/@g33konaut/writing-an-x86-hello-world-boot-loader-with-assembly-3e4c5bdd96cf
[2] https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
[3] https://www.glamenv-septzen.net/en/view/6
[4] https://www.cs.princeton.edu/courses/archive/fall06/cos318/precepts/bochs_tutorial.html
[5] https://bochs.sourceforge.io/
[6] https://bochs.sourceforge.io/cgi-bin/topper.pl?name=New+Bochs+Documentation&url=https://bochs.sourceforge.io/doc/docbook/user/index.html
[7] https://www.cs.utexas.edu/~lorenzo/corsi/cs372h/07S/labs/lab1/lab1.html