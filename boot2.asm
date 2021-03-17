org 0x7e00
bits 16

start:
    mov [bootDrive], dl
get_mem_map:
    xor eax, eax
    mov es, ax
    mov di, [mem_map]
    xor ebx, ebx
    mov edx, 0x534d4150
    mov eax, 0xe820
    mov ecx, 24
    int 0x15
    cmp eax, 0x534d4150
    jnz obsolete_sys
    or ebx, ebx
    jz end_mem_m_loop
    jc end_mem_m_loop
mem_m_loop:
    add di, 24
    mov eax, 0xe820
    mov ecx, 24
    int 0x15
    or ebx, ebx
    jz end_mem_m_loop
    jc end_mem_m_loop
    jmp mem_m_loop
end_mem_m_loop:
get_vbe_info:
    mov di, vbe_info
    mov ax, 0x4f00
    int 0x10
    cmp ax, 0x004f
    jnz obsolete_sys
    mov ax, [vbe_info.vid_mod_seg]
    mov es, ax
    mov di, [vbe_info.vid_mod_off]
    xor bx, bx
    mov bx, word[es:di]
get_hi_mod_loop:
    add di, 2
    mov cx, word[es:di]
    cmp cx, 0xffff
    jz end_get_hi_mod_loop
    cmp cx, bx
    jl get_hi_mod_loop
    mov bx, cx
    jmp get_hi_mod_loop
end_get_hi_mod_loop:
get_vbemod_info:
    mov di, vbe_mod_info
    xor ax, ax
    mov es, ax
    mov ax, 0x4f01
    int 0x10
    mov [vbe_mod_info.mode], bx
    mov ax, 0x4f02
    or bx, 0x4000
    int 0x10
    cmp ax, 0x004f
    jnz obsolete_sys
load_gdt:
    cli
    lgdt [gdtptr]
    sti
set_a20:
    call check_a20
    cmp ax, 1
    jz enabled_a20
    mov al, 0xdd
    out 0x64, al
    call check_a20
    cmp ax, 1
    jz enabled_a20
    mov al, 0xd0
    out 0x64, al
    call wait_8042_data
    in al, 0x60
    push eax
    call wait_8042_comm
    mov al, 0xd1
    out 0x64, al
    call wait_8042_comm
    pop eax
    or al, 2
    out 0x60, al
    call check_a20
    cmp ax, 1
    jz enabled_a20
enabled_a20:
load_kern:
    mov ax, 0xf100
    mov es, ax
    mov bx, 0xf000
    mov ah, 2
    mov al, 14
    mov ch, 0
    mov cl, 8
    mov dh, 0
    mov dl, [bootDrive]
    int 0x13
    jc failedToLoad
    cmp al, 14
    jnz failedToLoad
switch_x86:
    mov cx, vbe_info
    mov dx, vbe_mod_info 
    cli
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    db 0x66
    db 0xea
    dd 0x100000
    dw 0x8

wait_8042_comm:
    in al, 0x64
    test al, 2
    jz wait_8042_comm
    ret

wait_8042_data:
    in al, 0x64
    test al, 1
    jz wait_8042_data
    ret

failedToLoad:
    int 0x19

check_a20:
    pusha
    xor bx, bx
    mov es, bx
    mov ax, [es:0x7dfe]
    mov bx, 0xffff
    mov es, bx
    cmp ax, [es:0x7e0e]
    jnz not_set
    popa
    mov ax, 0
    jmp end_check_a20
not_set:
    popa
    mov ax, 1
end_check_a20:
    ret

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

vbe_info:
    .signature:
        db "VBE2"
    .version:
        dw 0
    .oem_off:
        dw 0
    .oem_seg:
        dw 0
    .capabilities:
        dd 0
    .vid_mod_off:
        dw 0
    .vid_mod_seg:
        dw 0
    .vid_mem:
        dw 0
    .softw_rev:
        dw 0
    .vendor_off:
        dw 0
    .vendor_seg:
        dw 0
    .prod_name_off:
        dw 0
    .prod_name_seg:
        dw 0
    .prod_rev_off:
        dw 0
    .prod_rev_seg:
        dw 0
    .resv:
        resb 222
    .oem_data:
        resb 256

vbe_mod_info:
    .attr:
        dw 0
    .garb:
        resb 112
    .pitch:
        dw 0
    .width:
        dw 0
    .height:
        dw 0
    .garb1:
        resb 24
    .bpp:
        db 0
    .garb2:
        resb 112
    .framebuf:
        dd 0
    .offscr_mem_off:
        dd 0
    .offscr_mem_size:
        dw 0
    .padding:
        resb 206
    .mode:
        dd 0

gdt:

null_dsc:
    dd 0
    dd 0

code_dsc:
    .seg_lim_lo:
        dw 0xffff
    .base_lo:
        dw 0
    .base_mid:
        db 0
    .attrib_acc:
        db 10011010b
    .attrib_gra:
        db 11001111b
    .base_hi:
        db 0
data_dsc:
    .seg_lim_lo:
        dw 0xffff
    .base_lo:
        dw 0
    .base_mid:
        db 0
    .attrib_acc:
        db 10010010b
    .attrib_gra:
        db 11001111b
    .base_hi:
        db 0
gdtptr:
    dw gdtptr - gdt - 1
    dd gdt

mem_map:
    dd 0x0500
bootDrive:
    db 0
obsolete_sysmsg:
    db "Unsupported system", 0

    times (512 * 6) - ($ - $$) db 0
    