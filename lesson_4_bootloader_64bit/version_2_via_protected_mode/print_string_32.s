# Printing routines for 32-bit protected mode
# Sends data directly to memory
# 1 byte for character attributes
# 1 byte for character
# Video memory is at 0xb8000
# Given a (row,col) pair then we get the formula for the address = 0xb8000 + 2 * (row * 80 + col)
.code32

.set VIDEO_MEMORY, 0xb8000        # 80x25 (rows x cols) video memory location (4000 bytes = 80 * 25 * 2)
.set WHITE_ON_BLACK, 0x0F         # 1 byte, white on black style


# Print char function
# expects the value in al
print_string_32:
    pusha                               # save all registers to stack
    mov $VIDEO_MEMORY, %edx             # write video memory location to memory

print_string_32_loop:
    mov (%ebx), %al                     # write letter
    mov $WHITE_ON_BLACK, %ah            # write attribute
    
    cmp $0, %al
    je print_string_32_complete

    mov %ax, (%edx)
    add $1, %ebx                        # increment egbx to the next char in string
    add $2, %edx                        # move to next character cell in video memory

    jmp  print_string_32_loop           # if not zero then loop

print_string_32_complete:
    popa                                # restore all registers from stack
    ret

