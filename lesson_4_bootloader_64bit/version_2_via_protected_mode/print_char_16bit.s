.code16

# Print char function
# expects the value in al
print_char16:
    pusha               # be polite and save registers as we do change ah
    mov $0xe, %ah       # bios print function
    int $0x10           # execute function
    popa                # the registers back
    ret                 # pops the return address of the stack

    