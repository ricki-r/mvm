org 0x7e00
bits 16

    xor eax, eax
    mov es, ax
    mov di, [kernel_essentials]
    xor ebx, ebx
    mov edx, 0x534d4150
    mov eax, 0xe820
    mov ecx, 24
    int 0x15
    cmp eax, 0x534d4150
    jnz obsolete_sys
    or ebx, ebx
    jz complete
    jc complete
mem_m_loop:
    add di, 24
    mov eax, 0xe820
    mov ecx, 24
    int 0x15
    or ebx, ebx
    jz complete
    jc complete
    jmp mem_m_loop
complete:
    mov [next_addr], di
    mov byte[di+3], 'V'
    mov byte[di+2], 'B'
    mov byte[di+1], 'E'
    mov byte[di], '2'
    mov ax, 0x4f00
    int 0x10
    cmp ax, 0x004f
    jnz obsolete_sys
    cli
    hlt

print:
    pusha
    mov ah, 0x0e
print_loop:
    lodsb
    or al, al
    jz print_end
    int 0x10
    jmp print_loop
print_end:
    popa
    ret

obsolete_sys:
    mov si, obsolete_sysmsg
    call print
    cli
    hlt

kernel_essentials:
    base_addr:
        dd 0x0500
    next_addr:
        dd 0
obsolete_sysmsg:
    db "Unsupported system", 0

    times (510 * 3) - ($ - $$) db 0