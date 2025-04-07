; People out there discovered that you’ve been easily descrambling their 
; scrambled images and messages, and have resorted to a more serious 
; encryption scheme. Your team has been unable to figure it out until 
; recently, when one of your operatives was able to get a hold of the C 
; code that is used to encrypt each 32-bit integer. And, extremely 
; stupidly, the encryption key is hardcoded in the code, which makes it 
; possible to implement the inverse operation! The C code, which ;
; interprets the original integer (original_integer variable) as 
; an UNSIGNED value, is as follows:

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
	space		db		"  ", 0
	hash		db		"##", 0
	key			dd 		1374123

segment .bss
    ; unintialized vars
	hight 		resd		1		; hight of image (the # of ints to be read)
	length		resd		1		; length of image (# of bits) (will always be a multiple of 32)
	cur_len		resd		1		; The current int being read
	row			resd		1		; the 16 high bits of int
	us			resw		1		; the bottom bits  (for decoding)


segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

	; to run do :  cat encrypted_bunny.numbers | ./imagedecrypt
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
	mov		eax, [row]			; eax = row count
	inc		eax					; eax++
	mov		[row], eax			; row = eax (new row count)
	mov		ecx, [length]		; ecx = length
each_int:
	mov		[cur_len], ecx		; updates with new length after loop
	call	read_int			; reads next 32 int value


; 1) Reverse : encrypted_integer = (encrypted_integer << 29) | (encrypted_integer >> 3);
	ror     eax, 3                  ; eax = rotated back right 3

; 2) Reverse : encrypted_integer = tmp + (unsigned int) us;
	mov 	edx, eax            ; edx = eax (encrypted int)
	and 	edx, 0x00000FFF     ; edx = [0-0][11-0] extracts lower 12 bits (us)
	mov		[us], edx			; us = edx (us)
	sub		eax, edx			; eax (tmp) = eax (encrypted_int) - edx (us)
	mov		ebx, eax			; ebx = eax (tmp)
								; ebx = [31-0]

; 3a) Reverse : tmp &= 0xFFFFF000;
	; no way for me to reverse this...

; 3b) Reverse : tmp ^= (encryption_key * row * row);
mov     eax, [row]
imul    eax, eax           ; eax = row * row
imul    eax, 1374123       ; eax = key * row^2
xor     ebx, eax           ; ebx = tmp ⊕ key⋅row²

; 4) Reverse : tmp = original_integer << 12;
	shr		ebx, 12					; shifts (tmp) bits back right by 12 to get (original_int)
									; ebx = [0-0][19-0]

; 5) Reverse : unsigned short us = (original_integer >> 20);
	shl		edx, 20					; shifts (us) bits back left by 20
									; edx = [31-20][0-0]
	or  	ebx, edx				; ebx (original_int) combined with edx (us)
									; edx = [31-20][0 -0] (us)
									; ebx = [0 - 0][19-0] (original_int)

; 6) Reverse : unsigned int tmp = (original_integer << 12);
	; original_int was already found in previous step

	mov		ebx, edx

	mov		edx, 32				; edx = 32 (bit index)
	mov		ecx, [cur_len]		; ecx = eax (row length index)
	
each_bit:
	shl		ebx, 1				; mask over the 
	jc		one_bit				; jump if CF is 1

zero_bit:
	mov		eax, space			; loads "  "
	jmp		check_indexs		; jumps to check indexs
one_bit:
	mov		eax, hash			; loads "##"
check_indexs:
	call 	print_string		; prints out "  "

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

