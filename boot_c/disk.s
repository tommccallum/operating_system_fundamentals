# read n sectors from disk
# @param DX has the number of sectors to read in
disk_load:
    push %dx        # save register DX to stack
    mov $0x02, %ah  # BIOS read sector function
    mov %dh,   %al  # read n sectors
    mov $0x0,  %ch  # select cylinder 0
    mov $0x0,  %dh  # select head 0
    mov $0x02, %cl  # start reading from sector 2 (just after the boot sector)
    int $0x13       # call BIOS

    jc disk_error1   # jump if carry flag is set which indicates an error occurred

    pop %dx         # restore our original DX value
    cmp %al, %dh    # compare the actual number of sectors read against the expected value
    jne disk_error2  # display error message if not equal
    ret

disk_error1:
    mov %ah, %dl
    call print_hex
    mov $DISK_ERROR_MSG1, %si
    call print_string 
    call halt_os

disk_error2:
    mov $DISK_ERROR_MSG2, %si
    call print_string
    call halt_os

DISK_ERROR_MSG1: .asciz ": error during disk read "
DISK_ERROR_MSG2: .asciz "Different values!"

# place computer into infinite loop to stop further processing
halt_os:
    hlt
    jmp halt_os


