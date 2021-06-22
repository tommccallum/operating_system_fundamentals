# program to test our print_string function
# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  xor %ax, %ax          # set ax to zero
  mov $0xFEDC, %dx      # copy value to dx
  call print_hex 
  call print_space
  mov $0xBA98, %dx      # copy value to dx
  call print_hex 
  call print_space
  mov $0x7654, %dx      # copy value to dx
  call print_hex 
  call print_space
  mov $0x3210, %dx      # copy value to dx
  call print_hex 
  call print_space
  call print_nl

hltloop:
  hlt                   # stop execution 
  jmp hltloop           # put into infinite loop to stop stray external interrupts from firing and adding extra output

.include "print_string.s"

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
