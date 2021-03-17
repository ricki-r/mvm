org 0x100000
bits 32

start:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    hlt