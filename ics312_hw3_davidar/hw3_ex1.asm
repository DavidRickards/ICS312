; This program prompts the user for two signed 4-byte 
;  integers x and y and prints the results of 3x - 2y + 12.

%include "asm_io.inc"

segment .data
    ; initalized varibles
	prompt1 	db	"Enter integer #1: ", 0	; promptcharacters
	prompt2 	db	"Enter integer #2: ", 0
	endText		db	"The result is: ", 0

segment .bss
    ; unintialized vars
	input1		resd	1
	input2		resd	1
	result		resd	1


segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

    ; prompt user to for inputs
	mov		eax, prompt1		; eax = *prompt1
	call	print_string 	 	; print(prompt1)
    call	read_int			; Read the users int input (into eax) (assume always valid)
	mov		[input1], eax		; input1 = (integer input)
	mov		eax, prompt2		; eax = *prompt2
	call	print_string 	 	; print(prompt2)
    call	read_int			; Read the users int input (into eax) (assume always valid)
	mov		[input2], eax		; input2 = (integer input)

	;print statement before calculation	
	mov 	eax, endText		; eax = *endText
	call	print_string		; print the string in eax

	; math for 3x
	mov		eax, [input1]		; eax = input1 value
	add		eax, [input1]		; eax = 2x
	add		eax, [input1]		; eax = 3x	
	; math for 2y
	mov		ebx, [input2]		; eax = y
	add		ebx, [input2]		; eax = 2y
	; full function and prints results
	sub		eax, ebx			; eax = 3x - 2y
	add		eax, 12				; eax = (3x- 2x) + 12
	call	print_int			; prints the result from eax
	call	print_nl

	popa
	mov	eax, 0
	leave
	ret

