Homework Assignment #7 [50 pts]
You are expected to do your own work on all homework assignments. You may 
(and are encouraged to) engage in general discussions with your classmates 
regarding the assignments, but specific details of a solution, including the 
solution itself, must always be your own work. See the statement of Academic 
Dishonesty on the Syllabus.


Exercise #1: “Draw” a stack [10 pts]
...
f(3,2);
...
and the following two C function definitions:

f(int x, int y) {
    int a = x+y;
    g(x*a, a);
}

g(int a, int b) {
    int z;
    z = a+b;
    // HERE
}

ANSWER :

    STACK:
1 |  y = 2  // f's  arguments
2 |  x = 3  // f's  argumnets
3 | @ f ret 
4 | main saved EBP
5 |  a = 5  // f local var
6 |  b = 5  // g's arg
7 |  a = 15 // g's arguments
8 | @ g ret
9 | f saved EBP
10|  z = 20 // g's local var


Exercise #2: “Draw” another stack [15 pts]
Consider the following C code fragment:

...
g(1,3)
...
and the following C function definition:

g(int n, int offset) {
        int z;

        if (offset == 1) {
             // HERE
             return 1;
        }

        z = g(n+1, offset-1);
        z += (offset - n);
        return 2*z;
}

ANSWER :

     STACK:
1 |   offset = 3         // g arg
2 |   n = 1              // g arg
3 | @ g ret
4 | main saved EBP
5 |   z = g(n+1, off-1)  // g local var
6 |   offset = 2         // g arg (repeat 1)
7 |   n = 2              // g arg (repeat 1)
8 | @ g ret              // repeat 1
9 | g saved EBP          // repeat 1
10|  z = g(n+1, off-1)        // g local var (repeat 1)
11|  offset = 1          // g arg (repeat 2)
12|  n = 3               // g arg (repeat 2) 
13| @ g ret              // repeat 2
14| g saved EBP          // repeat 2
15|  z = ?

Exercise #3: Reverse-engineering [25 pts]
Write a C translation of the NASM program below, sticking to the assembly code 
as much as possible. Use single-letter variable names for function parameters 
(e.g., int foo(int x, int y)) and for local variables within function (e.g., int z) 
instead of using x86 register names (in fact registers should never appear in your 
translation). It is expected that your C code is much shorter than the assembly code.

Here are requirements for your C program (in addition to it being a correct translation):
 - Your C program must declare exactly the same number of global variables as the assembly program
 - Your C program must declare exactly the same number of local variables as the assembly program
 - Function f in assembly must also be called f in your C program (and must always return an integer)
 - Function asm_main in assembly must be called main in your C program (a`nd must return 0)
 - Your C program must NOT used any goto statement
Not meeting these requirements will lead to a grade of 0.
Hint: This program outputs the number 19 (but it is not necessary to know this to do the translation).


int a;      // both have memory  [a] 
int b;                           [b]


int f(int a, int b, int c) {        // push ebp,   // mov ebp, esp 
    int x = 1;                      // sub esp     // mov dword [ebp-4], 1
    if (a == 5) {                   // cmp dword [ebp+8], 5     // jz endf
        return x;         // endf:  // mov eax, [ebp-4]  // mov esp, ebp  // pop ebp  // ret
    }
    a++;                  // mov ebx, [ebp+8]    // inc ebx
    x = b + f(a, b, c);   // push ebx   // push dword [ebp+12]  // push dword [ebp+16]  // call f
                          // add esp, 12   // mov ebx, [ebp+12]  // add ebx, eax   // mov [ebp-4], ebx
    return x;             // endf:  // mov eax, [ebp-4]  // mov esp, ebp  // pop ebp  // ret
}

int main() {
    . . .               // assumes .data does something here to global ints.
    b = f(a, 6, 4);       // push dword 4, 6, [a]  // call f  // add esp, 12   // mov [b], eax
    printf("%d\n", b);    // call print_int   // call print_nl
    return 0;
}
