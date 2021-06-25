# use a bootloader called grub 
# we use the multiboot specification
# https://www.gnu.org/software/grub/manual/multiboot/multiboot.html
# https://www.gnu.org/software/grub/manual/multiboot/html_node/boot_002eS.html#boot_002eS

.section .multiboot_header

# the specification requires that the header is 8 byte aligned
.align 8

multiboot_header_start:
    # In multiboot2 this header needs to be found in the first 32k of the
    # OS image.  In multiboot1 it should be in the first 8k.
    # The checksum to validate that this is a multiboot header.
    # It does not check errors in the multiboot header.
    # 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))
    # Multiboot 2 compliant kernels used the magic number 0xE85250D6, 
    # and Multiboot-compliant bootloaders report themselves with magic number 0x36D76289. 
    .long 0xe85250d6                                                                               # magic number for multiboot
    .long 0x0                                                                                      # protected mode code
    .long (multiboot_header_end - multiboot_header_start)                                          # header size
    .long (- (0xe85250d6 + 0 + (multiboot_header_end - multiboot_header_start)))      # multiboot 2 checksum
    .word 0x0
    .word 0x0
    .long 0x8
multiboot_header_end:

