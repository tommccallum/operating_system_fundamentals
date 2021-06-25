// Do not make this a separate section it needs to be just part of the 
// code block

// /* Defines a GDT entry. We say packed, because it prevents the
// *  compiler from doing things that it thinks is best: Prevent
// *  compiler "optimization" by packing */
// struct gdt_entry
// {
//     unsigned short limit_low;
//     unsigned short base_low;
//     unsigned char base_middle;
//     unsigned char access;
//     unsigned char granularity;
//     unsigned char base_high;
// } __attribute__((packed));

// /* Special pointer which includes the limit: The max bytes
// *  taken up by the GDT, minus 1. Again, this NEEDS to be packed */
// struct gdt_ptr
// {
//     unsigned short limit;
//     unsigned int base;
// } __attribute__((packed));

// /* Our GDT, with 3 entries, and finally our special GDT pointer */
// struct gdt_entry gdt[3];
// struct gdt_ptr gp;

gdt32:
gdt32_null:
    .quad 0x0               # 8 bytes, this actually has the same structure
                            # as the other 2 but is all zeros

# our code segment descriptor (8 bytes)
gdt32_code:
    .word 0xffff            # limit_low
    .word 0x0000            # base_low
    .byte 0x0               # base_middle
    .byte 0b10011010        # access 
    .byte 0b11001111        # granularity
    .byte 0x0               # base_high

# our data segment descriptor
gdt32_data:
    .word 0xffff            # limit_low
    .word 0x0000            # base_low
    .byte 0x0               # base_middle
    .byte 0b10010010        # access
    .byte 0b11001111        # granularity
    .byte 0x0               # base_high
gdt32_end:

gdt32ptr:
  .word (gdt32_end - gdt32 - 1)     # limit
  .int  gdt32                       # base


.set CODE_SEG32, gdt32_code - gdt32
.set DATA_SEG32, gdt32_data - gdt32

