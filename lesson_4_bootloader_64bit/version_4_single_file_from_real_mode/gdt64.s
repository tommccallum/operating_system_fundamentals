gdt64:
gdt64_null:
  .word 0xffff, 0x0000
  .byte 0x00, 0b00000000, 0x01, 0x00
gdt64_code:
  .word 0x0000, 0x0000
  .byte 0x00, 0b10011010, 0b10101111, 0x00
gdt64_data:
  .word 0x0000, 0x0000
  .byte 0x00, 0b10010010, 0b00000000, 0x00
gdt64_end:

gdt64ptr:
  .word (gdt64_end - gdt64 - 1)
  .quad (gdt64)


.set CODE_SEG64, gdt64_code - gdt64
.set DATA_SEG64, gdt64_data - gdt64
