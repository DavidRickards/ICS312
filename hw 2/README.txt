David Rickards
ICS312
2/3/25    DUE Feb 9th

Homework Assignment #2 
Exercise #1 [24pts]: Memory Layout
Consider the following .data segment:

A	dd	1101b  
B	db	043h, 01Ah, 0CEh
C	dw	-18
D	times   2 dw	012FAh
E	db	"c", 13, "aa",  0
F	dw      009h, 23o

Question #1 [18pts]
Show the contents of the memory bytes starting at address A, in hex, on a machine that uses Little Endian. Indicate labels as well. For instance, a (wrong) answer could look like:

A	dd	1101b = 8+4+1 = 13 => 0Dh =>00 00 00 0Dh then flip bc memory
      4 bytes                            => 0D 00 00 00h
B	db	043h, 01Ah, 0CEh re format to be in 1 byte
   1 byte each => 43h, 1Ah, CEh
C	dw	-18 => 18 => 16+2 => 00 12h flip -> FF EDh+1 =  FF EEh then mem flip
     2 bytes                                                 => ED FFh
D    x2 dw	012FAh conform to 2 bytes & flip bc memory => FA 12h
    2 byte  twice       => FA 12h FA 12h

E	db	"c", 13, "aa",  0 => 63h, 0Dh, 61h, 61h, 00h
     1 byte each
F	dw      009h, 23o => 00 09h, 00 13h then flip bc memory
     2 bytes each         => 09 00h, 13 00h

ANSWER:
   [ 0D 00 00 00h][43h|1Ah|CEh][EE FFh][FA 12h|FA 12h][63h|0Dh|61h|61h|00h][09 00h|13 00h]
	  A               B       C           D               E                   F

Question #2 [6pts]:
For each of the 6 labels, indicate whether it would lead to a different in-memory byte order on a Big Endian machine.

Then the memory flips the order of bytes so anything greater than a single bytes will result in a different memory order.

ANSWER:
   A, C, D, F  will have different in-memory order


Exercise #2 [26pts]: Memory and Registers
Consider the following 13 bytes (in hex) declared by some .data segment on a Little Endian machine:

L1          L2    L3                L4
03 00 00 00 6C 6C 6F 00 A1 B2 C3 13 00
Consider now the following program fragment:

mov     eax, [L2]   ; move the value of L2 into eax (L2 to only 2 bytes so read the first two of L3)

eax            (flip bc moving memory to register)
00 6F 6C 6C 
==============================
inc     eax         ; increase the value of eax by 1

eax
00 6F 6C 6D
==============================
mov     [L3], eax   ; insert the value of eax into the value of L3

L3            (flip back be moving from register to memory)
6D 6C 6F 00 C3 13
==============================
mov     ebx, [L1]   ; insert the value of L1 into a new register called ebx

ebx           (flip bc moved from memory to register)
00 00 00 03
==============================
mov     eax, L4     ; copy the address of L4 into eax

eax 
XX XX XX XX  ; whatever L4 address is (points to 00)
==============================
sub     eax, ebx    ; decrease the address in eax by the value ebx ( so to the left 3)

eax 
XX XX XX XX  ; should now be address pointing at byte (B2) in L3 space

==============================
mov     word [eax], 01970h   ; move 2 bytes of 01970h (19 70?) into the value in of eax

eax
XX XX XX XX  ; writes 19 70 (no flip bc writing straight to memory) where it points to the following below
         L4
19 70 13 00  ; (70 was B2)
==============================
Result

L1          L2    L3                L4
03 00 00 00 6C 6C 6D 6C 6F 19 70 13 00


After the code finishes executing, what are the contents, in hex, of the 13 memory bytes starting at address L1, on a machine using Little Endian?

Show your work for each instruction, as done for the examples in the lecture notes. Each instruction is worth 3 points. An instruction with no work shown will receive zero points.

Here is the way to show your work for each instruction:

If an instruction updates the value of a register, show the value of that register (e.g., “ecx = 00AABBCC, bx = FF FF, eax = ‘the address of the 8th byte’, edx = ‘the address of the byte with value 42’);
If an instruction updates memory, then show the full memory state after that instruction.
For instance, a partial answer (for a different program) could look like:

L1       L2       L3       L4       L5
3A FF 01 02 FF 6B B2 AA 42 41 61 62 D3 D5 D7

mov ebx, L1     ; ebx = address of the 1st byte

mov ecx, 0      ; ecx = 00 00 00 00

mov cx, [L3]    ; ecx = 00 00 AA B2

mov [L2], ecx   ; updates memory state:

L1       L2       L3       L4       L5
3A FF 01 B2 AA 00 00 AA 42 41 61 62 D3 D5 D7

mov ebx, L4     ; ebx = address of the byte with value 41

mov     bx, 12      ; ebx = ?? ?? 00 0C