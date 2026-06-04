global f
f:
	; foo ( int_32 num ) 
	; r8d = num
 	; r9d = ans
	; r10d = decimal_exponenta
	mov r8d , edi ; r8d = num
	mov eax , edi
	cmp eax , 0
	jge .init
	neg eax
	; r8d = abs(num)
	.init:
		xor r9d,r9d ; ans = 0
		mov r10d,1 ; exponenta = 1 = 1**0
	.loop:
		cmp eax ,0 
		je .restore_sign
		xor edx,edx ; starshie razrydady delimogo
		mov ecx,10
		div ecx
		; edx - remainder
		add edx, 3 
		cmp edx,10
		jl .no_overflow
		sub edx, 10
		.no_overflow:
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
		;returns eax
		ret
