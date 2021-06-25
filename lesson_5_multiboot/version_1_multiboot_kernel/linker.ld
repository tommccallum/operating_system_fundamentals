/* give the name of our entry point (remember that .global keyword?) */
ENTRY(start)

SECTIONS {
    . = 1M;                 /* our first section will go at the 1 megabyte mark */

    .boot :
    {
        /* ensure that the multiboot header is at the beginning */
        *(.multiboot_header)
    }

    .text :
    {
        *(.text)
    }
}