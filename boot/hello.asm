# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  # This follows the GNU convention of INSTRUCTION SOURCE, DESTINATION
  # this is as compared with INTEL convention e.g. nasm that is INSTRUCTION DESTINATION, SOURCE
  mov $0x0E48, %ax  # sets register AH to 0xE (function teletype) and register AL to 0x48 (ASCII "H") 
  int $0x10         # call the function in ah from interrupt 0x10 
  mov $0x0E45, %ax  # sets register AH to 0xE (function teletype) and register AL to 0x45 (ASCII "E") 
  int $0x10         # call the function in ah from interrupt 0x10 
  mov $0x0E4C, %ax  # sets register AH to 0xE (function teletype) and register AL to 0x4C (ASCII "L") 
  int $0x10         # call the function in ah from interrupt 0x10 
  mov $0x0E4C, %ax  # sets register AH to 0xE (function teletype) and register AL to 0x4C (ASCII "L") 
  int $0x10         # call the function in ah from interrupt 0x10 
  mov $0x0E4F, %ax  # sets register AH to 0xE (function teletype) and register AL to 0x4F (ASCII "O") 
  int $0x10         # call the function in ah from interrupt 0x10 
  hlt               # stops executing 

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
