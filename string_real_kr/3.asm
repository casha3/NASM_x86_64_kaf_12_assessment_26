;ostavit v stroke only delims , digits and letters
;ostalnoye delete
bits 64
%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_EXIT 60
%define STDIN 0
%define STDOUT 1
section .bss
    buf1 resb 82
    buf2 resb 82
section .text   
    global _start
_start:
    mov rax , SYS_READ
    mov rdi , STDIN
    mov rsi , buf3
    mov rdx , 81 
    syscall
    ; rax = len = amount of readen bytes = sys_read()
    mov rbx , rax
    xor rcx ,rcx
    xor r12 , r12
    keep_loop:
        cmp rcx,rbx
        jge keep_done
        ; doing main part of the cycle when 0 , 1 .. < len 
        mov al , [buf1 + rcx]
        cmp al , ' '
        ; delims are saved
        je keep_save
        cmp al , '0'
        jl check_alpha
        cmp al , '9'
        jle keep_save
        ; digits are saved
        check_alpha:
            ; int('A') < int('Z') < int('a') < int('z')  
            cmp al , 'A'
            jl keep_skip
            cmp al , 'Z'
            jle keep_save
            cmp al , 'a'
            jl keep_skip 
            cmp al, 'z'
            jg keep_skip
        keep save:
            mov [out+r12], al 
            inc r12 
        keep_skip:
            inc rcx
            jmp keep_loop
        keep_done:
            mov byte[out3 + r12] , 10
            inc r12
            mov rax , SYS_WRITE 
            mov rdi , STDOUT 
            mov rsi , out3   
            mov rdx , r12
            syscall
            mov rax , SYS_EXIT
            xor rdi , rdi
            syscall
