bits 64
%define STDIN 0
%define STDOUT 1
%define SYS_EXIT 60
%define SYS_READ 0
%define SYS_WRITE 1
global _start
section .bss
	buf1 resb 82
	buf2 resb 82
section .text
_start:
	mov rax , SYS_READ
	mov rdi , STDIN
	mov rsi , buf1
	mov rdx , 81
	syscall
	mov rbx , rax
	xor rcx,rcx
	xor r12,r12
	.first_symbol:
		cmp rcx,rbx
		jge .wasted
		mov dl , byte[buf1+rcx]
		cmp dl , '\t'
		je .next_iteration_first_symbol
		cmp dl , ' '
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
		cmp dl , '\t'
		je .loop_delim_entrance
		cmp dl , ' '
		je .loop_delim_entrance
		inc rcx
		inc r12
		jmp .loop_letter
	.loop_delim_entrance:
		mov byte[buf2+r12],'a'
		inc r12
		mov byte[buf2+r12],'b'
		inc r12
		mov byte[buf2+r12],'c'
		inc r12
		.loop_delim
			cmp rcx,rbx
			jge .wasted
			mov dl , byte[buf1+rcx]
			cmp dl , '\t'
			je .next_iteration_loop_delim
			cmp dl , ' '
			jne .loop_letter
			.next_iteration_loop_delim:
				mov byte[buf2+r12] , dl
				inc rcx
				inc r12
				jmp .loop_delim
	.success:
		mov byte[buf2+r12],'a'
		inc r12
		mov byte[buf2+r12],'b'
		inc r12
		mov byte[buf2+r12],'c'
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
