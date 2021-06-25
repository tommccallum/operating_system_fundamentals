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
  .include "enable_a20_gate.s"

  call detect_cpuid
  call detect_long_mode
  call setup_long_mode

  # we had to put this file here so that GAS would pick up the CODE_SEG
  .include "gdt64.s"  # <<-- why this does not work is beyond me!


setup_long_mode:
  call clear_paging_table_memory
  call setup_paging_tables 
  cli
  lgdt gdt64ptr                  # load the 64-bit global descriptor table

  jmp $CODE_SEG64, $BEGIN_LONG_MODE        # <<-- says this is not set but should be as it works in our 32-bit version
  
finale:
  hlt
  call finale

.include "print_char_16bit.s"
// .include "print_char_64bit.s"
.include "print_err_16bit.s"
.include "print_err_64bit.s"
.include "detect_cpuid.s"
.include "detect_long_mode.s"
.include "clear_paging_memory.s"
.include "setup_paging_tables.s"
.include "long_mode.s"

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
