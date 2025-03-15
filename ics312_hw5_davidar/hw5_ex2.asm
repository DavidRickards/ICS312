; This program prompts the user for a 5-letter lower-case string, the guess, 
; and prints “It’s a words!” or “It’s not a words!” based on whether the guess 
; is a known 5-letter English words or not. This program assumes that the user 
; always enters the correct words that is exactly 5 lower-case letters followed
; by a linefeed.

%include "asm_io.inc"
%include "allwords.inc"

segment .data
    ; initalized varibles
	int_prompt	db	"Enter any integer: ", 0			;prompt for int
	prompt	 	db	"Enter a 5-letter guess: ", 0		; prompt
	right	 	db	"It's a word!", 0				 	; r answer prompt
	wrong		db	"It's not a word!", 0				; w answer prompt	
	guess		db  0, 0, 0, 0, 0, 0					; user input
	letters		db  "_____", 0  						; correct letter output

segment .bss
    ; unintialized vars
	the_word    resb    6   ; Reserve 6 bytes for user input
	index		resd    1	; reserves for int input


segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

	; At the start fo the program
	mov		eax, int_prompt		; eax = &int_prompt 
	call	print_string		; print(int_prompt)
	call	read_int			; eax = user int
	mov 	edx, 0				; reseting for the remiander
	mov		ebx, [num_words]	; ebx = num_words
	div		ebx					; eax / ebx
	mov		ecx, edx			; ecx = ebx (the remainder)
	mov		eax, 5				; eax = 5  (for 5 bytes)
	mul		ecx					; eax x  ecx  (how many bytes the adress fo the word is)
	
	call 	print_int			
	call 	print_nl



;guess_and_check:
;	mov		eax, prompt			; eax = &prompt 
;	call	print_string		; print(prompt)
;	call	read_char			; reads single char to  s1  from al  (lower position)
;	mov		[guess], al			; stores user string inpuit
;	call	read_char			; reads input in al  (lower position)
;	mov		[guess+1], al		; stores user string input
;	call	read_char			; reads input in al  (lower position)
;	mov		[guess+2], al		; stores user string input
;	call	read_char			; reads input in al  (lower position)
;	mov		[guess+3], al		; stores user string input
;	call	read_char			; reads input in al  (lower position)
;	mov		[guess+4], al		; stores user string input
;	call	read_char			; reads input in al  (lower position)

;	mov 	eax, input			; eax = &input
;	call 	print_string

;	mov		edx, [num_words]	; the number of 5 letter words in all_words
;	mov 	ecx, all_words		; ecx = &all_words

;check_word:
;	mov		ebx, [ecx]			; ebx = 1234_ charaters of a word for all_words
;	;mov		[space], ebx 		; space = 1, 2, 3, 4, 0, 0 where 1234 are charaters
;	mov		eax, [input]		; eax = 1234_ charaters of input
;	cmp		eax, ebx			; compares the first 4 charaters
;	jnz		check_index			; if not same jump
;
;	mov		al, [input+4]		; al = the 5th charater from user input
;	mov		bl, [ecx+4]			; bl = 5th byte (charater) of a word in all_words
;	cmp		al, bl				; compares the 5th character
;	jnz		check_index			; if not same jump
;
;	mov		eax, right			; eax= &right "It's a word!"
;	jmp		done				; ! ! FINISH ! !
;
;check_index:					; Checks index
;	sub		edx, 1				; edx =- 1  (decrement index)
;	jz		not_word			; if index != 0  check_word
;	add		ecx, 5				; ecx = &ecx + 4  (Moves address to next word)
;	jmp		check_word			; Jmp to check_word
;
;not_word:						; no matches to a word occured
;	mov		eax, wrong			; eax= &wrong  "It's not a word!"
;
;done:							; ! ! FINISH ! !
;	call	print_string		
;	call	print_nl


	popa
	mov	eax, 0
	leave
	ret

