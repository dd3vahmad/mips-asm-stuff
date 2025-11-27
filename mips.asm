.data
    fibInput: .asciiz "Which nth number of the fibonnaci do you wish to obtain? "
    space: .asciiz " "
    newLine: .asciiz "\n"
    fibOutput: .asciiz "The value of the: "
    fibOutput2: .asciiz "th Fibonnaci value is: " 
    fibValue: .word 0

    TRUE = 1
    FALSE = 0

    INT_PRINT = 1
    STRING_PRINT = 4
    INT_READ = 5

.text

.globl main
.ent main
main:

# Code here - NOTE: before function call; save your integer input to "fibValue"

# CHECKS: DO NOT CHANGE
move $s0, $v0
li $v0, STRING_PRINT
la $a0, newLine
syscall

li $v0, STRING_PRINT
la $a0, fibOutput
syscall 

li $v0, INT_PRINT
lw $a0, fibValue
syscall

li $v0, STRING_PRINT
la $a0, fibOutput2
syscall

li $v0, INT_PRINT
move $a0, $s0
syscall

li $v0, 10
syscall
.end main

.globl fib
.ent fib
fib:

jr $ra
.end fib