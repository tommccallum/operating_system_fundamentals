;
; A simple  boot  sector  program  that  demonstrates  segment  offsetting
;
; To build: nasm data_segment.nasm -f bin -o data_segment_nasm.bin
;
mov ah, 0x0e            ; int  10/ah = 0eh -> scrolling  teletype  BIOS  routine
mov al, [the_secret]
int 0x10                   ; Does  this  print an X? No

mov bx, 0x7c0             ; Can’t set ds directly , so set bx
mov ds, bx                 ; then  copy bx to ds.
mov al, [the_secret]
int 0x10                   ; Does  this  print an X? Yes

mov al, [es:the_secret] ; Tell  the  CPU to use  the es (not ds) segment.
int 0x10                   ; Does  this  print an X? No

mov bx, 0x7c0
mov es, bx
mov al, [es:the_secret]
int 0x10                   ; Does  this  print an X? Yes

jmp $                      ; Jump  forever.

the_secret:
    db "X"
    
; Padding  and  magic  BIOS  number.
times  510-($-$$) db 0
dw 0xaa55