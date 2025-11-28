# Name: <your name>
# NSHE ID: <your id>
# Assignment: <assignment number> program goes here

.data
    fibInput: .asciiz "Which nth number of the fibonnaci do you wish to obtain? "
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
    # print prompt
    li $v0, STRING_PRINT
    la $a0, fibInput
    syscall     # syscall: print string

    # read integer n into $v0
    li $v0, INT_READ
    syscall     # syscall: read int

    # save n to fibValue
    sw $v0, fibValue

    # call fib(n)
    move $a0, $v0
    jal fib

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
    syscall     # terminate program
.end main

# Fibonacci function
# Recursive definition: if n = 0 return 0; if n = 1 return 1; if n > 1 return fib(n-1) + fib(n-2)
# $a0 = n
# Returns $v0 = fib(n)
.globl fib
.ent fib
fib:
    subu $sp, $sp, 8    # allocate stack space
    sw $ra, ($sp)       # save return address
    sw $a0, 4($sp)      # save argument

    # check for base cases
    li $t0, TRUE
    ble $a0, $t0, fibDone

    # get fib(n-1)
    sub $a0, $a0, 1
    jal fib
    move $t0, $v0       # save fib(n-1)

    # get fib(n-2)
    lw $a0, 4($sp)
    sub $a0, $a0, 2
    jal fib

    # fib(n-1) + fib(n-2)
    add $v0, $v0, $t0

fibDone:
    lw $ra, ($sp)       # restore ra
    addu $sp, $sp, 8    # deallocate stack
    jr $ra
.end fib
