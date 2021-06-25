## Long term plan for bootloader

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