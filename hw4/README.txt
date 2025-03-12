David Rickards
ICS312
2/19/25

Homework Assignment #4 [50 pts]

Exercise #1: Overflow [40 pts]
For each of the following hex operations:

You an have OF=1 without having a carry 
IF you thing of signed then 
ex:    7A + 11 = 8B
       (+)+(+)=(-) is does not make sense

Unsigned is horizontal
Signed is vertical

                     
                       c   <- no carry overflow so CF
2-byte quantities: (+) 6733 + 7B1C = E24F
                  +(+) 7B1C
                  =(-) E24F <- may be interpreted as a neg num so overflow flag
ANSWER: 
If UNSGHED:        If SIGNED:
   CF=	      	     CF=0
   OF=0    	         OF=1


                        ccc <- so overflow for CF
2-byte quantities:   (-) 8FE0 + A036 = 13016
                    +(-) A036 
                    =(+) 3016 <- Positives can't be made from negatives 
ANSWER:                            (Bad logic & overflowso OF)
If UNSGHED:        If SIGNED: 
   CF=1	      	       CF=0
   OF=0    	           OF=1

                      cc <- so overflow CF
1-byte quantities: (+) 0E + F8 = 106
                  +(-) F8   <- if signed then small neg number
                  =(+) 06   <- legal logic so no OF?
ANSWER: 
If UNSGHED:        If SIGNED:
   CF=1	      	       CF=0
   OF=0    	           OF=1


1-byte quantities: (-)E3 + 11 = F4 <- no carry no CF
                  +(+)11
                  =(-)F4    <- legal logic so no OF
ANSWER: 
If UNSGHED:        If SIGNED:
   CF=0	      	     CF=0
   OF=0    	         OF=0


Exercise #2: Mystery Digit [10 pts]
Given the following operation with a mystery hex digit:

    ?EFD + C32A

!!!FOR THESE QUESTIONS I ASSUEM THAT IT IS IN 2-BYTES!!!

answer these two questions:
* What is the smallest value of the mystery digit such that the overflow bit is set (OF=1) and the carry bit is set (CF=1).

  This requires both a carry and bad logic

        cccc  <- need carry to causes CF to be set
     (-) 8EFD + C32A = 15227
    +(-) C32A
    =(+) 5227  <- bad logic causes OF to be set

ANSWER:
    8 is the smallest number to be negative and result in positive. Causing OF

* What is the largest value of the mystery digit such that the overflow bit is not set (OF=0) and the carry  bit is not set (CF=0)?
    
         1cc <- can't let it carry so need to be less than 3
     (+) 2EFD + C32A = 15227
    +(-) C32A
    =(+) F227 <- logic is okay here

ANSWER:
    If it need to be less than 3 to avoid carrys then 2 is the biggest number it can be
