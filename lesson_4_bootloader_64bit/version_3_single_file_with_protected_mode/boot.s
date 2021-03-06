_start_of_file:


.align 4
.section .text

.global _start

_start:
.code16
hide_cursor:
    mov $0x01,%ah
    mov $0x2607,%cx
    int $0x10

cursor_to_top_left:
    mov 0x02, %ah
    xor %bx, %bx
    xor %dx, %dx
    int $0x10

clear_screen:
    mov $0x06, %ah
    xor %al, %al
    xor %bx, %bx
    mov $0x07, %bh
    xor %cx, %cx
    mov $24, %dh 
    mov $79, %dl
    int $0x10

enable_a20:
  inb $0x92, %al              # copies the value to i/o port 0x92 to register AL
  testb $02, %al              # test if we need to set second bit to 1 or if it is set already
  jnz a20_enabled             # jump if its set
  orb $02, %al                # sets to 1 the second bit of AL
  andb $0xfe, %al             # Since bit 0 sometimes is write-only, and writing a one there causes a reset
  outb %al, $0x92  
a20_enabled:
  
  # These have to be defined before we use them
  # but can be in gdt32.s or here.
  call switch_to_protected_mode

  # This crashes with a general protection fault like it cannot find them if you put the GDT in the wrong place.
  // 00012941742e[CPU0  ] fetch_raw_descriptor: GDT: index (17) 2 > limit (0)
  // 00012941742e[CPU0  ] interrupt(): gate descriptor is not valid sys seg (vector=0x0d)
  // 00012941742e[CPU0  ] interrupt(): gate descriptor is not valid sys seg (vector=0x08)
  
# we put this here
.include "gdt32.s"


.code16
  
switch_to_protected_mode:
  cli
  lgdt gdt32ptr
  mov %cr0, %eax
  or  $0x1, %eax
  mov %eax, %cr0
  
  jmp $CODE_SEG32, $start32


.code32
.include "gdt64.s"

start32:
  mov $DATA_SEG32, %ax        # reset registers
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs
  mov %ax, %ss
  mov $0x9000, %ebp           # update our stack pointer
  mov %ebp, %esp              # so it lies at the top of the free space
    
  mov $'Z, %al
  mov $0x0F, %ah              # white on black color
  mov $0xb8000, %edx
  mov %ax, (%edx)

# Disabling the paging
# https://wiki.osdev.org/Setting_Up_Long_Mode suggests you should disable paging however
# in QEMU this causes a triple fault due to an general protection fault.
# When commented out this works.
// disable_paging:
//   mov %cr0,%eax                                   # Set the A-register to control register 0.
//   and $(0<<31), %eax    # 0x7FFFFFFF Clear the PG-bit, which is bit 31.
//   mov %eax,%cr0                                    # Set control register 0 to the A-register.

clear_paging_table_memory:

    # PML4T
    mov $0x1000,%edi      # Set the base address of the the top page table to 0x1000 (4096)
    mov %edi,%cr3         # Set control register 3 to the destination index.

    xor %eax, %eax        # set A-register to 0.

    # each table (PDPT, PDT, PT) contains 512 entries of 8 bytes (64bits) long = 512 * 8 = 4096 bytes
    mov $0x1000,%ecx        # Set the C-register to 4096 (x86 paging size).
    rep stosl               # Clear the memory.
    mov %cr3,%edi           # Set the destination index to control register 3.

setup_paging_tables:                 # this sets up something called identity paging.
    # PML4T[0] -> PDPT[0] -> PDT[0] -> PT[0] -> 2MiB (Megibyte, not megabyte)
    
    mov $0x2003, %eax              # the 3 at the end will make the last bits 11 which indicates readable and writable.
    mov %eax, (%edi)               # Set the uint32_t at the destination index to 0x2003 (8195).  PML4T(0) -> PDPT
    add $0x1000, %edi                 # Add 0x1000 to the destination index. (0x1000 = 4096)
    mov $0x3003, %eax
    mov %eax, (%edi)               # Set the uint32_t at the destination index to 0x3003 (12291). PDPT(0) -> PDT
    add $0x1000, %edi                 # Add 0x1000 to the destination index.
    mov $0x4003, %eax
    mov %eax, (%edi)               # Set the uint32_t at the destination index to 0x4003 (16387). PDT(0) -> PT
    add $0x1000, %edi                 # Add 0x1000 to the destination index.

    # the firsrt page
    mov $0x00000003, %ebx             # Set the B-register to 0x00000003.
    mov $512, %ecx                    # Set the C-register to 512, loops 512 entries

.set_entry:                           # initialise pages up to 2MiB limit
    mov %ebx, (%edi)                  # Set the uint32_t at the destination index to the B-register.
    add $0x1000, %ebx                 # Add 0x1000 to the B-register.
    add $8, %edi                      # Add eight to the destination index.
    loop .set_entry                   # Set the next entry.


# we also need to have longmode set, enable PAE paging and then enable paging
# anyother order and we get a triple fault reset.
set_longmode_bit:  
  movl $0xc0000080, %ecx
  rdmsr
  orl $(1<<8), %eax
  wrmsr


enable_pae_paging:
  movl %cr4, %eax
  orl $(1<<5), %eax
  movl %eax, %cr4

enable_paging: 
  # enable paging and protected mode
  mov %cr0, %eax                    # Set the A-register to control register 0.
  #or $1 << 31, eax                # Set the PG-bit, which is the 32nd bit (bit 31), in 16-bit you would also need to set the 0th bit to 1
  or $(1 << 31), %eax        # Set the PG-bit, which is the 32nd bit (bit 31), in 16-bit you would also need to set the 0th bit to 1 
  mov %eax, %cr0                    # Set control register 0 to the A-register.




switch_to_long_mode:
  cli
  lgdt gdt64ptr
  //jmp $0x0800, $start64            # this works as well, not sure why.
  jmp $CODE_SEG64, $start64         # this line fails in QEMU unfortunately

.code64
#.align 8
start64:
  
  //mov $DATA_SEG64, %ax        # reset registers
  mov $0x10, %ax        # reset registers
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

# -----------------------------------------------------------------
# THESE ARE THE 2 MOST IMPORTANT LINES IN THE WHOLE BOOTLOADER
# -----------------------------------------------------------------

# add zeroes to make it 510 bytes long
.fill 510-(.-_start), 1, 0 

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
# this makes the program 512 bytes long exactly, no more, no less.
.word 0xaa55

