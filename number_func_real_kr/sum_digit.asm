global f
f:
	mov eax ,edi
	cmp eax,0
	jge .init
		neg eax
	.init:
		mov ecx,eax
		xor r8d,r8d	
		cmp eax , 0
		je .done
	.loop: 
		cmp eax,0
		je .restore_eax
		mov eax,ecx ; mladshie razryady delimogo
		xor edx,edx ; starshie razryday delimogo
		mov ecx,10
		div ecx
		mov ecx,eax ; chastnoe
		add r8d,edx ;remainder
		jmp .loop
	.restore_eax:
		mov eax, r8d
	.done:
		ret
