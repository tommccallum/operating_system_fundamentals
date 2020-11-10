__asm__(".code16\n");
__asm__("jmpl $0x0000, $main\n");

void main() {
    // we could just copy our commands as follows
    // from before in but thats not very helpful.
    // __asm__ __volatile__ ("movb $'X'  , %al\n");
    // __asm__ __volatile__ ("movb $0x0e, %ah\n");
    // __asm__ __volatile__ ("int $0x10\n");

    // unfortunately our BIOS interrupts will no longer be 
    // available once we move out of REAL MODE.
    // Usefully we can still print as a simple font is
    // build in to the default VGA hardware.

    

} 