bits 16
org 0x7c00

start:
    jmp loader

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

loader:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov [bootDrive], dl

    mov ah, 0
    mov al, 3
    int 0x10

    mov bp, 0x2800
    mov sp, bp
    
    xor ah, ah
    mov dl, [bootDrive]
    int 0x13
    jc failedToReset
    jmp loadSec2

failedToReset:
    mov si, failedToResetmsg
    call print
    int 0x19

loadSec2:
    xor ax, ax
    mov es, ax
    mov bx, 0x7e00
    mov ah, 2
    mov al, 3
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootDrive]
    int 0x13
    jc failedToLoad
    cmp al, 3
    jnz failedToLoad
    jmp 0x7e00

failedToLoad:
    mov si, failedToLoadmsg
    call print
    int 0x19

bootDrive:
    db 0
failedToResetmsg:
    db "Attempt to reset the disk failed", 0
failedToLoadmsg:
    db "Attempt to load boot2 failed", 0

times 510 - ($ - $$) db 0
dw 0xaa55
