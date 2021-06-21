# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  mov $msg, %si     # loads the address of msg into si 
  mov $0xe, %ah     # loads 0xe (function number: teletype) into register AH
print_char: 
  lodsb             # loads the byte from the address in si into al and increments si 
  cmp $0, %al       # compares content in AL with zero 
  je done           # if al == 0, go to "done" 
  int $0x10         # prints the character in al to screen 
  jmp print_char    # repeat with next byte 
done: 
  hlt # stop execution 

msg: .asciz "Hello world!"      # stores the string (plus a byte with value "0") and gives us access via $msg

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
