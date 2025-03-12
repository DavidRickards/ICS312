Assignment 1 
David Rickards 
1/22/25

Exercise #1: Conversions [6pts]
For all the following, perform the conversions showing your work using the systematic methods described in the lecture notes.

a) hex 1B41 into binary      *Each hex = 4 bits*
      1   +    B    +   4    +   1
   1*16^3 + 11*16^2 + 4*16^1 + 1*16^0
    0001     1011      0100     0001

   ANSWER: 0001 1011 0100 0001  base 2

b) hex 9A4 into decimal
     9    +    A    +   4
   9*16^2 + 10*16^1 + 4*16^0
    2304  +   160   +   4   = 2468

    ANSWER: 2468 base 10

c) binary 1001110100111 into hex
       1  +   0011  +   1010  +  0111
    0001  +   0011  +   1010  +  0111
   1*16^3 +  3*16^2 + 10*16^1 + 7*16^0
      1   +    3    +    A    +   7  =>   13A7

    ANSWER: 13A7 base 16

d) binary 0110100 into decimal
     0       1       1       0       1       0       0
   0*2^6 + 1*2^5 + 1*2^4 + 1*2^3 + 1*2^2 + 0*2^1 + 0*2^0
    2^5 + 2^4 + 2^2 =  52

   ANSWER: 52 base 10

e) decimal 89 into binary  *the least significant bit is computed first*
    89 / 2 = 44  r  1
    44 / 2 = 22  r  0
    22 / 2 = 11  r  0
    11 / 5 =  5  r  1
     5 / 2 =  2  r  1
     2 / 2 =  1  r  0
     1 / 2 =  0  r  1  lest significant

   ANSWER: 1011001 base 2  *Lest significant on the left*

f) decimal 356 into hex  *the least significant bit is computed first*
   356 / 16 = 22 r 4
    22 / 16 =  1 r 6
     1 / 16 =  0 r 1  lest significant

   ANSWER: 164 base 16


Exercise #2: Binary and Hex Arithmetic [2pts]
Give the result for each of the operations below. Show your work (showing carries).
           cccc ccc
a) binary:   1110001   *start with the least significant bit (far right)*
            11010111 +
        =  101001000

   ANSWER: 101001000 base 2
  
            c  ccc       
b) hex:    52E12FFC 
        +  9871AB25
        =  EB52DB21 

   ANSWER: EB52DB21 base 16


Exercise #3: Two’s Complement [4pts]
Give the binary 16-bit two’s complement representation of the following decimal integers, and show the details of your work:

a) 237 base 10                 *Lest significant on the left*               
   237 / 2 = 118 r 1    
   118 / 2 =  59 r 0        
    59 / 2 =  29 r 1   
    29 / 2 =  14 r 1   
    14 / 2 =   7 r 0    
     7 / 2 =   3 r 1    
     3 / 2 =   1 r 1   
     1 / 2 =   0 r 1   
     =>           1110 1101   9-bit
     => 0000 0000 1110 1101   16-bit  

   ANSWER: 0000 0000 1110 1101  base 2   

b) -83 base 10                  *Lest significant on the left*
  step 1) flip 
          -83 => 83
  step 2) convert
          83 / 2 = 41 r 1
          41 / 2 = 20 r 1
          20 / 2 = 10 r 0
          10 / 2 =  5 r 0
           5 / 2 =  2 r 1
           2 / 2 =  1 r 0
           1 / 2 =  0 r 1
           =>            101 0011   7-bit
           => 0000 0000 0101 0011  16-bit   
  step 3) invert
         0000 0000 0101 0011
         => 1111 1111 1010 1100
  step 4) add 1
          1111 1111 1010 1100 + 1
        = 1111 1111 1010 1101

   ANSWER: 1111 1111 1010 1101 base 2


Exercise #4: Two’s Complement [4pts]
Give the hexadecimal 32-bit two’s complement representation of the following decimal integers, and show the details of your work:

a) -17 base 10   *Lest significant on the right*
  step 1) flip 
          -17 => 17
  step 2) convert
          17 / 16 = 1 r 1
           1 / 16 = 0 r 1
           =>       11 base 16   8-bit
           => 00000011 base 16  32-bit   
  step 3) invert
         00000011
         => FFFFFFEE
  step 4) add 1
          FFFFFFEE + 1
        = FFFFFFEF

   ANSWER: FFFFFFEF base 16

b)  251 base 10          *Lest significant on the right*
    251 / 16 = 15 r 11 => B
     15 / 16 =  0 r 15 => F
     =>       FB base 16  8-bit
     => 000000FB base 16  16-bit

    ANSWER:  000000FB base 16


Exercise #5: Two’s Complement [4pts]
Give the decimal value of the following 12-bit two’s complement hexadecimal representations, and show the details of your work:

*The most significant bit (the leftmost bit) indicates the sign of the number (0: positive, 1: negative)*
*In hex, if the left-most “digit” is 8, 9, A, B, C, D, E, or F, then the number is negative, otherwise it is positive*

a) E6A base 16    The number is negative so
  step 1) subtract 1
          E6A - 1 = E69
  step 2) invert
          E69 => 196
  step 3) convert
         1        9        6
         1*16^2 + 9*16^1 + 6*16^0 = 406 base 10
  step 4) flip
         406 => -406 

 ANSWER: - 406 base 10

b) 602 base 16   not negative
   6        0        2
   6*16^2 + 0*16^1 + 2*16^0 = 1538 base 10

  ANSWER: 1538 base 10




