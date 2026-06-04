global f
f:
	mov eax, edi
	cmp eax , 0
	jge .init
	neg eax
	.init:
		mov r8d,10
	.loop:
		cmp eax,0
		je .done
		xor edx,edx
		mov ecx , 10
		div ecx
		cmp r8d,edx
		jle .next_iteration
		mov r8d,edx
		.next_iteration:
			jmp .loop
	.done:
		mov eax,r8d
		ret
