.data
str1: .asciiz "Please enter a number:\n"
.text
.globl main
main:
# Start program
addi $s1, $zero, 0 # s1 is ouput value
addi $s0, $zero, 2 # s0 is loop counter
inputs:
# Request some user input:
li $v0, 4
la $a0, str1
syscall
# Read some user input:
li $v0, 5
syscall
# Do some arithmetic:
add $s1, $s1, $v0
# Handle loop control flow:
addi $s0, $s0, -1
bne $s0, $zero, inputs # read more inputs when count is not zero
# Shift right to divide by 2
srl $s1, $s1, 1
# Print output
li $v0, 1
addi $a0, $s1, 0
syscall
# Exit program
li $v0, 10
syscall
