.code64

.set VIDEO_MEMORY, 0xb8000

print_char64:
    # cannot use pusha in 64-bit mode, need to manually save and reload registers from stack.
    # e.g. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/entry_64.S?id=6c3176a21652e506ca7efb8fa37a651a3c513bb5
    mov $VIDEO_MEMORY, %eax
    mov %al, %eax
    ret
