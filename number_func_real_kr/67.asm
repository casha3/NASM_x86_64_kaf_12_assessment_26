section .text
	global f
f:
	mov r8d, edi
	mov eax , edi
	cmp r8d , 0
	jge .init
	neg eax
	.init:
		mov r10d,1
		xor r9d,r9d
		mov ebx,11
	.loop:
		cmp eax,0
		je .restore_sign
		mov ecx , 10
		xor edx,edx
		div ecx
		cmp edx,ebx
		mov ebx,edx
		je .loop
		.plus_ans:
			imul edx,r10d
			add r9d,edx
			imul r10d,10
		jmp .loop				
	.restore_sign:
		mov eax,r9d
		cmp r8d,0
		jge .done
			neg eax
	.done:
		ret	
