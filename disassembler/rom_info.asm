; =======================================================================================================
; void print_info(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; void
; operation=>
; Prints various information about the ROM
;
print_info:
	.buffer	= 8h
	push	ebp
	mov		ebp, esp
	pushad
	
	push	.loaded
	call	[printf]
	add		esp, 4
	
	; Verify presence of Nintendo graphic
	push	dword[ebp+.buffer]
	call	check_nintendo_graphic
	add		esp, 4
	
	; Verify checksum
	push	dword[ebp+.buffer]
	call	verify_checksum
	add		esp, 4
	
	push	newline
	call	[printf]
	add		esp, 4
	
	; Print the title of the game
	mov		eax, dword[ebp+.buffer]
	add		eax, 134h
	push	eax
	push	.title
	call	[printf]
	add		esp, 4*2
	
	; Print whether the rom is for GB or GBC
	push	.color_gb
	call	[printf]
	add		esp, 4
	mov		eax, dword[ebp+.buffer]
	add		eax, 143
	cmp		byte[eax], 80h
	je		.color
	push	.col_no
	jmp		@f
.color:
	push	.col_yes
@@:
	call	[printf]
	add		esp, 4

	; Print the license code of the ROM
	xor		ebx, ebx
	mov		eax, dword[ebp+.buffer]
	add		eax, 145h
	mov		bl, byte[eax]
	push	ebx
	mov		eax, dword[ebp+.buffer]
	add		eax, 144h
	mov		bl, byte[eax]
	push	ebx
	push	.license
	call	[printf]
	add		esp, 4*3
	
	; Print GB/SGB indicator
	push	.gb_sgb
	call	[printf]
	add		esp, 4
	mov		eax, dword[ebp+.buffer]
	add		eax, 146h
	cmp		byte[eax], 00h
	je		.gameboy
	push	.sgb
	jmp		@f
.gameboy:
	push	.gb
@@:
	call	[printf]
	add		esp, 4
	
	; Print cartridge type
	push	dword[ebp+.buffer]
	call	print_cart_type
	add		esp, 4
	
	; Print ROM size
	push	dword[ebp+.buffer]
	call	print_ROM_size
	add		esp, 4
	
	; Print RAM size
	push	dword[ebp+.buffer]
	call	print_RAM_size
	add		esp, 4

	; Print destination code
	push	.dest_code
	call	[printf]
	add		esp, 4
	xor		ebx, ebx
	mov		eax, dword[ebp+.buffer]
	add		eax, 14Ah
	mov		bl, byte[eax]
	cmp		bl, 0
	jne		.non_japanese
	push	.jap
	jmp		@f
.non_japanese:
	push	.nojap
@@:
	call	[printf]
	add		esp, 4
	
	; Print Licensee code (old)
	push	dword[ebp+.buffer]
	call	print_licensee_code
	add		esp, 4
	
	; Print Mask ROM Version number
	push	.mask_v
	call	[printf]
	add		esp, 4
	xor		ebx, ebx
	mov		eax, dword[ebp+.buffer]
	add		eax, 14Ch
	mov		bl, byte[eax]
	push	ebx
	push	.printf_d
	call	[printf]
	add		esp, 4*2
	
	popad
	pop		ebp
	ret

	.printf_d	db "%d", 13, 10, 0			; format string for a decimal number
	.loaded		db "Cartridge has been successfully loaded!", 13, 10, 0
	.title		db "Title of the game: %s", 13, 10, 0
	.color_gb	db "Color GB: ", 0
	.col_yes	db "Yes", 13, 10, 0 
	.col_no		db "No", 13, 10, 0
	.license	db "License code: %c%c", 13, 10, 0
	.gb_sgb		db "GB/SGB indicator: ", 0
	.gb			db "Gameboy", 13, 10, 0
	.sgb		db "Super Gameboy", 13, 10, 0
	.dest_code	db "Destination code: ", 0
	.jap		db "Japanese", 13, 10, 0
	.nojap		db "Non-Japanese", 13, 10, 0
	.mask_v		db "Mask ROM Version number: ",  0
; =======================================================================================================
; void print_cart_type(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; void
; operation=>
; Prints the cartridge type of the ROM
;	
print_cart_type:
	.buffer	= 8h
	push	ebp
	mov		ebp, esp
	pushad
	
	push	.cart_type
	call	[printf]
	add		esp, 4
	
	mov		eax, dword[ebp+.buffer]
	add		eax, 147h
	xor		ebx, ebx
	mov		bl, byte[eax]
	
	cmp		bl, 00h
	jne		@f
	push	.c00
	jmp		.exit
@@:	
	cmp		bl, 01h
	jne		@f
	push	.c01
	jmp		.exit
@@:	
	cmp		bl, 02h
	jne		@f
	push	.c02
	jmp		.exit
@@:	
	cmp		bl, 03h
	jne		@f
	push	.c03
	jmp		.exit
@@:	
	cmp		bl, 05h
	jne		@f
	push	.c05
	jmp		.exit
@@:	
	cmp		bl, 06h
	jne		@f
	push	.c06
	jmp		.exit
@@:	
	cmp		bl, 08h
	jne		@f
	push	.c08
	jmp		.exit
@@:	
	cmp		bl, 0bh
	jne		@f
	push	.c0b
	jmp		.exit
@@:	
	cmp		bl, 0ch
	jne		@f
	push	.c0c
	jmp		.exit
@@:	
	cmp		bl, 0dh
	jne		@f
	push	.c0d
	jmp		.exit
@@:	
	cmp		bl, 0fh
	jne		@f
	push	.c0f
	jmp		.exit
@@:	
	cmp		bl, 10h
	jne		@f
	push	.c10
	jmp		.exit
@@:	
	cmp		bl, 11h
	jne		@f
	push	.c11
	jmp		.exit
@@:	
	cmp		bl, 12h
	jne		@f
	push	.c12
	jmp		.exit
@@:	
	cmp		bl, 13h
	jne		@f
	push	.c13
	jmp		.exit
@@:	
	cmp		bl, 19h
	jne		@f
	push	.c19
	jmp		.exit
@@:	
	cmp		bl, 1ah
	jne		@f
	push	.c1a
	jmp		.exit
@@:	
	cmp		bl, 1bh
	jne		@f
	push	.c1b
	jmp		.exit
@@:	
	cmp		bl, 1ch
	jne		@f
	push	.c1c
	jmp		.exit
@@:	
	cmp		bl, 1dh
	jne		@f
	push	.c1d
	jmp		.exit
@@:	
	cmp		bl, 0h
	jne		@f
	push	.c1e
	jmp		.exit
@@:	
	cmp		bl, 0h
	jne		@f
	push	.c1f
	jmp		.exit
@@:	
	cmp		bl, 0fdh
	jne		@f
	push	.cfd
	jmp		.exit
@@:	
	cmp		bl, 0feh
	jne		@f
	push	.cfe
	jmp		.exit
@@:	
	cmp		bl, 0ffh
	jne		@f
	push	.cff
	jmp		.exit
@@:	
	push	.cno
.exit:
	call	[printf]
	add		esp, 4
	push	newline
	call	[printf]
	add		esp, 4

	popad
	pop		ebp
	ret
	
	.cart_type	db "Cartridge type: ", 0
	; Cartridge types
	.c00	db "ROM ONLY",0
	.c01	db "ROM+MBC1",0
	.c02	db "ROM+MBC1+RAM",0
	.c03	db "ROM+MBC1+RAM+BATTERY",0
	.c05	db "ROM+MBC2",0
	.c06	db "ROM+MBC2+BATTERY",0
	.c08	db "ROM+RAM",0
	.c09	db "ROM+RAM+BATTERY",0
	.c0b	db "ROM+MMMO1",0
	.c0c	db "ROM+MMMO1+SRAM",0
	.c0d	db "ROM+MMMO1+SRAM+BATTERY",0
	.c0f	db "ROM+MBC3+TIMER+BATTERY",0
	.c10	db "ROM+MBC3+TIMER+RAM+BATTERY",0
	.c11	db "ROM+MBC3",0
	.c12	db "ROM+MBC3+RAM",0
	.c13	db "ROM+MBC3+RAM+BATTERY",0
	.c19	db "ROM+MBC5",0
	.c1a	db "ROM+MBC5+RAM",0
	.c1b	db "ROM+MBC5+RAM+BATTERY",0
	.c1c	db "ROM+MBC5+RUMBLE",0
	.c1d	db "ROM+MBC5+RUMBLE+SRAM",0
	.c1e	db "ROM+MBC5+RUMBLE+SRAM+BATTERY",0
	.c1f	db "Pocket Camera",0
	.cfd	db "Bandai TAMA5",0
	.cfe	db "Hudson HuC-3",0
	.cff	db "Hudson HuC-1",0
	.cno	db "Cartridge type not recognized",0
	
; =======================================================================================================
; void print_ROM_size(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; void
; operation=>
; Prints the ROM size of the ROM
;	
print_ROM_size:
	.buffer	= 8h
	push	ebp
	mov		ebp, esp
	pushad

	push	.rom_size
	call	[printf]
	add		esp, 4
	
	mov		eax, dword[ebp+.buffer]
	add		eax, 148h
	xor		ebx, ebx
	mov		bl, byte[eax]
	
	cmp		bl, 00h
	jne		@f
	push	.d00
	jmp		.exit
@@:
	cmp		bl, 01h
	jne		@f
	push	.d01
	jmp		.exit
@@:
	cmp		bl, 02h
	jne		@f
	push	.d02
	jmp		.exit
@@:
	cmp		bl, 03h
	jne		@f
	push	.d03
	jmp		.exit
@@:
	cmp		bl, 04h
	jne		@f
	push	.d04
	jmp		.exit
@@:
	cmp		bl, 05h
	jne		@f
	push	.d05
	jmp		.exit
@@:
	cmp		bl, 06h
	jne		@f
	push	.d06
	jmp		.exit
@@:
	cmp		bl, 52h
	jne		@f
	push	.d52
	jmp		.exit
@@:
	cmp		bl, 53h
	jne		@f
	push	.d53
	jmp		.exit
@@:
	cmp		bl, 54h
	jne		@f
	push	.d54
	jmp		.exit
@@:
	push	.dno
@@:
.exit:
	call	[printf]
	add		esp, 4
	
	push	newline
	call	[printf]
	add		esp, 4
	
	popad
	pop		ebp
	ret
	
	.rom_size db "ROM size: ", 0
	; ROM sizes
	.d00	db "256Kbit =  32KByte =   2 banks",0
	.d01	db "512Kbit =  64KByte =   4 banks",0
	.d02	db "  1Mbit = 128KByte =   8 banks",0
	.d03	db "  2Mbit = 256KByte =  16 banks",0
	.d04	db "  4Mbit = 512KByte =  32 banks",0
	.d05	db "  8Mbit =   1MByte =  64 banks",0
	.d06	db " 16Mbit =   2MByte = 128 banks",0
	.d52	db "  9Mbit = 1.1MByte =  72 banks",0
	.d53	db " 10Mbit = 1.2MByte =  80 banks",0
	.d54	db " 12Mbit = 1.5MByte =  96 banks",0
	.dno	db "ROM size not recognized",0
	
; =======================================================================================================
; void print_RAM_size(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; void
; operation=>
; Prints the RAM size of the ROM
;	
print_RAM_size:
	.buffer	= 8h
	push	ebp
	mov		ebp, esp
	pushad

	push	.ram_size
	call	[printf]
	add		esp, 4
	
	mov		eax, dword[ebp+.buffer]
	add		eax, 149h
	xor		ebx, ebx
	mov		bl, byte[eax]
	
	cmp		bl, 00h
	jne		@f
	push	.d00
	jmp		.exit	
@@:
	cmp		bl, 01h
	jne		@f
	push	.d01
	jmp		.exit	
@@:
	cmp		bl, 02h
	jne		@f
	push	.d02
	jmp		.exit	
@@:
	cmp		bl, 03h
	jne		@f
	push	.d03
	jmp		.exit	
@@:
	cmp		bl, 04h
	jne		@f
	push	.d04
	jmp		.exit	
@@:
	push	.dno
@@:
.exit:
	call	[printf]
	add		esp, 4
	
	push	newline
	call	[printf]
	add		esp, 4
	
	popad
	pop		ebp
	ret
	
	.ram_size	db "RAM size: ", 0
	; RAM sizes
	.d00	db "None", 0
	.d01	db " 16kBit =   2kB =  1 bank", 0
	.d02	db " 64kBit =   8kB =  1 bank", 0
	.d03	db "256kBit =  32kB =  4 banks", 0
	.d04	db "  1MBit = 128kB = 16 banks", 0
	.dno	db "RAM size not recognized",0
	
; =======================================================================================================
; void print_licensee_code(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; void
; operation=>
; Prints the licensee code (old) of the ROM
;	
print_licensee_code:
	.buffer	= 8h
	push	ebp
	mov		ebp, esp
	pushad

	push	.licensee_code
	call	[printf]
	add		esp, 4
	
	mov		eax, dword[ebp+.buffer]
	add		eax, 14Bh
	xor		ebx, ebx
	mov		bl, byte[eax]
	
	cmp		bl, 33h
	jne		@f
	push	.e33
	jmp		.exit	
@@:
	cmp		bl, 79h
	jne		@f
	push	.e79
	jmp		.exit	
@@:
	cmp		bl, 0A4h
	jne		@f
	push	.ea4
	jmp		.exit	
@@:
	push	.eno
@@:
.exit:
	call	[printf]
	add		esp, 4
	
	push	newline
	call	[printf]
	add		esp, 4
	
	popad
	pop		ebp
	ret
	
	.licensee_code	db "Licensee code (old): ", 0
	; Licensee Codes
	.e33	db "(As previous)", 0
	.e79	db "Accolade", 0
	.ea4	db "Konami", 0
	.eno	db "Licensee code not recognized", 0
	
; =======================================================================================================
; void verify_checksum(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; void
; operation=>
; Verifies the checksum of the ROM
;	
verify_checksum:
	.buffer	= 8h
	push	ebp
	mov		ebp, esp
	pushad

	push	.checksum
	call	[printf]
	add		esp, 4
	
	xor		ecx, ecx
	mov		eax, dword[ebp+.buffer]
	add		eax, 14Eh
	xor		ebx, ebx
	mov		bh, byte[eax]
	inc		eax
	mov		bl, byte[eax]
	
	push	dword[ebp+.buffer]
	call	calculate_checksum
	add		esp, 4
	
	cmp		ax, bx
	je		.checksum_success
	push	.check_fail
	jmp		@f
.checksum_success:
	push	.check_ok
@@:
	call	[printf]
	add		esp, 4
	
	popad
	pop		ebp
	ret
	
	.checksum	db "Checksum verification: ", 0
	.check_ok	db "Passed!",13,10,0
	.check_fail	db "Failed. The ROM image is corrupted.",13,10,0
	
; =======================================================================================================
; int calculate_checksum(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; the checksum value in word
; operation=>
; Calculates the checksum of the ROM (result in the LSW)
;
calculate_checksum:
	.buffer = 8h
	push	ebp
	mov		ebp, esp
	push	ebx edx esi
	
	xor		edx, edx
	xor		eax, eax	
	mov		ebx, dword[ebp+.buffer]
	xor		esi, esi
	
next_byte:
	mov		dl, byte[ebx+esi]
	; skip addresses 14eh and 14fh, because it contains the checksum value itself
	cmp		esi, 14eh
	je		@f
	cmp		esi, 14fh
	je		@f
	add		ax, dx
@@:
	inc		esi
	cmp		esi, size_MB
	jle		next_byte
	
	pop		esi edx ebx
	pop		ebp
	ret

; =======================================================================================================
; int check_nintendo_graphic(char* buffer)
; parameters=>
; buffer: buffer containing the game rom
; returns=>
; the checksum value in word
; operation=>
; Checks if the scrolling Nintendo Graphics exist
;
check_nintendo_graphic:
	.buffer = 8h
	push	ebp
	mov		ebp, esp
	push	ecx esi edi
	
	push	.check_graphic
	call	[printf]
	add		esp, 4
	
	mov		ecx, 47
	mov		esi, .graphic
	mov		edi, dword[ebp+.buffer]
	add		edi, 104h
	repe	cmpsb
	jne		.graphic_fail
	push	.success
	jmp		@f
.graphic_fail:
	push	.fail
@@:
	call	[printf]
	add		esp, 4
	
	pop		edi esi ecx
	pop		ebp
	ret
	
	.check_graphic db "Checking scrolling Nintendo Graphics: ",0
	.success	db "Passed!",13,10,0
	.fail		db "The scrolling Nintendo Graphics is corrupted",13,10,0
	.graphic	db 0CEh, 0EDh, 66h, 66h, 0CCh, 0Dh, 00h, 0Bh, 03h, 73h, 00h, 83h, 00h, 0Ch, 00h, 0Dh, 00h, 				 08h, 11h, 1Fh, 88h, 89h, 00h, 0Eh, 0DCh, 0CCh, 6Eh, 0E6h, 0DDh, 0DDh, 0D9h, 99h, 0BBh, 			  0BBh, 67h, 63h, 6Eh, 0Eh, 0ECh, 0CCh, 0DDh, 0DCh, 99h, 9Fh, 0BBh, 0B9h, 33h, 3Eh