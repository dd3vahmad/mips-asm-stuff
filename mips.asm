.data
    fibInput:   .asciiz "Which nth number of the fibonnaci do you wish to obtain? "
    seqPrompt:  .asciiz "\nEnter n to print the Fibonacci sequence up to: "
    seqHeader:  .asciiz "\nFibonacci sequence: "
    space:      .asciiz " "
    newLine:    .asciiz "\n"
    fibOutput:  .asciiz "The value of the: "
    fibOutput2: .asciiz "th Fibonnaci value is: " 
    fibValue:   .word 0          # REQUIRED: must store input for Problem 1
    seqLimit:   .word 0          # store limit for Problem 2 (optional)
    
    TRUE = 1
    FALSE = 0

    INT_PRINT = 1
    STRING_PRINT = 4
    INT_READ = 5

.text

########################################################################
# main
# - Problem 1: read n1 -> compute fib(n1) -> store n1 in fibValue (required)
# - Problem 2: prompt for n2 -> print fib(0..n2) recursively using fib()
# - Finally: preserve the original "DO NOT CHANGE" block exactly as given
########################################################################
.globl main
.ent main
main:

    # ---------- PROBLEM 1: prompt and read n1 ----------
    # print prompt for Problem 1
    li $v0, STRING_PRINT     # syscall: print string
    la $a0, fibInput
    syscall

    # read integer n1 into $v0 (syscall)
    li $v0, INT_READ
    syscall
    move $t0, $v0            # t0 = n1 (temporary store)

    # save required value to fibValue (store n1 to memory)
    sw $t0, fibValue

    # call fib(n1) -> returns result in $v0
    move $a0, $t0            # pass n1 in $a0
    jal fib
    move $t_result, $v0      # save result of fib(n1) in temporary register ($t_result)

    # ---------- PROBLEM 2: prompt and print sequence ----------
    # print prompt for Problem 2
    li $v0, STRING_PRINT
    la $a0, seqPrompt
    syscall

    # read integer n2
    li $v0, INT_READ
    syscall
    move $t1, $v0            # t1 = n2 (temporary store)
    sw $t1, seqLimit         # optional store in memory for clarity

    # also put limit into $s1 (saved register) so recursive print function can use it
    move $s1, $t1

    # print header before sequence
    li $v0, STRING_PRINT
    la $a0, seqHeader
    syscall

    # start printing sequence from i = 0
    li $a0, 0                # a0 = starting index i = 0
    jal print_sequence       # recursively prints fib(0)..fib(n2)

    # after printing sequence, print a newline
    li $v0, STRING_PRINT
    la $a0, newLine
    syscall

    # ---------- Restore Problem 1 result into v0 for the DO NOT CHANGE block ----------
    move $v0, $t_result      # put fib(n1) back into $v0 (so move $s0,$v0 in the block matches)

    # ---------- CHECKS: DO NOT CHANGE (keeps original output format) ----------
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

    li $v0, 10              # exit
    syscall
.end main


########################################################################
# fib(n) - recursive Fibonacci function
# Input:  $a0 = n
# Output: $v0 = fib(n)
# Preserves $ra on stack, uses stack frame, supports recursion
########################################################################
.globl fib
.ent fib
fib:
    # create stack frame and save return address + original argument
    addi $sp, $sp, -12      # allocate 12 bytes
    sw   $ra, 8($sp)        # save ra
    sw   $a0, 4($sp)        # save argument n

    # base case: if n <= 1, return n
    li   $t6, 1
    ble  $a0, $t6, fib_base

    # recursive case: compute fib(n-1)
    addi $a0, $a0, -1       # a0 = n-1
    jal  fib                # fib(n-1)
    move $t2, $v0           # t2 = fib(n-1)

    # restore original n from stack into a0
    lw   $a0, 4($sp)
    addi $a0, $a0, -2       # a0 = n-2
    jal  fib                # fib(n-2) -> result in v0

    # v0 currently has fib(n-2), add fib(n-1)
    add  $v0, $v0, $t2      # v0 = fib(n-2) + fib(n-1)

    j    fib_end

fib_base:
    # For n == 0 or n == 1, just return n
    move $v0, $a0

fib_end:
    # restore ra and stack pointer, return
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra
.end fib


########################################################################
# print_sequence(i)
# Recursively prints Fibonacci numbers from i to n, where n is in $s1
# Input: $a0 = current index i
# Uses: $s1 = sequence limit n (preserved across calls)
#
# Behavior:
#  - if i > n: return
#  - else: compute fib(i), print it, print a space, call print_sequence(i+1)
########################################################################
.globl print_sequence
.ent print_sequence
print_sequence:
    # if i > s1 (limit), stop recursion
    bgt  $a0, $s1, seq_return

    # save return address and current i on stack (we will call fib and then recurse)
    addi $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $a0, 0($sp)

    # compute fib(i)
    move $t3, $a0           # preserve a0 (current i) in t3 (redundant with stack but easier)
    move $a0, $t3           # ensure argument is in a0 for fib
    jal  fib                # fib(i) -> result in $v0

    # save fib(i) result before doing syscalls which clobber $v0
    move $t4, $v0           # t4 = fib(i)

    # print integer fib(i)
    li   $v0, INT_PRINT
    move $a0, $t4
    syscall

    # print a space after the number
    li   $v0, STRING_PRINT
    la   $a0, space
    syscall

    # restore i for recursive call (get it from stack)
    lw   $a0, 0($sp)
    addi $a0, $a0, 1        # a0 = i + 1

    # recursive call to print next index
    jal  print_sequence

    # restore ra and stack, then return
    lw   $ra, 4($sp)
    addi $sp, $sp, 8
    jr   $ra

seq_return:
    jr $ra
.end print_sequence
