;The C code, which interprets the original integer (original_integer variable) as 
;an UNSIGNED value, is as follows:

;unsigned int encryption_key = 1374123;
;unsigned int encrypted_integer;
;unsigned short us = (original_integer >> 20);
;unsigned int tmp = (original_integer << 12);
;tmp ^= (encryption_key * row * row);
;tmp &= 0xFFFFF000;
;encrypted_integer = tmp + (unsigned int) us;
;encrypted_integer = (encrypted_integer << 29 ) | (encrypted_integer >> 3);

%include "asm_io.inc"

segment .data
    ; initalized varibles
;	words		db		"Length is ", 0
;	rint 		db		"Reading int: ", 0
	space		db		"  ", 0
	hash		db		"##", 0
;	encoded		db		"Encoded: ", 0
;	decoded		db		"Decoded: ", 0
;	expected	db		"Expecte: 11110000010101010001111111000000", 0 ; 00011111110000001111000001010101

segment .bss
    ; unintialized vars
	hight 		resd		1		; hight of image (the # of ints to be read)
	length		resd		1		; length of image (# of bits) (will always be a multiple of 32)
	cur_len		resd		1		; The current int being read
;	h_bits		resw		1		; the 16 high bits of int
;	rev_dex		resd		1		; index for bit reversal


segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

	; to run do :  cat scrambled_bunny.numbers | ./imagedescramble
	;; NOTE:  each int line is a 32 bits

    ; save image dimensions		
	call	read_int			; reads the first line of the doc (32 bits) (this hight)
	mov		[hight], eax		; hight = eax

	call	read_int			; reads the second line of the doc (32 bits) (this hight)
	cdq							; sign extend
	mov		ecx, 32				; ecx = 32
	idiv	ecx					; eax / ecx
	mov		[length], eax		; length = eax  (the quotant)

	mov		eax, [hight]		; eax = hight (int)
each_row:
	mov		[hight], eax		; save updated hight after each loop
	mov		ecx, [length]
each_int:
	mov		[cur_len], ecx		; updates with new length after loop
	call	read_int			; reads next 32 int value
	mov		ecx, eax			; ecx = eax

;flip_low:
	not 	cx					; flip all the bits in ax (lower 16)
	rol		ecx, 16				; rotates the ax bits to high and the high 16 bits into ax

	mov		bx, cx				; bx = ax  (high bits to reverse)
	mov		edx, 16				; edx = 16 (reverse index)

reverse_high: 
	shl		bx, 1				; shifts off right bit of bx into CF
	rcr		ecx, 1				; add the CF bit tot eh left of eax
	sub		edx, 1				; edx--
	jnz		reverse_high		; if more to revers then jump

	mov		ebx, ecx			; ebx = ecx (decoded int)
	;mov		ebx, 0x80000000		; ebx = 10000000 00000000 00000000 00000000  (bit mask)
	mov		edx, 32				; edx = 32 (bit index)
	mov		ecx, [cur_len]		; ecx = eax (row length index)
	
each_bit:
;	mov		ebx, [cur_int]		; cur_int = eax
	shl		ebx, 1				; mask over the 
	jc		one_bit				; jump if CF is 1

zero_bit:
	mov		eax, space			; loads "  "
	jmp		check_indexs		; jumps to check indexs
one_bit:
	mov		eax, hash			; loads "##"
check_indexs:
	call 	print_string		; prints out "  "
;	mov		eax, [cur_int]		; cur_int = eax

	sub		edx, 1				; edx--
	jnz 	each_bit			; if edx != 0 (stil have bits to read in int)

	sub		ecx, 1				; ecx - 1
	jnz		each_int			; if sill more ints to read in row	

	call 	print_nl			; prints new line
	mov		eax, [hight]		; eax = [hight]
	sub		eax, 1				; eax = eax - 1 (updated hight)
	jnz		each_row			; if more row to read jump to read row


	popa
	mov	eax, 0
	leave
	ret

