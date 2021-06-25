gdt64:
gdt64_null:
  .word 0x0000
  .word 0x0000
  .byte 0x00
  .byte 0b00000000
  .byte 0x00
  .byte 0x00

gdt64_code:
  .word 0xffff          # 15-00   LIMIT 0:15    (4GB total)
  .word 0x0000          # 31-16   BASE 0:15
  .byte 0x00            # 39-32   BASE 16:23
  .byte 0b10011000      # 47-40   ACCESS
  .byte 0b10101111      # 55-44   FLAGS + LIMIT 16:19
  .byte 0x00            # 63-56   BASE 24:31

gdt64_data:
  .word 0xffff
  .word 0x0000
  .byte 0x00 
  .byte 0b10010010 
  .byte 0b00000000 #0b10101111
  .byte 0x00
gdt64_end:

gdt64ptr:
  .word (gdt64_end - gdt64 - 1)
  .quad gdt64


.set CODE_SEG64, gdt64_code - gdt64
.set DATA_SEG64, gdt64_data - gdt64
