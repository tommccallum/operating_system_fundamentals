# Moving to C

You can only get so far in assembler before it feels like you need a more powerful language to build on.  While it is possible to continue in assember we are now going to move to a basic C boot loader.

Before we do however, here is some background from [4] to help set the scene.

## Real Mode

All x86 CPUs start in what is called "real mode".  This mode only allows 16-bit instructions.  So instructions range from 0000 to FFFF.  What this means is that a 16-bit instruction for 'add' can accept 2 16-bit values.  This is not great, so we want to get into a different mode as soon as we can.

## What we need to know

1. Build operating system (Linux)
2. Assembler (GNU Assembler)
3. Instruction Set (x86 family)
4. Compiler (GNU C)
5. Linker (GNU ld)
6. A machine emulator (QEMU)

## Build

First, we build the object file.  The arguments mean the following:

* ```-c``` compile the C code without linking
* ```-g``` add debug information (not required)
* ```-Os``` optimise for code size (not required)
* ```-march``` is the CPU architecture to expect
* ```-ffreestanding``` means to not require a standard library to be * present
* ```-Wall``` enable all warnings
* ```-Werror``` convert all warnings to errors

```
gcc -c -g -Os -march=x86-64 -ffreestanding -Wall -Werror boot.c -o boot.o
```

Then we link our file using out linker options in boot.ld.

* ```-static``` tells the linker to not link against shared libraries
* ```-Tboot.ld``` brings in our linker options
* ```-nostdlib``` do not link with standard C library start up functions
* ```--nmagic``` says to not generate code without _start_SECTION and _stop_SECTION codes


```
ld -static -Tboot.ld -nostdlib --nmagic -o boot.elf boot.o
```

Finally we create our basic binary file.

```
objcopy -O binary boot.elf boot.bin
```

Start our virtual machine and notice it stops with a flashing cursor as we started in the previous examples.

```
qemu-system-x86_64 boot.bin
```

```
gcc -m32 -ffreestanding -c kernel_main.c -o kernel_main.o
ld -melf_i386 -o kernel_main.bin -Ttext 0x1000 -e main --oformat binary kernel_main.o 
```

```
as -o boot_with_switch.o boot_with_switch.s
ld -o boot_with_switch.bin --oformat binary -Ttext 0x7c00 -e _start boot_with_switch.o
```

```
cat boot_with_switch.bin kernel_main.bin > os-image
qemu-system-x86_64 os-image
```

## References

[1] https://www.codeproject.com/Articles/664165/Writing-a-boot-loader-in-Assembly-and-C-Part
[2] https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf