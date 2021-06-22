.code64

# Prints `ERR: ` and the given error code to screen and hangs.
# parameter: error code (in ascii) in al
# 0xb8000 is the start of the video memory
# 0x52 is an ASCII R, 0x45 is an E, 0x3a is a :, and 0x20 is a space
.set VIDEO_MEMORY, 0xb8000

error64:
    mov $VIDEO_MEMORY, %eax
    mov $0x4f524f45, %ebx
    mov %ebx, (%eax)
    mov $0x4f3a4f52, %ebx
    mov %ebx, 4(%eax)
    mov $0x4f204f20, %ebx
    mov %ebx, 8(%eax)
    mov %ax, 12(%eax)
    hlt

