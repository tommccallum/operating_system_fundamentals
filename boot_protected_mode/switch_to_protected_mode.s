.code16

switch_to_protected_mode:
    cli                                      # stop all interrupts
    lgdt gdt_descriptor                      # load our Global Descriptior Table
    mov  %cr0, %eax                          # switch to protected mode
    or   $0x1, %eax                          # make the first bit of cr0 a 1
    mov  %eax, %cr0                          # save to cr0, this switches us to 32-bit protected mode
    jmp  $CODE_SEG,$init_protected_mode      # far jump, https://stackoverflow.com/questions/49438550/assembly-executing-a-long-jump-with-an-offset-with-different-syntax

.code32

init_protected_mode:
    mov $DATA_SEG, %ax          # start to write our new segments to registers
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    
    mov $0x9000, %ebp           # update our stack pointer
    mov %ebp, %esp              # so it lies at the top of the free space
    call BEGIN_PROTECTED_MODE   # finally we can call a known location

