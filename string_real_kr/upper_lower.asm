; swap upper_register <-> lower_register
bits 64
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60
STDIN equ 0
STDOUT equ 1

section .bss
    buf1 resb 82
    buf2 resb 82
section .text   
    global _start
_start:
    mov rax , SYS_READ
    mov rdi , STDIN
    mov rsi, buf1
    mov rdx, 81 
    syscall
    ; rax = len = amount of readen bytes = sys_read()
    mov rbx , rax
    xor rcx,rcx
    .swap_loop:
        cmp rcx, rbx
        jge .swap_done
        ; doing main part of the cycle when 0 , 1 .. < len
        ; if we need to change letter jump into swap_save 
        ; else jump into swap_next ( nothing changes)
        mov al, [buf1 + rcx]
        ; int('A') < int('Z') < int('a') < int('z')  
        cmp al , 'a'
        jl .check_upper
        cmp al , 'z'
        jg .swap_save
        ; we found upper_register -> change on upper_register
        sub al , 32
        jmp .swap_save
        .check_upper:
            cmp al, 'A'
            jl .swap_save
            cmp al , 'Z'
            jg .swap_save
            ; we found lower_register -> change on upper_register
            add al , 32
        .swap_save:
            mov [buf2+rcx], al
        .swap_next:
            inc rcx
            jmp .swap_loop
    .swap_done:
        mov rax , SYS_WRITE
        mov rdi , STDOUT
        mov rsi, buf2
        mov rdx , rbx ; len(buf1) = len(buf2)
        syscall
        mov rax , SYS_EXIT 
        xor rdi,rdi
        syscall


