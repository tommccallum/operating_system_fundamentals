.code16 

.global _start 

_start:
    mov $0x8000, %bp            # set base pointer to 0x8000 out of the way
    mov %bp, %sp               # set stack pointer

    mov $0x9000, %bx            # load the sectors in at memory location ES:0x9000
    mov $2, %dh                 # load 2 sectors (there are only 2 sectors each 512 bytes), the example says set this to 5 but that is not correct.
    mov BOOT_DRIVE, %dl        
    call disk_load

    mov (0x9000+256), %dx
    call print_hex

    call print_nl

    mov (0x9000 + 514), %dx       # print the first word from the 2nd loaded sector
    call print_hex              # should be 0xface

    call halt_os

.include "print_string.s"
.include "disk.s"

BOOT_DRIVE: .byte 0x80              # the example was 0 but a HDD is mounted at default 0x80 [https://stackoverflow.com/questions/55972474/controller-error-20h-for-int-13h-for-writing-a-bootloader]

# fill the rest of the file up to 510 bytes with null bytes '\0'.
.fill 510-(.-_start), 1, 0 # add zeroes to make it 510 bytes long

# define our magic numbers 55 AA
# this is little endian so we but the AA first so we read the lower bytes first.
.word 0xaa55

# .fill repeat, size, value
.fill 256, 1, 0     # add zeroes to make 256 long
.word 0xdada        # this is at 257 and 258
.fill 256, 1, 0     # add zeroes 259 to (259+256)
.word 0xface         
