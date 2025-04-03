; Luckily, you have spies out there, who have discovered the scrambling 
; scheme: for each 32-bit integer the high 16 bits are reversed (as in a 
; list reversal), and the low 16 bits are inverted (i.e., every 0 becomes 
; a 1 and every 1 becomes a 0). For instance, if the original 32-bit 
; integer is:
;    11110000010101010001111111000000
; then the scrambled bits are:
;    10101010000011111110000000111111

; This is similar to the imagedisplay program, but descrambles the input 
; integers before printing the ASCII art.

%include "asm_io.inc"

segment .data
    ; initalized varibles
	words		db		"Length is ", 0
	rint 		db		"Reading int: ", 0
	space		db		"  ", 0
	hash		db		"##", 0

segment .bss
    ; unintialized vars
	hight 		resd		1		; hight of image (the # of ints to be read)
	length		resd		1		; length of image (# of bits) (will always be a multiple of 32)
	cur_int		resd		1		; The current int being read
	h_bits		resw		1		; the high bits of int
	l_bits		resw		1		; the low bits of int
	hh			resb		1		; the high high 
	hl			resb		1		; the high low


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
	mov		eax, [hight]

each_row:
	mov		[hight], eax		; save updated hight after each loop
	mov		ecx, [length]		; ecx = eax (row length index)
each_int:
	call	read_int			; reads next 32 int value
	mov		[cur_int], eax		; cur_int = eax

	mov		[l_bits], ax		; l_bits = the lower 16 bits of int
	shr		eax, 16				; shift high 16 bits of eax into the low 16 bits
	mov		[h_bits], ax		; h_bits = the once high 16 bits of int
;decode:
	mov		ax, [l_bits]		; loads low bits into ax
	not 	ax					; flip all the bits in ax
	mov 	[l_bits], ax		; l_bits = ax

	mov		ax, [h_bits]		; loads high bits into ax
	ror		al, 4				; rotates the low bits by 4
	mov		[hh], al			; hh = rotated al bits
	ror		ah, 4				; rotates the high bits by 4
	mov		[hl], ah			; hl = rotated ah bits

	mov		al, [hl]			; al = new hl
	mov		ah, [hh]			; ah = new hh
	mov		[h_bits], ax		; h_bits = ax

	mov		ax, [h_bits]		; ax = h_bits (decoded high bits)
	shl		eax, 16				; shift bit up by 16
	mov		ax, [l_bits]		; ax = l_bits (decoded low bits)
	mov		[cur_int], eax		; cur_int = eax  (updates with the full decoded int)

	mov		ebx, 0x80000000		; ebx = 10000000 00000000 00000000 00000000  (bit mask)
	mov		edx, 32				; edx = 32 (bit index)
	
each_bit:
	mov		eax, [cur_int]		; cur_int = eax
	test	eax, ebx			; mask over the 
	jz		zero_bit			; jump over print statment
;one_bit:
	mov		eax, hash			; loads "##"
	jmp		check_indexs		; jumps to check indexs
zero_bit:
	mov		eax, space			; loads "  "
check_indexs:
	call 	print_string		; prints out "  "
;	mov		eax, [cur_int]		; cur_int = eax

	shr		ebx, 1				; shift open bit right by one
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

