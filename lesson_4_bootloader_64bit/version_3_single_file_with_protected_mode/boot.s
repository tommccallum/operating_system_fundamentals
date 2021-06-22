_start_of_file:


// gdt64:
// gdt64_null:
//   .word 0xffff, 0x0000
//   .byte 0x00, 0b00000000, 0b00000000, 0x00
// gdt64_code:
//   .word 0x0000, 0x0000
//   .byte 0x00, 0b10011010, 0b10101111, 0x00
// gdt64_data:
//   .word 0x0000, 0x0000
//   .byte 0x00, 0b10010010, 0b00000000, 0x00
// gdt64_end:

// gdt64ptr:
//   .word (gdt64_end - gdt64 - 1)
//   .quad (gdt64)


// .set CODE_SEG64, gdt64_code - gdt64
// .set DATA_SEG64, gdt64_data - gdt64


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
  cli
  lgdt gdt32ptr

  call switch_to_protected_mode
  #jmp hang

.code32

gdt32:
gdt32_null:
  .quad 0x0
gdt32_code:
  .word 0xffff, 0x0000
  .byte 0x00, 0b10011010, 0b11001111, 0x00
gdt32_data:
  .word 0xffff, 0x0000
  .byte 0x00, 0b10010010, 0b11001111, 0x00
gdt32_end:

gdt32ptr:
  .word (gdt32_end - gdt32 - 1)
  .int (gdt32)

.set CODE_SEG32, gdt32_code - gdt32
.set DATA_SEG32, gdt32_data - gdt32

.code16

switch_to_protected_mode:
  mov %cr0, %eax
  or  $1, %eax
  mov %eax, %cr0
  jmp $CODE_SEG32, $_start32

_start32:
  # reset registers
  mov $DATA_SEG32, %ax
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs
  mov %ax, %ss
  mov $0x9000, %ebp           # update our stack pointer
  mov %ebp, %esp              # so it lies at the top of the free space
    
  mov $'A, %al
  mov $0x0F, %ah              # white on black color
  mov $0xb8000, %edx
  mov %ax, (%edx)

//   movl %cr4, %eax
//   orl $(1<<5), %eax
//   movl %eax, %cr4
//   movl $0x8000, %edi
//   movl $0x0100, %ecx
// PT:
//   movw 0x0000, %ax
//   pushw %ax
//   loop PT
  
//   movl $0xc0000080, %ecx
//   rdmsr
//   orl $(1<<8), %eax
//   wrmsr

//   movl %cr0, %eax
//   orl $(1<<31), %eax
//   movl %eax, %cr0
//   lgdt gdt64ptr
//   ljmp $CODE_SEG64, $_start64

// _start64:
// .code64
//   mov $'A, %al
//   mov $0xb8000, %eax
//   mov %al, (%eax)
  
hang:
  hlt
  jmp hang

# -----------------------------------------------------------------
# THESE ARE THE 2 MOST IMPORTANT LINES IN THE WHOLE BOOTLOADER
# -----------------------------------------------------------------

# add zeroes to make it 510 bytes long
.fill 510-(.-_start_of_file), 1, 0 

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
# this makes the program 512 bytes long exactly, no more, no less.
.word 0xaa55

