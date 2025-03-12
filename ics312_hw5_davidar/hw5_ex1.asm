; This program prompts the user for a 5-letter lower-case string, the guess, 
; and prints “It’s a words!” or “It’s not a words!” based on whether the guess 
; is a known 5-letter English words or not. This program assumes that the user 
; always enters the correct words that is exactly 5 lower-case letters followed
; by a linefeed.

%include "asm_io.inc"
%include "allwords.inc"

segment .data
    ; initalized varibles
	prompt	 	db	"Enter a 5-letter guess: ", 0		; prompt
	right	 	db	"It's a words!", 0				 	; r answer prompt
	wrong		db	"It's not a words!", 0				; w answer prompt	

segment .bss
    ; unintialized vars
	input    resb    6   ; Reserve 6 bytes for user input


segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

    ; prompt user to for input		can use a jmp loop here
	mov		eax, prompt			; eax = &prompt 
	call	print_string		; print(prompt)
	call	read_char			; reads single char to  s1  from al  (lower position)
	mov		[input], al			; stores user string inpuit
	call	read_char			; reads input in al  (lower position)
	mov		[input+1], al		; stores user string input
	call	read_char			; reads input in al  (lower position)
	mov		[input+2], al		; stores user string input
	call	read_char			; reads input in al  (lower position)
	mov		[input+3], al		; stores user string input
	call	read_char			; reads input in al  (lower position)
	mov		[input+4], al		; stores user string input
	call	read_char			; reads input in al  (lower position)

	mov 	eax, input			; eax = &input
	call 	print_string


	; check if it is a input


	popa
	mov	eax, 0
	leave
	ret

