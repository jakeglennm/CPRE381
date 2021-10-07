.data
array:	
	.word 4, 7, 12, 1, 23, 11, 21, 8, 16, 19	
	
	.text
	.globl main
main:
	la $s7, array #load base address
	addi $s0, $zero, 0 #use as i variable
	addi $s6, $zero, 9 #length of array - 1
	addi $s1, $zero, 0 #use as j variable
loop:
	sll $t7, $s1, 2
	add $t7, $s7, $t7 # get the address of A[j]
	lw $t0, 0($t7)  #A[j] is loaded into $t0	
	lw $t1, 4($t7)  #A[j+1]	is loaded into $t1
	slt $t2, $t0, $t1 #set #t2 to 1 if $t0 is less than $t1
	bne $t2, $zero, skipswap #skip swapping the values if $t2 is 1
	sw $t1, 0($t7)  #store $t1 in A[j]	
	sw $t0, 4($t7)  #store $t0 in A[j+1]	

skipswap:	
	addi $s1, $s1, 1 #increment j
	sub $s5, $s6, $s0 # N-i-1
	bne  $s1, $s5, loop
	addi $s0, $s0, 1 #increment i
	addi $s1, $zero, 0 #j
	bne  $s0, $s6, loop
	
end:	
	li   $v0, 10          # system call for exit
      	syscall               # Exit!
	
