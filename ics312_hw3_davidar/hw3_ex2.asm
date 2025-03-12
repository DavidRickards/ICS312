;  prompts the user for a 3-character string of lower-case letters 
; a to z, s1, and a signed 4-byte integer, x, between 1 and 26 
; (inclusive). The program then prints a 6-character string, s2.

%include "asm_io.inc"

segment .data
    prompt1		db		"Enter a 3-character lower-case string: ", 0
	prompt2		db		"Enter an integer between 1 and 26: ", 0
	third_print	db		"The encoded string is: ", 0, 0, 0, 0, 0, 0, 0	; should imidiantly have 7 1 bytes after end_text that I can append s2 to for a single print

segment .bss
    s1		resb	3	; saves byte chars s1 is not printed so no need nill terminator at the end
	x		resd	1	; saves a single 4 byte int (although I only need 1 byte to store 1-26)
	s2 		resb	6	; save a single byte 6 times

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

    ; prompt user to for inputs
	mov		eax, prompt1		; eax = &prompt1
	call	print_string		; print prompt1
    call	read_char			; reads single char to  s1  from al  (lower position)
	mov		[s1], al			; stores user string inpuit
	call	read_char			; reads input in al  (lower position)
	mov		[s1+1], al			; stores user string input
	call	read_char			; reads input in al  (lower position)
	mov		[s1+2], al			; stores user string input

	mov		eax, prompt2		; eax = &prompt2
	call	print_string		; print prompt2
    call	read_int			;  reads input
	mov		[x], eax			; stores user int into x

	; making s2
	mov		al, [s1]		; al = s1[0]
	sub 	al, 32		 	; al = upper(s1[0])
	mov 	[s2], al	 	; s2[0] = Upper(s1[0])
	mov 	al, '-'			; al = "-" 
	mov		[s2+1], al		; s2[1] = "-"
	mov		al, [s1+2]		; last char placed in al (low position reg)
	mov		[s2+2], al		; last char placed in 3rd index
	mov		al, [s1+1]		; al = s1[1]
	mov		[s2+3], al		; s2[3] = sl[1]
	mov		al, '@'			; al = '@'  (@ is the char right before the capital alphabet)
	add		al, byte [x]	; al = (&@ + x) shifts '@' by  the first byte in x
	mov		[s2+4], al		; s2[4] = (&@ + x)
	mov		al, [s1+1]		; al = s1[1]
	mov		[s2+5], al		; s2[5] = s1[1]

	; for bonus point I append s2 to the end of end_text for the thrid and final print
	mov		al, [s2]				; al = s2[0]
	mov		[third_print+23], al	; appends s2[0] to the end 
	mov		al, [s2+1]				; al = s2[1]
	mov		[third_print+24], al	; appends s2[1] to the end 
	mov		al, [s2+2]				; al = s2[2]
	mov		[third_print+25], al	; appends s2[2] to the end 
	mov		al, [s2+3]				; al = s2[3]
	mov		[third_print+26], al	; appends s2[3] to the end 
	mov		al, [s2+4]				; al = s2[4]
	mov		[third_print+27], al	; appends s2[4] to the end 
	mov		al, [s2+5]				; al = s2[5]
	mov		[third_print+28], al	; appends s2[5] to the end 

	; prints the third_print
	mov		eax, third_print		; eax = &third_print
	call	print_string			; prints(third_print)
	call	print_nl


	popa
	mov	eax, 0
	leave
	ret

