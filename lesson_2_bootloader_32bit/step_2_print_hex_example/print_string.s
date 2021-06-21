.code16

# Print char function
# expects the value in al
print_char:
    pusha               # be polite and save registers as we do change ah
    mov $0xe, %ah       # bios print function
    int $0x10           # execute function
    popa                # the registers back
    ret                 # pops the return address of the stack

# Print string function
# expects string to be null terminated and placed
# in register si
print_string:
    pusha
    mov $0xe, %ah       # bios print function
print_string_loop:
    lodsb                       # load value using address in si into al and increment si
    cmp $0, %al                 # is register al zero?
    je print_string_complete
    int $0x10           # execute function
    jmp print_string_loop            # if not zero then loop
print_string_complete:
    popa                        # restore all registers from stack
    ret


# print hexadecimal value
# @param %cl    as value
print_hex_char:
    pusha
    cmp  $0x09, %cl               # compare to 9
    jg   print_hex_char_letter    # jump if greater
    add  $0x30, %cl               # convert to ascii (30-39)
    jmp   print_hex_char_output_char
print_hex_char_letter:
    add  $0x37, %cl               # add 41
print_hex_char_output_char:
    mov  %cl, %al                 # copy lower 8 bits
    call print_char
    popa
    ret

# Print a hex digit e.g. 0x1fb6
# @param %dx     value to print
print_hex:
    pusha
    mov $0x30, %al              # print 0
    call print_char

    mov $0x78, %al              # print x
    call print_char
    
    mov %dx, %cx                # copy dx to bx
    and $0xF000, %cx            # AND
    shr $12, %cx                # shift to the right
    or  $0x0000, %cx             
    call print_hex_char

    mov %dx, %cx                # copy dx to bx
    and $0x0F00, %cx            # AND
    shr $8, %cx                # shift to the right
    call print_hex_char

    mov %dx, %cx                # copy dx to bx
    and $0x00F0, %cx            # AND
    shr $4, %cx                # shift to the right
    call print_hex_char

    mov %dx, %cx                # copy dx to bx
    and $0x000F, %cx            # AND
    call print_hex_char

    popa
    ret

print_nl:
  pusha
  mov $0x0A, %al        # line feed moves down 1 line
  call print_char
  mov $0x0D, %al        # carriage return (dec: 13) returns to start of line
  call print_char
  popa
  ret

print_space:
  pusha
  mov $0x20, %al        # line feed moves down 1 line
  call print_char
  popa
  ret


clear_screen:
    pusha
    mov 0x06, %ah       # scroll up window
    mov $2, %al         # set al to 2, sets video mode as 80x25 16 foreground 8 background colors (http://vitaly_filatov.tripod.com/ng/asm/asm_023.1.html)
    xor %bx, %bx        # set BX to 0
    mov 0x07, %bh       # scroll down window
    xor %cx, %cx        # set cx to 0
    mov $24, %dh        # 25 lines
    mov $79, %dl        # 80 rows
    int $0x10
    popa
    ret

hide_cursor:
    pusha
    mov $0x01, %ah
    mov $0x2607, %cx
    int $0x10
    popa
    ret

move_cursor_to_top_left:
    pusha 
    mov $0x02, %ah
    xor %bx, %bx
    xor %dx, %dx
    int $0x10
    popa 
    ret

# https://en.wikipedia.org/wiki/A20_line
# https://www.win.tue.nl/~aeb/linux/kbd/A20.html
enable_a20_gate:
    pusha
    inb $0x92, %al              # copies the value to i/o port 0x92 to register AL
    testb $02, %al              # test if we need to set second bit to 1 or if it is set already
    jnz no_enable_a20_gate      # jump if its set
    orb $02, %al                # sets to 1 the second bit of AL
    andb $0xfe, %al             # Since bit 0 sometimes is write-only, and writing a one there causes a reset
    outb %al, $0x92             # copies out from register AL to the port address of 0x92
no_enable_a20_gate:
    popa
    ret

