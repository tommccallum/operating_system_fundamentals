# https://wiki.osdev.org/User:Stephanvanschaik/Setting_Up_Long_Mode#Detecting_the_Presence_of_Long_Mode
# Check if the CPU instruction 'CPUID' is supported by attempting to flip the ID bit (bit 21) in
# the FLAGS register. If we can flip it, CPUID is available.


.code16

# now we use the CPUID instruction to test for long mode
detect_long_mode:
    # first we have to check to see if the CPU supports the extended functions that allow us to 
    # determine if long mode is available
    mov $0x80000000,%eax        # Set the A-register to 0x80000000.
    cpuid                       # CPU identification.
    cmp $0x80000001, %eax       # Compare the A-register with 0x80000001.
    jb err_no_long_mode         # It is less, there is no long mode.

    # next we can go on to check to see if long mode is available
    mov $0x80000001, %eax       # Set the A-register to 0x80000001.
    cpuid                       # CPU identification.
    test $1 << 29, %edx         # Test if the LM-bit, which is bit 29, is set in the D-register.
    jz err_no_long_mode         # They aren't, there is no long mode.
    ret

err_no_long_mode:
    // mov $MSG_NO_LONG_MODE, %si         # give the user a message
    // call print_string
    // ret
    mov  $'2, %al               # print a B
    call error16
