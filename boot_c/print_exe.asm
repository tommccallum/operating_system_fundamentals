# program to test our print_string function
# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  mov $msg, %si     # loads the address of msg into si 
  mov $0xe, %ah     # loads 0xe (function number: teletype) into register AH
  call print_string 
  hlt # stop execution 

.include "print_string.asm"

msg: .asciz "Hello world!"      # stores the string (plus a byte with value "0") and gives us access via $msg

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
