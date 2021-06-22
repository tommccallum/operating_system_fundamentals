# https://en.wikipedia.org/wiki/A20_line
# https://www.win.tue.nl/~aeb/linux/kbd/A20.html
enable_a20_gate:
    pusha
    inb $0x92, %al              # copies the value to i/o port 0x92 to register AL
    testb $02, %al              # test if we need to set second bit to 1 or if it is set already
    jnz no_enable_a20_gate      # jump if its set
    orb $02, %al                # sets to 1 the second bit of AL
    andb $0xfe, %al             # Since bit 0 sometimes is write-only, and writing a one there causes a reset
    outb %al, $0x92             # copies out from register AL to the port address of 0x92
no_enable_a20_gate:
    popa
    