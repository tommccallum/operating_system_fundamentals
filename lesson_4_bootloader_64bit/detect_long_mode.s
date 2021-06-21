# https://wiki.osdev.org/User:Stephanvanschaik/Setting_Up_Long_Mode#Detecting_the_Presence_of_Long_Mode
# Check if the CPU instruction 'CPUID' is supported by attempting to flip the ID bit (bit 21) in
# the FLAGS register. If we can flip it, CPUID is available.

detect_cpuid_instruction:
    pushfd                      # Copy FLAGS in to EAX via stack
    pop %eax
    mov %eax, %ecx              # Copy to ECX as well for comparing later on
    xor $1 << 21, %eax          # Flip the ID bit
    push %eax                   # Copy EAX to FLAGS via the stack
    popfd    
    pushfd                      # Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
    pop %eax
    push %ecx                   # Restore FLAGS from the old version stored in ECX (i.e. flipping the ID bit
    popfd                       # back if it was ever flipped).
    xor %ecx, %eax              # Compare EAX and ECX. If they are equal then that means the bit wasn't
    jz no_cpuid_instruction     # flipped, and CPUID isn't supported.
    ret

no_cpuid_instruction:
    mov $MSG_NO_CPUID, %si         # give the user a message
    call print_string
    ret

MSG_NO_CPUID:        .asciz "cpuid instruction is not supported by cpu"
MSG_NO_LONG_MODE:    .asciz "no long mode available"

# now we use the CPUID instruction to test for long mode
check_for_long_mode:
    mov $0x80000000,%eax        # Set the A-register to 0x80000000.
    cpuid                       # CPU identification.
    cmp $0x80000001, %eax       # Compare the A-register with 0x80000001.
    jb NoLongMode               # It is less, there is no long mode.
    mov $0x80000001, %eax       # Set the A-register to 0x80000001.
    cpuid                       # CPU identification.
    test $1 << 29, %edx         # Test if the LM-bit, which is bit 29, is set in the D-register.
    jz NoLongMode               # They aren't, there is no long mode.
    jmp enter_long_mode         # if we get this far we can try to jump to long mode

NoLongMode:
    mov $MSG_NO_64BIT_MODE, %si         # give the user a message
    call print_string
    ret


enter_long_mode:
disable_old_paging_table:
    mov %eax, %cr0                                      # Set the A-register to control register 0.
    and %eax, $01111111111111111111111111111111b        # Clear the PG-bit, which is bit 31.
    mov %cr0, %eax                                      # Set control register 0 to the A-register.
clear_the_page_tables:
    mov $0x1000, %edi                                   # Set the destination index to 0x1000.
    mov %edi, %cr3                                      # Set control register 3 to the destination index.
    xor %eax, %eax                                      # Nullify the A-register.
    mov 4096, %ecx                                      # Set the C-register to 4096.
    rep stosd                                           # Clear the memory.
    mov %cr3, %edi                                      # Set the destination index to control register 3.
setup_pml4t:
    mov $0x2003, %edi               # Set the uint32_t at the destination index to 0x2003.
    add $0x1000, %edi               # Add 0x1000 to the destination index.
    mov $0x3003, %edi               # Set the uint32_t at the destination index to 0x3003.
    add $0x1000, %edi               # Add 0x1000 to the destination index.
    mov $0x4003, %edi               # Set the uint32_t at the destination index to 0x4003.
    add $0x1000, %edi               # Add 0x1000 to the destination index.
make_identity_map_for_first_two_megabytes:
    mov $0x00000003, %ebx          # Set the B-register to 0x00000003.
    mov $512, %ecx                 # Set the C-register to 512.
 
.SetEntry:
    mov %ebx, (%edi)                  # Set the uint32_t at the destination index to the B-register.
    add $0x1000, %ebx               # Add 0x1000 to the B-register.
    add $8, %edi                   # Add eight to the destination index.
    loop .SetEntry               # Set the next entry.

enable_pae_paging:
    mov %cr4, %eax                 # Set the A-register to control register 4.
    or $1 << 5, %eax               # Set the PAE-bit, which is the 6th bit (bit 5).
    mov %eax,%cr4                 # Set control register 4 to the A-register.

set_long_mode_bit:
    mov $0xC0000080, %ecx          # Set the C-register to 0xC0000080, which is the EFER MSR.
    rdmsr                        # Read from the model-specific register.
    or $1 << 8, %eax               # Set the LM-bit which is the 9th bit (bit 8).
    wrmsr                        # Write to the model-specific register.

enable_paging_and_protected_mode:
    mov %cr0, %eax                 # Set the A-register to control register 0.
    or $1 << 31 | 1 << 0, %eax     # Set the PG-bit, which is the 31nd bit, and the PM-bit, which is the 0th bit.
    mov %eax, %cr0                 # Set control register 0 to the A-register.
    # at this point we are in 32-bit compatibility mode, not 64-bit long mode
enter_full_long_mode:
    lgdt GDT64         # Load the 64-bit global descriptor table.
    jmp Realm64       # Set the code segment and enter 64-bit long mode.

.code64
Realm64:
clear_screen_64:
    cli                           # Clear the interrupt flag.
    mov ax, GDT64.Data            # Set the A-register to the data descriptor.
    mov ds, ax                    # Set the data segment to the A-register.
    mov es, ax                    # Set the extra segment to the A-register.
    mov fs, ax                    # Set the F-segment to the A-register.
    mov gs, ax                    # Set the G-segment to the A-register.
    mov ss, ax                    # Set the stack segment to the A-register.
    mov edi, 0xB8000              # Set the destination index to 0xB8000.
    mov rax, 0x1F201F201F201F20   # Set the A-register to 0x1F201F201F201F20.
    mov ecx, 500                  # Set the C-register to 500.
    rep stosq                     # Clear the screen.
    hlt                           # Halt the processor.

