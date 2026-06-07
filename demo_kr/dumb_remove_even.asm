default rel
bits 64
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60
STDIN equ 0
STDOUT equ 1 
TAB equ 9
LF equ 10
SPC equ 32 
section .bss
    buf1 resb 82
    buf2 resb 82
section .text
    global _start
_start:
    mov rax , SYS_READ 
    mov rdi , STDIN 
    lea rsi , [buf1]
    mov rdx , 81
    syscall
    test rax , rax
    jz .keep_done
    dec rax
    mov rbx , rax
    xor rcx , rcx
    xor r12 , r12
    xor r9,r9
    .loop:
        cmp rcx,rbx
        jge .keep_done
        cmp byte[buf1+rcx] , ` `
        je .OK
        cmp byte[buf1+rcx] , `\t`
        jne .forwarding_rcx
        .OK:
            mov dl , byte [buf1 + rcx]
            mov byte[buf2 + r9 ] , dl
            inc r9
            inc rcx
            inc r12
            jmp .loop
        .forwarding_rcx:
            cmp rcx , rbx
            jge .pivot
            mov dl , byte[buf1+rcx]
            cmp dl , ` `
            je .pivot
            cmp dl , `\t`
            je .pivot
            inc rcx
            jmp .forwarding_rcx
        .pivot:
            mov rdx,rcx
            xor rdx,r12
            test rdx,1
            jz .bad_forwarding_r12
            .good_forwarding_r12:
                cmp r12, rcx
                jge .loop
                mov dl , byte[buf1+r12]
                mov byte[buf2+r9] , dl
                inc r9
                inc r12
                jmp .good_forwarding_r12
            .bad_forwarding_r12:
                mov r12,rcx
                jmp .loop
        .keep_done:
            mov byte[buf2+r9] , `\n`
            inc r9
            mov rax , SYS_WRITE
            mov rdi  , STDOUT
            lea rsi , [buf2]
            mov rdx , r12
            syscall
            mov rax , SYS_EXIT
            xor rdi , rdi
            syscall