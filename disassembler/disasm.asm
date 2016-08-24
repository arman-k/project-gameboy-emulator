; Personal Project
; A Nintendo Gameboy Emulator
;
; =======================================================================================================
; Crude Sequential Disassembler for Gameboy (LR35902) ROMs
; =======================================================================================================
; Started in: 19/9/16
; 
; Description:
; This is a disassembler for Gameboy (LR35902 CPU) ROMs.
; It is of course a very crude one (and is intentionally so), in the sense that it sequentially interprets all the bytes in the rom as instructions. This is of course wrong but can still be made useful with manual inspection. 
; Creating a more complex disassembler would be an overkill and a distraction from the main project (it is not actually necessary) - the Gameboy Emulator itself.
; I still felt like it would be a nice thing to have. It also helped me verify that the ROM indeed is made for the Gameboy.
; Moreover, I wanted this to be a sort of warmup with FASM assembly. Also, instead of manually writing or copy-pasting boring repetitive code, I instead wrote a code generator in C (as a warmup for C programming - yes I have been detached from it for over a year) that emits the repetitive assembly code.
; Furthermore, I had to create a sort of opcode db for the disassembler (the code generator needs the properties of each opcode to generate code). I can reuse this db for further code generation while writing the emulator. 
; Finally, I had to read parts of the GBCPU manual for this job. This is hopefully going to help me writing the actual emulator as well.
; 
; Note:
; Please pipe the output produced to a file: disasm.exe rom.gb > dump.txt
; For some reason, the piped output has double newlines in place of single newlines. The produced file is therefore quite sparse.
; If this bugs you, you can try removing 0x13 from the newline string in the data section. It stops emitting double newlines.
;

format PE console
entry start

include 'win32a.inc'						; contains common structs and constants for WINAPI
include 'disasm_h.inc'						; contains some constants from WINAPI not present in win32a

; =======================================================================================================
; Some constants
;
size_KB = 1024						
size_MB = size_KB * size_KB					; stands for 1 MB

; =======================================================================================================
section '.data' data readable writable
	newline		db 13, 10, 0				; newline string
	
; =======================================================================================================
;section '.bss'  readable writable
;	wow1	db ?

; =======================================================================================================
section '.text' code readable executable

; =======================================================================================================
; start
; command-line arguments=>
; filename of the rom
; operation=>
; reads the file specified into memory
;

start:
	.pNumArgs = -4h							; number of arguments from command line
	.szArglist = -8h						; address of the list of addresses to arguments
	.mallocRom = -0ch						; address of the dynamically allocated memory to store ROM data
	.inFilename = -10h						; address of the name of the input file
	.bytesRead = -14h						; number of bytes actually read from the file
	.outFilename = -18h						; address of the name of the output file
	.bytesWritten = -1ch					; number of bytes actually written to the new file
	sub		esp, 4*7						; keep space for local variables

	push	.print_intro_data
	call	[printf]						; print an intro to the disassembler
	add		esp, 4				

	call	[GetCommandLineW]				; fetch the command line string
	; call CommandLineToArgvW to transform the command line string into an array of arguments
	lea     ebx, [ebp+.pNumArgs]
	push	ebx					
	push	eax
	call	[CommandLineToArgvW]
	mov 	dword[ebp+.szArglist], eax
	cmp		dword[ebp+.pNumArgs], 1
	jle		.commandLinetoArgvW_fail		; raise error if there are less than 2 arguments
	
	mov		ebx, dword[eax+4]				; save the address of the first argument
	mov		dword[ebp+.inFilename], ebx		
	
	; Gameboy ROMS are usually upto 1024 KB in size (very rarely are they more than this). If it's more than this, adjust the size parameter accordingly. 
	; An extra byte is being allocated for the terminating null byte.
	push	size_MB+1				
	call	[malloc]
	add		sp, 4							; _cdecl style
	cmp		eax, 0
	je		.malloc_fail					; raise error if null was returned
	mov		dword[ebp+.mallocRom], eax

	; Read the rom from file to memory
	push	dword[ebp+.inFilename]
	push	size_MB
	push	dword[ebp+.mallocRom]
	call	read_rom
	add		esp, 4*3
	cmp		eax, 0							; exit if file couldn't be read (error is already raised in read_rom)
	je		.io_rom_fail
	mov		dword[ebp+.bytesRead], eax
	
	push	size_MB
	push	dword[ebp+.mallocRom]
	call	disassemble
	add		esp, 4*2
	
.io_rom_fail:
	push	dword[ebp+.mallocRom]
	call	[free]							; free the allocated memory
	add		esp, 4
	jmp		.exit

.commandLinetoArgvW_fail:
	push	.commandLinetoArgvW_fail_data
	call	[printf]						; here if no argument was provided
	add		esp, 4
	jmp		.exit

.malloc_fail:
	push	.malloc_fail_data
	call	[printf]						; here if malloc failed
	add		esp, 4
	jmp		.exit

.exit:
	push	dword[ebp+.szArglist]		
	call	[LocalFree]						; free memory used by CommandLineToArgvW		

	add		esp, 4*7
	
	push	0
	call 	[ExitProcess]					; Exit the process

	.print_intro_data				db 'Welcome to the LR35902 Disassembler!', 13, 10, 0
	.commandLinetoArgvW_fail_data	db 'Please provide a rom as an argument like this:', 13, 10
									db '>disasm.exe [filename.gb]', 13, 10, 0
	.malloc_fail_data				db 'Failed to allocate space for loading ROM.', 13, 10, 0

; =======================================================================================================
; int read_rom (char* buffer, int size, char* filename)
; parameters=>
; buffer: buffer to load the rom into
; size: maximum number of bytes to read
; filename: name of the rom
; returns=>
; number of bytes actually read
; operation=>
; Reads the rom from file to a buffer of given maximum size
;
read_rom:
	.buffer = 8h					
	.size = 0ch
	.filename_addr = 10h
	.lpNumberOfBytesRead = -4h				; number of bytes actually read
	.fileHandle = -8h						; a handle to the opened file (the ROM)
	push	ebp
	mov 	ebp, esp						; create stack frame
	sub		esp, 4*2

	push	ebx ecx edx esi edi				; keep backup of registers

	; call CreateFileW to open a handle to the ROM file
	push	0
	push	FILE_ATTRIBUTE_NORMAL
	push	OPEN_EXISTING
	push	0
	push 	FILE_SHARE_READ
	push	GENERIC_READ
	push	dword[ebp+.filename_addr]
	call	[CreateFileW]
	cmp		eax, INVALID_HANDLE_VALUE
	je		.error							; raise error if the handle is invalid
	mov		dword[ebp+.fileHandle], eax

	; call ReadFile to read the ROM handle to memory
	push	0
	lea		ebx, [ebp+.lpNumberOfBytesRead]
	push	ebx 
	push	dword[ebp+.size]
	push	dword[ebp+.buffer]
	push	dword[ebp+.fileHandle]
	call	[ReadFile]
	cmp		eax, 0
	je		.error							; raise error if null is returned

	; call CloseHandle to close the handle to the ROM file (to release resources)
	push	dword[ebp+.fileHandle]
	call	[CloseHandle]
	
	mov		eax, dword[ebp+.lpNumberOfBytesRead]	; return number of bytes read
	jmp		.exit

.error:
	; call GetLastError to check what the last error was
	call	[GetLastError]
	cmp		eax, ERROR_FILE_NOT_FOUND
	je		.file_not_found	
	push	.unknown_error_data
	call	[printf]						; here if the error is unknown
	add		esp, 4
	mov		eax, 0							; return null
	jmp		.exit

.file_not_found:
	push	.file_not_found_data
	call	[printf]						; here if the file was not found
	add		esp, 4
	mov 	eax, 0
	jmp		.exit

.exit:
	pop	edi esi edx ecx ebx					; restore backed up registers

	add		esp, 4*2
	pop		ebp								; destroy stack frame
	ret

	.file_not_found_data		db 'The system cannot find the file specified.', 13, 10, 0
	.unknown_error_data			db 'Reading file - unknown error', 13, 10, 0
; =======================================================================================================
; void disassemble(char* buffer, int szrom)
; parameters=>
; buffer: buffer containing the rom file
; szrom: size of the rom in bytes
; returns=>
; void
; operation=>
; decodes stream of bytes in buffer and prints their corresponding assembly code 
;
disassemble:
	.buffer = 8h
	.szrom 	= 0ch
	.pc		= -4h
	push	ebp
	mov		ebp, esp
	pushad
	mov		dword[ebp+.pc], 0
	
	; Perform checksum operations and dump general information about the rom
	push	dword[ebp+.buffer]
	call	print_info
	add		esp, 4
	
	push	.disasm_start
	call	[printf]
	add		esp, 4
	
	; Fetch the execution point from the jump address at 0x0102h
	mov		ebx, dword[ebp+.buffer]
	add		ebx, 100h
	inc		ebx
	cmp		byte[ebx], 0c3h
	jne		.exit
	inc		ebx
	xor		ecx, ecx
	mov		cx, word[ebx]
	mov		dword[ebp+.pc], ecx				; update program counter with this execution point
	
	; Currently I just overwrote dword[ebp+.pc] with 0. So the code that just ran above has no effect.
	;mov		dword[ebp+.pc], 0				
	; Start disassembling from the execution point
.next_op:
	push	dword[ebp+.pc]
	push	.printf_x
	call	[printf]						; print current address
	add		esp, 4*2
	lea		ebx, [ebp+.pc]
	push	ebx
	push	dword[ebp+.buffer]
	call	decode							; decode the opcode at current address
	add		esp, 4*2
	mov		eax, dword[ebp+.szrom]
	cmp		dword[ebp+.pc], eax
	jl		.next_op

.exit:
	popad
	pop		ebp
	ret

	.printf_x		db "0x%04x: ", 0		; format string for printing hex addresses
	.disasm_start	db 13,10,13,10,"(Please note that this is a very crude disassembly."
					db 13,10,"It simply disassembles every byte sequentially, "
					db 13,10,"and has thus interpreted all the data as instructions as well."
					db 13,10,"If you notice a non-sensical sequence of instructions like this: "
					db 13,10,"0x0165: 0xf0   LDH    A, (0x00)"
					db 13,10,"0x0167: 0xf0   LDH    A, (0x00)"
					db 13,10,"0x0169: 0xf0   LDH    A, (0x00)"
					db 13,10,"the bytes around it are probably meant to be data, not instructions."
					db 13,10,"If you notice invalid instructions, the bytes around it are definitely meant to be data."
					db 13,10,"The actual execution point starts at 0x150.)"
					db 13,10,"Disassembly start: ",13,10,0

	; contains decode subroutine
	include 'decode.asm'
	; contains print_info and related subroutines 
	include	'rom_info.asm'
	
; =======================================================================================================
section '.idata' import data readable

library	kernel, 'kernel32.dll', \
	shell, 'shell32.dll', \
	msvcrt, 'msvcrt.dll'

import	kernel, \
	ExitProcess, 'ExitProcess', \
	CreateFileW, 'CreateFileW', \
	CloseHandle, 'CloseHandle', \
	ReadFile, 'ReadFile', \
	WriteFile, 'WriteFile', \
	GetCommandLineW, 'GetCommandLineW', \
	LocalFree, 'LocalFree', \
	GetLastError, 'GetLastError'

import  shell, \
	CommandLineToArgvW, 'CommandLineToArgvW'

; _cdecl libraries
; must balance the stack after calling these subroutines
import	msvcrt, \
	printf, 'printf', \
	malloc, 'malloc', \
	free, 'free'
