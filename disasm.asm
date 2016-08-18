; Personal Project
; A Nintendo Gameboy Emulator
;
; =========================================================================
; Disassembler for Gameboy (LR35902) ROMs
; =========================================================================
; Starting in: 9/18/16
; More description to be added here 
;

format PE console
entry start

include 'win32a.inc'

; =========================================================================
section '.data' data readable writable
	wow	db 'a'

; =========================================================================
section '.bss'  readable writable
	wow1	db ?

; =========================================================================
section '.text' code readable executable

start:
	call	print_intro				; print an intro to the disassembler
	
	; Exit the process:
	push	0
	call 	[ExitProcess]

; =========================================================================
; void print_intro (void)
; parameters=>
; void
; returns=>
; void=>
; operation=>
; Prints an intro to the disassembler
print_intro:
	pushad						; backup all registers

	jmp     .skip_data				; skip over the string
	.intro	db 'Welcome to the LR35902 Disassembler!', 13, 10, 0
.skip_data:
	push	.intro
	call	[printf]				; print the string
	add 	esp, 4

	popad						; restore all registers					
	ret

; ===========================================================================
section '.idata' import data readable

library	kernel, 'kernel32.dll',\
	msvcrt, 'msvcrt.dll'

import	kernel, \
	ExitProcess, 'ExitProcess', \
	GetStdHandle, 'GetStdHandle', \
	ReadFile, 'ReadFile'

import	msvcrt, \
	printf, 'printf'
