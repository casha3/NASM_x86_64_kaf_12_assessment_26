global f_sum_digits
f_sum_digits
	mov eax ,edi    
	mov r8d,edi
	cmp eax,0
	jge .sum_init
		neg r8d
	.sum_init:
        	xor r9d,r9d
		cmp eax , 0
		jne sum_loop
		ret
	.sum_loop: 
		cmp eax,0
		je .restore_sign
		mov eax,ecx ; mladshie razryady delimogo
		xor edx,edx ; starshie razryday delimogo
		mov ecx,10
		div ecx
		mov ecx,eax ; chastnoe
		add r8d,edx ;remainder
		jmp sum_loop
	.restore_sign:
		mov eax, r9d
		cmp r8d,0
		jge .done
		neg eax
	.done:
		ret
