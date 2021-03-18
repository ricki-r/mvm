.global start

start:
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %ss
    mov %ax, %es
    mov %esp, stack
    call kernel_entry
    hlt

stack:
    
