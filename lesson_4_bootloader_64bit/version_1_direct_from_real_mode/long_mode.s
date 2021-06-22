.code64

BEGIN_LONG_MODE:
  mov $DATA_SEG, %ax          # start to write our new segments to registers
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs
  mov %ax, %ss

  mov $0x9000, %ebp           # update our stack pointer
  mov %ebp, %esp              # so it lies at the top of the free space

  //.include "clear_screen_64.s"

  # print Y to screen
  mov $0xb8000, %eax
  mov $0x2f4b2f4f, %ebx
  mov %ebx, (%eax)
OK:
  hlt
  call OK

