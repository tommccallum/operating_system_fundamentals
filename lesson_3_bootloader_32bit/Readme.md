# Some extra functions

## print_string

```
as -o print_exe.o print_exe.s
ld -o print_exe.bin --oformat binary -Ttext 0x7c00 -e _start print_exe.o
qemu-system-x86_64 print_exe.bin
```

## print hex number

```
as -o print_hex.o print_hex.s
ld -o print_hex.bin --oformat binary -Ttext 0x7c00 -e _start print_hex.o
qemu-system-x86_64 print_hex.bin
```

## data sectors

```
as -o data_segment.o data_segment.s
ld -o data_segment.bin --oformat binary -Ttext 0x0000 -e _start data_segment.o
qemu-system-x86_64 data_segment.bin
```

## read disk sectors

```
as -o read_disk.o read_disk.s
ld -o read_disk.bin --oformat binary -Ttext 0x7c00 -e _start read_disk.o
qemu-system-x86_64 read_disk.bin
```

## Switching to Protected mode

```
as -o boot_with_switch.o boot_with_switch.s
ld -o boot_with_switch.bin --oformat binary -Ttext 0x7c00 -e _start boot_with_switch.o
qemu-system-x86_64 boot_with_switch.bin
```


## References

[1] https://www.codeproject.com/Articles/664165/Writing-a-boot-loader-in-Assembly-and-C-Part
[2] https://en.wikipedia.org/wiki/X86#/media/File:Table_of_x86_Registers_svg.svg
[3] https://stackoverflow.com/questions/55972474/controller-error-20h-for-int-13h-for-writing-a-bootloader
[4] https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html
[5] https://wiki.osdev.org/Assembly#AT.26T_Syntax