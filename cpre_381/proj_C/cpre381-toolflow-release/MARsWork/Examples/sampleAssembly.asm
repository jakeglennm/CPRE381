#
# Just a sample, simple example asm code that does not do any meaningful task
#

# data section
.data
fibs:.word   1,2,3,4,5         # "array" of words to contain fib values

# code/instruction section
.text
addi $t0, $0, -1
lui $t1, $0, 
sw $t1, 0($t1)

j NEXT_INST # inst with no reg/mem update
NEXT_INST:

addi $t2, $0, 4
sw $t2, 0($t2)

addi $t3, $0, 8
sw $t3, 0($t3)

addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt
