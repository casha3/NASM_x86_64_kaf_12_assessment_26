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
	mov rsi , buf1
	mov rdx , 81 
	syscall
	dec rax
	; rax = len = amount of readen bytes = sys_read()
	mov rbx , rax
	; --------
	; two pointers algorithm ( r12 <= rcx ) 
	xor rcx ,rcx
	xor r12 , r12
	; ---------
	xor r9 , r9 ; r9 - pointer on new buf2
	.loop:
		cmp rcx,rbx
		jge .keep_done
		cmp byte[buf1+rcx] , ` `
		je .OK
		cmp byte[buf1+rcx], `\t`
		jne .forwarding_rcx
		.OK:
			mov dl , byte[buf1+rcx]
			mov byte[buf2+r9] , dl
			inc r9
			inc rcx
			inc r12
		.forwarding_rcx:
			cmp rcx,rbx
			jge .pivot
			mov dl , byte[buf1+rcx]
			cmp dl , ` `
			je .pivot
			cmp dl , `\t`
			je .pivot
			inc rcx
			jmp .forwarding_rcx
		.pivot:
			mov rdx , rcx
			xor rdx , r12
			test rdx,1
			jz .bad_forwarding_r12
			.good_forwarding_r12:
				; mozhno zamenit instructions like movsb
				cmp r12,rcx
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
		mov rax , SYS_WRITE 
		mov rdi , STDOUT 
		mov rsi , buf2   
		mov rdx , r12
		syscall
		mov rax , SYS_EXIT
		xor rdi , rdi
		syscall
