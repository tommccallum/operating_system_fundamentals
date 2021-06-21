# program to test our print_string function
# We need to place the MAGIC NUMBERS 0x55AA at the end of a 512 byte segment.
# The processor will start in 16-bit real mode so we need to handle that.
.code16 
# we define the start of our program.  We can use any name, by convention
# this is called _start, so that is what we will call it.
.global _start 

_start:
  #
  # ds, cs, ss, and es are the segment registers
  # ds is the default data segment and so our address is offset by by the value in this register
  # ss is the default stack segment, use to modify the location of stacks base pointer (bp)
  # segments DO overlap
  # address = segment * 16 + offset
  #
  mov $0x0e, %ah                # set teletype function
  mov the_secret, %al           # copy into the larger register
  # mov (%bx), %al                # copy into 8-bit lo bits, moves the value pointed at %bx to %al
  int $0x10                     # this does show secret X

  # not we use the value 0x7c0 as its going to be multiplied by 16 in its calculation
  # of the address as noted above.
  mov $0x7c0, %bx               # we can't set the ds register directly so we go through a general register bx
  mov %bx, %ds                  # copy bx into register ds as cannot assign directly
  mov %ds:the_secret, %al       # copy into the larger register
  int $0x10                     # this does not show secret X? Yes

  mov %es:the_secret, %al       # tell the cpy to use the es, not ds, segment
  int $0x10                     # this prints the secret X

  mov $0x7c0, %bx
  mov %bx, %es
  mov %es:the_secret, %al       
  int $0x10                     # does this print the secret X? Yes

hltloop:
  hlt                           # stop execution 
  jmp hltloop                   # put into infinite loop to stop stray external interrupts from firing and adding extra output

the_secret: .ascii "X"          # the secrect


# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55
