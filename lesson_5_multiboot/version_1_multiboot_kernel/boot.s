# https://intermezzos.github.io/book/first-edition/hello-world.html

# .global makes the symbol start visible to the linker ld.
# you can use either .globl or .global due to compatibility issues
.global start

# code is stored in a .text section
.section .text

# the multiboot will put us directly into protected mode (32-bit), not real mode (16-bit)
.code32

start:
    # why are we using 0xb8000?  This is because the screen is a memory mapped device.
    # why B000?  http://www.philipstorr.id.au/pcbook/book3/videosys.htm
    # Range of memory for video is 0xB8000-BFFF
    # The BIOS and motherboard both know that this range is routed to the video controller.
    mov $0xb8000, %eax          # write an H
    mov $0x0248, %ebx          # 0 = background, 2 = foreground, 48 = ascii letter
    mov %ebx, (%eax)         
    hlt
