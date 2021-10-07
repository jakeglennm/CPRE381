#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text
lui $t0, 0x1001
sw $t0, 0($t0)
lw $t1, 0($t0)

addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt
