# https://intermezzos.github.io/book/first-edition/hello-world.html

# .global makes the symbol start visible to the linker ld.
# you can use either .globl or .global due to compatibility issues
.global start


// no need to declare variables external as GNU assembler treats all unrecognised symbols as extern

# code is stored in a .text section
.section .text

# the multiboot will put us directly into protected mode (32-bit), not real mode (16-bit)
.code32

start:
    call setup_page_table

    # these must be declared after start
    # but before they are used.
    .include "gdt64.s"
    .include "bss.s"

setup_page_table:
    mov p3_table, %eax
    or  $0b11, %eax              # mark as present and writeable
    mov %eax, (p4_table)

    mov p2_table, %eax
    or  $0b11, %eax              # mark as present and writeable
    mov %eax, (p3_table)

    mov $0, %ecx
map_p2_table_loop:
    mov $0x200000,%eax               # 2MiB
    mul %ecx                        # ecx * eax
    or  $0b10000011, %eax            # 1 in 8 bit identifies this as a 'huge' page i.e. 2MiB otherwise we have 4KiB
    mov %eax, p2_table(,%ecx,8)     # section:disp(base, index, scale)
    inc %ecx
    cmp $512, %ecx                  # we want to map 512 lots of 8 bytes
    jne map_p2_table_loop

move_p4_into_control_reg:
    mov p4_table,%eax       # Set the base address of the the top page table to 0x1000 (4096)
    mov %eax,%cr3           # Set control register 3 to the destination index.




# we also need to have longmode set, enable PAE paging and then enable paging
# anyother order and we get a triple fault reset.
set_longmode_bit:  
    mov   $0xc0000080, %ecx
    rdmsr
    or    $(1<<8), %eax
    wrmsr

enable_pae_paging:
    mov %cr4, %eax
    or  $(1<<5), %eax
    mov %eax, %cr4

enable_paging: 
    # enable paging and protected mode
    mov %cr0, %eax                    # Set the A-register to control register 0.
    or $(1 << 31), %eax        # Set the PG-bit, which is the 32nd bit (bit 31), in 16-bit you would also need to set the 0th bit to 1 
    mov %eax, %cr0                    # Set control register 0 to the A-register.

switch_to_long_mode:
    lgdt gdt64ptr
    jmp $CODE_SEG64, $start64         # this line fails in QEMU unfortunately

.code64
start64:
  
  mov $DATA_SEG64, %ax        # reset registers
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs
  mov %ax, %ss
  mov $0x9000, %ebp           # update our stack pointer
  mov %ebp, %esp              # so it lies at the top of the free space

  mov $'L, %al
  mov $0xb8000, %edx
  mov $0x0F, %ah              # white on black color
  mov %ax, (%edx)



hang:
  hlt
  jmp hang
