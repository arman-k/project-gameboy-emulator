; Personal Project
; A Nintendo Gameboy Emulator
;
; =======================================================================================================
; Disassembler for Gameboy (LR35902) ROMs
; =======================================================================================================
; Starting in: 18/9/16
; More description to be added here 
;

format PE console
entry start

include 'win32a.inc'						; contains common structs and constants for WINAPI
include 'encoding/utf8.inc'					; contains support for UTF-8
include 'disasm_h.inc'						; contains some constants from WINAPI not present in win32a

; =======================================================================================================
; Some constants
;
size_KB = 1024						
size_MB = size_KB * size_KB					; stands for 1 MB

; =======================================================================================================
section '.data' data readable writable
	;printf_s	du "%s",13,10,0				; unicode format string for a string
	newline		db 13, 10, 0				; newline string
	printf_s	db "%s", 0					; format string for a string
	printf_d	db "%d", 13, 10, 0			; format string for a decimal number
	
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
	sub	esp, 4*7							; keep space for local variables

	call	print_intro						; print an intro to the disassembler

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
	;mov	ebx, dword[eax+8]				; save the address of the second argument
	;mov	dword[ebp+.outFilename], ebx		

	; print the unicode filename
	;push    ebx
	;push	printf_s
	;call	[wprintf]
	;add	esp, 8
	;jmp	.exit

	; Gameboy ROMS are usually 1024 KB in size. 
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
	
	;push	dword[ebp+.bytesRead]
	;push	printf_d
	;call	[printf]						; print the number of bytes read
	;add	esp, 4*2


	; Write the rom from memory to file
	;push	dword[ebp+.outFilename]
	;push	dword[ebp+.bytesRead]
	;push	dword[ebp+.mallocRom]
	;call	write_rom
	;add	esp, 4*3
	;cmp	eax, 0							; exit if file couldn't be written (error is already raised in write_rom)
	;je	.io_rom_fail
	;mov	dword[ebp+.bytesWritten], eax

	;push	dword[ebp+.bytesWritten]
	;push	printf_d
	;call	[printf]						; print the number of bytes written
	;add	esp, 4*2

.io_rom_fail:
	push	dword[ebp+.mallocRom]
	call	[free]							; free the allocated memory
	add		esp, 4
	jmp		.exit

.commandLinetoArgvW_fail:
	jmp		.skip_commandLinetoArgvW_fail_data
	.commandLinetoArgvW_fail_data	db 'Please provide a filename as an argument like this:', 13, 10
									db '>disasm.exe inxxxRom.gb', 13, 10, 0
.skip_commandLinetoArgvW_fail_data:
	push	.commandLinetoArgvW_fail_data
	call	[printf]						; here if no argument was provided
	add		esp, 4
	jmp		.exit

.malloc_fail:
	jmp		.skip_malloc_fail_data
	.malloc_fail_data	db 'Failed to allocate space for loading ROM.', 13, 10, 0
.skip_malloc_fail_data:
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

; =======================================================================================================
; void print_intro (void)
; parameters=>
; void
; returns=>
; void
; operation=>
; Prints an intro of the disassembler to the console
;
print_intro:
	pushad									; backup all registers

	jmp     .skip_data						; skip over the string
	.print_intro_data	db 'Welcome to the LR35902 Disassembler!', 13, 10, 0
.skip_data:
	push	.print_intro_data
	call	[printf]						; print the intro
	add 	esp, 4

	popad									; restore all registers					
	ret
	
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
	jmp		.skip_unknown_error_data		
	.unknown_error_data		db 'Reading file - unknown error', 13, 10, 0
.skip_unknown_error_data:
	push	.unknown_error_data
	call	[printf]						; here if the error is unknown
	add		esp, 4
	mov		eax, 0							; return null
	jmp		.exit

.file_not_found:
	jmp		.skip_file_not_found_data
	.file_not_found_data	db 'The system cannot find the file specified.', 13, 10, 0
.skip_file_not_found_data:
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

	.printf_x		db "0x%04x: ", 0
	.disasm_start	db 13,10,13,10,"Disassembly start: ",13,10,0

	; contains decode subroutine
	include 'decode.asm'
	; contains print_info and related subroutines 
	include	'rom_info.asm'

; =======================================================================================================
; int write_rom (char* buffer, int size, char* filename)
; parameters=>
; buffer: buffer containing the ROM to write
; size: maximum number of bytes to write
; filename: name of the new file (ROM)
; returns=>
; number of bytes actually written
; operation=>
; Writes the rom from memory to a file of given maximum size
; additional comments=>
; this subroutine is not really needed anymore. it was written as a test for read_rom
;
write_rom:
	.buffer = 8h					
	.size = 0ch
	.filename_addr = 10h
	.lpNumberOfBytesWritten = -4h			; number of bytes actually written
	.fileHandle = -8h						; a handle to the created file (the new ROM)
	push	ebp
	mov 	ebp, esp				
	sub		esp, 4*2

	push	ebx ecx edx esi edi			

	; call CreateFileW to open a handle to a new ROM file
	push	0
	push	FILE_ATTRIBUTE_NORMAL
	push	CREATE_NEW
	push	0
	push 	FILE_SHARE_READ
	push	GENERIC_WRITE
	push	dword[ebp+.filename_addr]
	call	[CreateFileW]
	cmp		eax, INVALID_HANDLE_VALUE
	je		.error							; raise error if the handle is invalid
	mov		dword[ebp+.fileHandle], eax

	; call WriteFile to write from memory to ROM handle
	push	0
	lea		ebx, [ebp+.lpNumberOfBytesWritten]
	push	ebx 
	push	dword[ebp+.size]
	push	dword[ebp+.buffer]
	push	dword[ebp+.fileHandle]
	call	[WriteFile]
	cmp		eax, 0
	je		.error							; raise error if null is returned

	; call CloseHandle to close the handle to the new ROM file (to release resources)
	push	dword[ebp+.fileHandle]
	call	[CloseHandle]
	
	mov		eax, dword[ebp+.lpNumberOfBytesWritten]	; return number of bytes written
	jmp		.exit

.error:
	; call GetLastError to check what the last error was
	call	[GetLastError]
	cmp		eax, ERROR_FILE_EXISTS
	je		.file_exists			
	jmp		.skip_unknown_error_data		
	.unknown_error_data		db 'Writing file - unknown error', 13, 10, 0
.skip_unknown_error_data:
	push	.unknown_error_data
	call	[printf]						; here if the error is unknown
	add		esp, 4
	mov		eax, 0							; return null
	jmp		.exit

.file_exists:
	jmp		.skip_file_exists_data
	.file_exists_data	db 'The file to be written already exists.', 13, 10, 0
.skip_file_exists_data:
	push	.file_exists_data
	call	[printf]						; here if the file already exists
	add		esp, 4
	mov 	eax, 0
	jmp		.exit

.exit:
	pop	edi esi edx ecx ebx			

	add		esp, 4*2
	pop		ebp					
	ret
	
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
	wprintf, 'wprintf', \
	malloc, 'malloc', \
	free, 'free'
