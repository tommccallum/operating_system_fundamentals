disable_32bit_paging:
    mov %cr0, %eax                                  # Set the A-register to control register 0.
    and $0b01111111111111111111111111111111, %eax   # Clear the PG-bit, which is bit 31.
    mov %eax, %cr0                                  # Set control register 0 to the A-register.

