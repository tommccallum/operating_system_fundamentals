# program to test our print_string function
# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  mov $0x9000, %bp                      # set the stack
  mov %bp, %sp

  call hide_cursor
  call move_cursor_to_top_left
  call clear_screen

  mov $MSG_REAL_MODE, %si               # output a message to say 'hi!'
  call print_string
  call print_nl

  call enable_a20_gate

  call switch_to_protected_mode         # make switch to 32-bit protected mode, not we may never return from here
  call halt_os                          # stop execution 

.include "print_string.s"
.include "disk.s"
.include "gdt.s"
.include "print_string_32.s"
.include "switch_to_protected_mode.s"

.code32

# we arrive here after calling the switch_to_protected_mode
BEGIN_PROTECTED_MODE:
  mov $MSG_PROTECTED_MODE, %ebx
  call print_string_32
halt_os_32:
  hlt
  jmp halt_os_32

MSG_REAL_MODE:      .asciz "Started in real mode (16-bit)"
MSG_PROTECTED_MODE: .asciz "Welcome to protected mode (32-bit)"

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
