bits 64

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60
STDIN equ 0
STDOUT equ 1

TAB equ 9
LF equ 10 ; back_slash_n
SPC equ 32 ; space

section .bss
	buf1 resb 82
	buf2 resb 82
section .text
	global _start
_start:
	mov rax , SYS_READ
	mov rdi , STDIN
	mov rsi , buf1
	mov rdx , 81
	syscall
	dec rax  ; elimination_of_LF_aka_backslashn 
	mov rbx , rax
	xor rcx,rcx
	xor r12,r12
	.first_symbol:
		cmp rcx,rbx
		jge .wasted
		mov dl , byte[buf1+rcx]
		cmp dl , `\t`
		je .next_iteration_first_symbol
		cmp dl , ` `
		jne .loop_letter
		.next_iteration_first_symbol:
			mov byte[buf2+r12] , dl
			inc rcx
			inc r12
			jmp .first_symbol
	.loop_letter:
		cmp rcx,rbx
		jge .success
		mov dl , byte[buf1 + rcx ]
		cmp dl , `\t`
		je .loop_delim_entrance
		cmp dl , ` `
		je .loop_delim_entrance
		.copy_from_buf1_to_buf2:
			mov byte[buf2 + r12] , dl
			inc rcx
			inc r12
			jmp .loop_letter
	.loop_delim_entrance:
		mov byte[buf2+r12],`a`
		inc r12
		mov byte[buf2+r12],`b`
		inc r12
		mov byte[buf2+r12],`c`
		inc r12
		.loop_delim:
			cmp rcx,rbx
			jge .wasted
			mov dl , byte[buf1+rcx]
			cmp dl , `\t`
			je .next_iteration_loop_delim
			cmp dl , ` `
			jne .loop_letter
			.next_iteration_loop_delim:
				mov byte[buf2+r12] , dl
				inc rcx
				inc r12
				jmp .loop_delim
	.success:
		mov byte[buf2+r12],`a`
		inc r12
		mov byte[buf2+r12],`b`
		inc r12
		mov byte[buf2+r12],`c`
		inc r12
	.wasted:
		mov byte[buf2+r12],10
		inc r12
		mov rax , SYS_WRITE
		mov rdi, STDOUT
		mov rsi ,buf2
		mov rdx , r12
		syscall
		xor rdi,rdi
		mov rax, SYS_EXIT
		syscall
