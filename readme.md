; ОФОРМИ ВЕСЬ ФАЙЛ ПОД MARDOWN
СНИППЕТЫ АССЕМБЛЕРНОГО КОДА ЧТОБЫ Я МОГ НАПИСАТЬ ПРОГРАММУ ДЛЯ РАБОТЫ СО СТРОКАМИ 

НАЧАЛО АССЕМБЛЕРНОГО КОДА  ( У МЕНЯ В КОДЕ ОШИБКИ С ПРЕДСТАВЛЕНИЕМ СИМВОЛО)
bits 64
%define EXIT 60
%define STDIN 0
%define STDOUT 1
%define SYS_READ 0 
%define SYS_WRITE

section .bss
	buf1 resb 82
	buf2 resb 82
section .text
	global _start
_start:
	mov rax, SYS_READ
	mov rdi, STDIN
	mov rsi , buf1
	mov rdx , 81
	syscall
	mov rbx,rax
	xor rcx,rcx
	xor r12,r12
	.loop:
		cmp rbx,rcx
		je .loop_done
		mov al , byte [buf + rcx] 
		; proverka
		je .keep_skip
		; proverka
		je .keep_write

		;......

		.keep_write:
			; ....
			mov byte[buf2 + r12] , al
			inc r12
		.keep_skip:
			inc rcx
			jmp .loop		
	.loop_done:
		mov byte[buf2+r12] , 10
		inc r12
		mov rax, SYS_WRITE
		mov rdi , STDOUT 
		mov rsi , [buf2]
		mov rdx , rbx
		syscall
		mov rax , EXIT
		xor rdi,rdi
		syscall
КОНЕЦ АССЕМБЛЕРНОГО 
Дальше TLDR в 
