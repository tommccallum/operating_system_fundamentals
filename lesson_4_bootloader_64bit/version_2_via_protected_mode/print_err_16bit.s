.code16

# Print char function
# expects the value in al
error16:
    // mov %al, %bl        # save %al into %bl for safe keeping
    // mov $'E, %al
    // mov $0xe, %ah       # bios print function
    // int $0x10           # execute function
    // mov $'R, %al
    // mov $0xe, %ah       # bios print function
    // int $0x10           # execute function
    // mov $'R, %al
    // mov $0xe, %ah       # bios print function
    // int $0x10           # execute function
    // mov $':, %al
    // mov $0xe, %ah       # bios print function
    // int $0x10           # execute function
    // mov %bl, %al
    mov $0xe, %ah       # bios print function
    int $0x10           # execute function
halt_err:
    jmp halt_err
