# Operating System Fundamentals

_Adventures in assembler and operating system design._

Initially following the document at https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf.  Various attempts at this can be found on Stack Overflow.  This version uses GNU Assembler and so I have translated the NASM code as required.

## Layout

* /boot     has some basic boot versions
* /boot_protected_mode      has more examples and has a version that can switch from real mode into protected mode
* /boot_c   has a simple C kernel that has been joined with a assembler boot loader

## Debugging with Bochs

Before running bochs you will need to have the BXSHARE set to the directory where the Bochs images are stored.

```
source bochs.env
```

## Long term plan for bootloader

From https://wiki.osdev.org/Rolling_Your_Own_Bootloader


* Setup 16-bit segment registers and stack
  * What does it mean to 'setup' registers?
  * What is the stack at a fundamental level?
* Print startup message [DONE]
* Check presence of PCI, CPUID, MSRs
  * How do we test for PCI?
  * How do we test for CPUID?
  * How do we test for MSRs?  What is MSR?
* Enable and confirm enabled A20 line
* Load GDTR
* Inform BIOS of target processor mode
* Get memory map from BIOS
* Locate kernel in filesystem
  * In lilo is a hack whereby a utility sets the kernel location in the filesytem.
  * In grub this is handled via Stage 2 that can detect and traverse file systems.
* Allocate memory to load kernel image
* Load kernel image into buffer
* Enable graphics mode
* Check kernel image ELF headers
* Enable long mode, if 64-bit
* Allocate and map memory for kernel segments
* Setup stack
* Setup COM serial output port
* Setup IDT
* Disable PIC
* Check presence of CPU features (NX, SMEP, x87, PCID, global pages, TCE, WP, MMX, SSE, SYSCALL), and * enable them
* Assign a PAT to write combining
* Setup FS/GS base
* Load IDTR
* Enable APIC and setup using information in ACPI tables
* Setup GDT and TSS 