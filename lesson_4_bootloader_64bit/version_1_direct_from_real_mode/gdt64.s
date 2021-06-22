# https://wiki.osdev.org/User:Stephanvanschaik/Setting_Up_Long_Mode#Detecting_the_Presence_of_Long_Mode

.code64 

GDT64:                           # Global Descriptor Table (64-bit).
GDT64_Null: 
    .int 0xFFFF                    # Limit (low).
    .int 0                         # Base (low).
    .byte 0                         # Base (mi.longle)
    .byte 0                         # Access.
    .byte 1                         # Granularity.
    .byte 0                         # Base (high).
GDT64_Code: 
    .int 0                         # Limit (low).
    .int 0                         # Base (low).
    .byte 0                         # Base (mi.longle)
    .byte 0b10011010                 # Access (exec/read).
    .byte 0b10101111                 # Granularity, 64 bits flag, limit19:16.
    .byte 0                         # Base (high).
GDT64_Data: 
    .int 0                         # Limit (low).
    .int 0                         # Base (low).
    .byte 0                         # Base (mi.longle)
    .byte 0b10010010                 # Access (read/write).
    .byte 0b00000000                 # Granularity.
    .byte 0                         # Base (high).
GDT64_pointer:
    .int    (. - GDT64 - 1)     # size of GDT (always 1 less than true size)
    .quad   GDT64                       # start address of GDT


.set CODE_SEG, GDT64_Code - GDT64
.set DATA_SEG, GDT64_Data - GDT64


