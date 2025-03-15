; This program first prompts the user for a positive integer. This integer is used to pick a mystery word to guess. 
; The program computes the remainder of the division of this integer by [num_words], which gives the index of a word 
; in the list of all words. The program then repeatedly asks the user for a 5-letter lower-case string, the guess. 
; If the guess is not a word, then the program asks for a guess again. If the guess is a word, then the program prints, 
; for each letter in the guess, an underscore if the letter is not a match or the upper-case version of the letter is 
; the letter is a match. The game is finished after the player guesses 6 real word that are not the mystery word.

%include "asm_io.inc"
%include "allwords.inc"

segment .data
    ; initalized varibles
	int_prompt	db	"Enter any integer: ", 0			; prompt for int
	prompt	 	db	"Enter a 5-letter guess: ", 0		; prompt
	wons		db	"You won!", 0						; winning message
	space		db	"                        "			; empty space for formating + letters
	letters		db  "_____", 0  						; correct letter output
	e_letters	db  "____"								; empty letter to reset back to
	losts		db	"You lost. The word was "
	the_word    db  0, 0, 0, 0, 0, 0					; stores the randomly chosen word	
	guess		db  0, 0, 0, 0, 0						; user input
	turns		dd	6

segment .bss
    ; unintialized vars
	index		resd    1	; address of the random word

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

	; At the start fo the program and get user number
	mov		eax, int_prompt		; eax = &int_prompt 
	call	print_string		; print(int_prompt)
	call	read_int			; eax = user int

	; calculate the number of bytes to address to 
	mov 	edx, 0				; reseting for the remiander
	mov		ebx, [num_words]	; ebx = num_words
	div		ebx					; eax / ebx
	mov		ecx, edx			; ecx = ebx (the remainder)
	mov		eax, 5				; eax = 5  (for 5 bytes)
	mul		ecx					; eax = eax x  ecx  (how many bytes the adress fo the word is)

	; Save chosen word in memory
	mov 	ecx, all_words		; ecx = &all_words
	add		ecx, eax			; ecx = ecx + eax  (correct word address)

	; Print first 4 letters of the word
	mov		ebx, [ecx]			; ebx = the first 4 bytes (characters)
	mov		[the_word], ebx		; Store it in [the_word] (for debugging)
	mov		bl, [ecx+4]			; bl = the 5th byte (character)
	mov		[the_word+4], bl    ; the_word =  the whole word to guess
;	mov		eax, the_word		
	mov		edx, [num_words]	; edx = num_words
	mov		[index], edx		; index =  edx

	call	read_char			; comsume linefeed
	jmp		guess_and_check		; skips over the update_output and promps for the guess	

; prompt the user and stores their 5-letter guess
guess_and_check:		
	mov		edx, 0				; edx = 0   sets the word into 0
	mov		eax, prompt			; eax = &prompt 
	call	print_string		; print(prompt)
read_letter:		
	call	read_char				; reads and compared single char
	mov     byte [guess+edx], al	; guess+index = al   (inserts char into guess word)
	inc		edx						; edx++
	cmp		edx, 5				; edx - 5
	jnz		read_letter			; if not all 5 read loop back
	call	read_char			; clears terminating buffer space

	; the set up for the check:
	mov		edx, [num_words]	; edx = 5757
	mov 	ecx, all_words		; ecx = &all_words

; checks that the guess is a real word
check_word:
	mov		ebx, [ecx]			; ebx = 1234_ charaters of a word for all_words
	mov		eax, [guess]		; eax = 1234_ charaters of guess
	cmp		eax, ebx			; compares the first 4 charaters
	jnz		check_word_index	; if not same jump

	mov		al, [guess+4]		; al = the 5th charater from user guess
	mov		bl, [ecx+4]			; bl = 5th byte (charater) of a word in all_words
	cmp		al, bl				; compares the 5th character
	jnz		check_word_index	; if not same jump

	mov		ecx, 0				; ecx = 0   (ammount of letters correct)
	mov		edx, 0				; edx = 0   (letter index in the words)
	jmp		compare_char		; ! ! COMPARE ! !

check_word_index:				; Checks index
	sub		edx, 1				; edx =- 1  (decrement index)
	jz		guess_and_check		; if index != 0  (not a word) guess_and_check again
	add		ecx, 5				; ecx = &ecx + 4  (Moves address to next word)
	jmp		check_word			; Jmp to check_word

; Updates letter is comparision com back true
; Compares each char
compare_char:
	mov		al, [guess+edx]		; al = guess char at edx index
	mov		bl, [the_word+edx]	; al = guess char at edx index
	cmp		al, bl				; al - bl
	jnz		check_char_index	; skip update if not same
; update_ouput:
	sub		al, 20h				; change bit to capitalized
	mov		[letters+edx], al	; replaces "_"  with the capital letter
	inc		ecx					; ecx++ (ammount of letters correct)

check_char_index:
	cmp		edx, 5 				; edx - 5     (letter index in the words)
	jz  	print_output		; if word complete but not it reprompt
	inc		edx					; edx++  move up one letter index
	jmp		compare_char		; compare next char	

print_output:
	mov		eax, space			; eax = &space + letters
	call	print_string
	call	print_nl
	
	mov		eax, [e_letters]	; eax = empty letters
	mov		[letters], eax		; reseting letter to be empty
	mov		al, [e_letters]	
	mov		[letters+4], al		; resets last char

	cmp		ecx, 5				; ecx - 5		(check if aall are correct)
	jz		won					; jump to won
	mov		edx, [turns]		; edx = turns 
	sub		edx, 1				; edx--
	jz		lost				; jump to lost if out of moves
	mov		[turns], edx		; turns = edx
	jmp		guess_and_check		; not all letters were correct retry with new guess

won:
	mov 	eax, wons			; eax = &won
	jmp		done				; skip to done
lost:
	mov 	eax, losts			; eax = &lost
done:							; ! ! FINISH ! !
	call	print_string		
	call	print_nl



	popa
	mov	eax, 0
	leave
	ret

