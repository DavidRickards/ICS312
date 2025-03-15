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
	right	 	db	"It's a word!", 0				 	; r answer prompt
	wrong		db	"It's not a word!", 0				; w answer prompt	
	input		db  0, 0, 0, 0, 0, 0					; user input

segment .bss
    ; unintialized vars

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

	mov		edx, [num_words]	; the number of 5 letter words in all_words
	mov 	ecx, all_words		; ecx = &all_words

check_word:
	mov		ebx, [ecx]			; ebx = 1234_ charaters of a word for all_words
	mov		eax, [input]		; eax = 1234_ charaters of input
	cmp		eax, ebx			; compares the first 4 charaters
	jnz		check_index			; if not same jump

	mov		al, [input+4]		; al = the 5th charater from user input
	mov		bl, [ecx+4]			; bl = 5th byte (charater) of a word in all_words
	cmp		al, bl				; compares the 5th character
	jnz		check_index			; if not same jump

	mov		eax, right			; eax= &right "It's a word!"
	jmp		done				; ! ! FINISH ! !

check_index:					; Checks index
	sub		edx, 1				; edx =- 1  (decrement index)
	jz		not_word			; if index != 0  check_word
	add		ecx, 5				; ecx = &ecx + 4  (Moves address to next word)
	jmp		check_word			; Jmp to check_word

not_word:						; no matches to a word occured
	mov		eax, wrong			; eax= &wrong  "It's not a word!"

done:							; ! ! FINISH ! !
	call	print_string		
	call	print_nl


	popa
	mov	eax, 0
	leave
	ret

