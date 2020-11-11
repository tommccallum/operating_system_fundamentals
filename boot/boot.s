# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  # our only instruction will simply be to put our machine into an infinite
  # loop
  jmp _start # jump to label _start

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
# This is called the BOOT SIGNATURE
.word 0xaa55
