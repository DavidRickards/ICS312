; This program prompts the user for a 5-letter lower-case string, the guess, 
; and prints “It’s a words!” or “It’s not a words!” based on whether the guess 
; is a known 5-letter English words or not. This program assumes that the user 
; always enters the correct words that is exactly 5 lower-case letters followed
; by a linefeed.

%include "asm_io.inc"

segment .data
    ; initalized varibles
	

segment .bss
    ; unintialized vars
	hight 		resd		1		; hight of image (the # of ints to be read)
	length		resd		1		; length of image (# of bits) (will always be a multiple of 32)


segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

	;; NOTE:  each int line is a 

    ; save image dimensions		
	call	read_int			; reads the first line of the doc (32 bits) (this hight)
	mov		[hight], eax		; hight = eax
	call	read_int			; reads the second line of the doc (32 bits) (this hight)
	mov		[length], eax		; length = eax
	call 	print_int
	call 	print_nl

	; readthe second number in file (the length)
;	 mov		[length], eax		; length = eax

 each_int:			; for each integer listed
	; save the integer (MAKE SURE IT IS A SIGNED INT)


	popa
	mov	eax, 0
	leave
	ret

