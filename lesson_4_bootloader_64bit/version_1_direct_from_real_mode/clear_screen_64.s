.code64

clear_screen_64:
    cli                           # Clear the interrupt flag.
    mov $GDT64_Data, %ax           # Set the A-register to the data descriptor.
    mov %ax, %ds                    # Set the data segment to the A-register.
    mov %ax, %es                    # Set the extra segment to the A-register.
    mov %ax, %fs                    # Set the F-segment to the A-register.
    mov %ax, %gs                     # Set the G-segment to the A-register.
    mov %ax, %ss                     # Set the stack segment to the A-register.
    mov $0xB8000, %edi               # Set the destination index to 0xB8000.
    mov $0x1F201F201F201F20,%rax   # Set the A-register to 0x1F201F201F201F20.
    mov $500,%ecx                  # Set the C-register to 500.
    rep stosq                     # Clear the screen.
    hlt                           # Halt the processor.

