setup_paging_tables:                 # this sets up something called identity paging.
    # the 3 at the end will make the last bits 11 which indicates readable and writable.
    mov $0x2003, %edi               # Set the uint32_t at the destination index to 0x2003 (8195).  PML4T(0) -> PDPT
    add $0x1000, %edi                 # Add 0x1000 to the destination index. (0x1000 = 4096)
    mov $0x3003, %edi               # Set the uint32_t at the destination index to 0x3003 (12291). PDPT(0) -> PDT
    add $0x1000, %edi                 # Add 0x1000 to the destination index.
    mov $0x4003, %edi               # Set the uint32_t at the destination index to 0x4003 (16387). PDT(0) -> PT
    add $0x1000, %edi                 # Add 0x1000 to the destination index.

    mov $0x00000003, %ebx             # Set the B-register to 0x00000003.
    mov $512, %ecx                    # Set the C-register to 512, loops 512 entries

.set_entry:
    mov %ebx, %edi                  # Set the uint32_t at the destination index to the B-register.
    add $0x1000, %ebx                # Add 0x1000 to the B-register.
    add $8, %edi                     # Add eight to the destination index.
    loop .set_entry                  # Set the next entry.

    mov $0x2003, %eax                   # load the pointer to PML4T table
    mov %eax, %cr3                      # set control register 3 to the A-register

enable_physical_address_extension:
    mov %cr4, %eax                    # Set the A-register to control register 4.
    or $1 << 5, %eax                 # Set the PAE-bit, which is the 6th bit (bit 5).
    mov %eax, %cr4                    # Set control register 4 to the A-register.

    # the paging is now set up but not enabled

enable_long_mode: 
    # set the long mode (LM) bit
    mov $0xC0000080,%ecx              # Set the C-register to 0xC0000080, which is the EFER MSR.
    rdmsr                           # Read from the model-specific register.
    or $1 << 8, %eax                 # Set the LM-bit which is the 9th bit (bit 8).
    wrmsr                           # Write to the model-specific register. (Write the value in EDX:EAX to MSR specified by ECX.)

enable_paging: 
    # enable paging and protected mode
    mov %cr0, %eax                    # Set the A-register to control register 0.
    #or $1 << 31, eax                # Set the PG-bit, which is the 32nd bit (bit 31), in 16-bit you would also need to set the 0th bit to 1
    or $1 << 31 | 1 << 0, %eax        # Set the PG-bit, which is the 32nd bit (bit 31), in 16-bit you would also need to set the 0th bit to 1 
    mov %eax, %cr0                    # Set control register 0 to the A-register.

    ret

