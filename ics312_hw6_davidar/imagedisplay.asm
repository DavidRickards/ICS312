; This program a 0-bit is printed as two white spaces (‘ ‘) and a 1-bit is printed as two hashpounds (‘##’).
;                                                              ##
;    ####################################################  ##    
;##  ####  ######################      ##############    ##  ##  
;######      ##################################################  
;  ######  ############  ######  ############  ######## 

%include "asm_io.inc"

segment .data
    ; initalized varibles
	space		db		"  ", 0
	hash		db		"##", 0

segment .bss
    ; unintialized vars
	hight 		resd		1		; hight of image (the # of ints to be read)
	length		resd		1		; length of image (# of bits) (will always be a multiple of 32)
	cur_int		resd		1		; The current int being read

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	

	; to run do :  cat example_image.numbers | ./imagedisplay

	;; NOTE:  each int line is a 

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
	mov		ebx, 0x80000000		; ebx = 10000000 00000000 00000000 00000000  (bit mask)
	mov		edx, 32				; edx = 32 (bit index)
	call	read_int			; reads next 32 int value
	mov		[cur_int], eax		; cur_int = eax
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

