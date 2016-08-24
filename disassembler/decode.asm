; =======================================================================================================
; void decode (char* buffer, int* pc)
; parameters=>
; buffer: buffer containing machine code
; pc: pointer to program counter. the index in the buffer from which to decode
; returns=>
; void
; operation=>
; decodes an opcode (pointed by pc in buffer) and prints it. 
; advances pc after decoding.
; 
decode:
	.buffer = 8h
	.pc		= 0ch
	.param1 = -4h
	.param2 = -8h
	push	ebp
	mov		ebp, esp
	pushad
	sub		esp, 4*2
	mov		dword[ebp+.param1], 0	; to hold operands (in case they exist)
	mov		dword[ebp+.param2], 0
	
	mov		ebx, dword[ebp+.buffer]
	mov		esi, dword[ebp+.pc]
	mov		esi, dword[esi]
	mov		al, byte[ebx+esi]
	mov		ah, byte[ebx+esi+2]
	cmp		al, 0xcb				; check if the byte is prefix cb
	jne		.not_cb
	mov		al, byte[ebx+esi+1]
	jmp		.cb_ops
.not_cb:	
	mov		byte[ebp+.param2], ah
	mov		ah, byte[ebx+esi+1]
	mov		byte[ebp+.param1], ah
	
	; contains instructions to decode the corresponding opcodes
	include 'decode_op.asm'

	push	newline
	call	[printf]
	add		esp, 4
	
	add		esp, 4*2
	popad
	pop		ebp
	ret

	; contains strings for the corresponding opcodes
	include 'decode_str.asm'
