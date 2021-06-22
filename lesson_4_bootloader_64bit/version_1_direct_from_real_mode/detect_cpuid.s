.code16

detect_cpuid:
    pushfl                      # Copy FLAGS in to EAX via stack
    pop %eax
    mov %eax, %ecx              # Copy to ECX as well for comparing later on
    xor $1 << 21, %eax          # Flip the ID bit
    push %eax                   # Copy EAX to FLAGS via the stack
    popfl    

    # Check to see if bit remains flipped

    pushfl                      # Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
    pop %eax
    push %ecx                   # Restore FLAGS from the old version stored in ECX (i.e. flipping the ID bit
    popfl                       # back if it was ever flipped).

    xor %ecx, %eax              # Compare EAX and ECX. If they are equal then that means the bit wasn't
    jz err_no_cpuid_instr     # flipped, and CPUID isn't supported.
    ret

err_no_cpuid_instr:
    // mov $MSG_NO_CPUID, %si         # give the user a message
    // call print_string
    // ret
    mov  $'1, %al               # print a B
    call error16

