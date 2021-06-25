# Operating System Fundamentals

_Adventures in assembler and operating system design._

This version uses GNU Assembler and so I have translated the NASM code as required.  Much of the code around OS is using NASM as the assembler.  The reason for translating is to ensure I know why its doing what its doing and to help me not just copy and paste.

## Getting Started

**TODO**


## Debugging

### with QEMU

See lesson 1 readme.

### with Bochs

Before running bochs you will need to have the BXSHARE set to the directory where the Bochs images are stored.

```
source bochs.env
```
See lesson 1 readme.

### Useful GDB commands

Here are some of the useful GDB commands I have used while debugging these examples.

```
layout asm                      # to see the assembler
br *0x7c00                      # break at start of bootloader
c                               # continue to next breakpoint
si                              # step 1 instruction forward
target remote localhost:1234    # connect to QEMU remote debugging server
```