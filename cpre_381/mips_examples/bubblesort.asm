.data
array:	
	.word 4, 7, 12, 1, 23, 11, 21, 8, 16, 19	
	
	.text
	.globl main
main:
	la $s7, array
	addi $s0, $zero, 0 #i
	addi $s6, $zero, 9 #N-1
	addi $s1, $zero, 0 #j
loop:
	sll $t7, $s1, 2
	add $t7, $s7, $t7 # got the address of A[j]
	lw $t0, 0($t7)  #$t0 is A[j]	
	lw $t1, 4($t7)  #$t1 is A[j+1]	
	slt $t2, $t0, $t1
	beq $t2, $zero, swap
	sw $t1, 0($t7)  #$t0 is A[j]	
	sw $t0, 4($t7)  #$t0 is A[j+1]	

swap:	
	addi $s1, $s1, 1
	sub $s5, $s6, $s0 #$s3 is N-i-1
	bne  $s1, $s5, loop
	addi $s0, $s0, 1 
	addi $s1, $zero, 0 #j
	bne  $s0, $s6, loop
	
done:	
	li   $v0, 10          # system call for exit
      	syscall               # Exit!
	
