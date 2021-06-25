.code16

// PML4T[0] -> PDPT.
// PDPT[0] -> PDT.
// PDT[0] -> PT.
// PT -> 0x00000000 - 0x00200000. 
clear_paging_table_memory:
    mov $0x1000,%edi      # Set the destination index to 0x1000.
    mov %edi,%cr3         # Set control register 3 to the destination index.
    xor %eax, %eax        # Nullify the A-register.
    mov $4096,%ecx        # Set the C-register to 4096.
    rep stosl           # Clear the memory.
    mov %cr3,%edi         # Set the destination index to control register 3.
