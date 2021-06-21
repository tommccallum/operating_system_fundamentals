.code32 

# Global Descriptor Table

gdt_start:

# required null segment descriptor
gdt_null:
    .quad 0x0               # 8 byte value

# our code segment descriptior
gdt_code:
    .word 0xffff            # limit
    .word 0x0000            # base
    .byte 0x0               # base
    .byte 0b10011010         # 1st flags, type flags
    .byte 0b11001111         # 2nd flags, limit
    .byte 0x0               # base

# our data segment descriptor
gdt_data:
    .word 0xffff            # limit
    .word 0x0000            # base
    .byte 0x0               # base
    .byte 0b10010010         # 1st flags, type flags
    .byte 0b11001111         # 2nd flags, limit
    .byte 0x0               # base

# used to calculate size of GDT table
gdt_end:

gdt_descriptor:
    .word (gdt_end - gdt_start - 1)     # size of GDT (always 1 less than true size)
    .int  gdt_start                     # start address of GDT

# define useful constants
# these values must be placed into the segment registers to be used.
.set CODE_SEG, gdt_code - gdt_start
.set DATA_SEG, gdt_data - gdt_start
