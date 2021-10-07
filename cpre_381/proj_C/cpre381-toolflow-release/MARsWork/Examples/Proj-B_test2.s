beq $zero, $zero, beqTest
addi $a0, $a0, 0xFFFF
beqTest: addi $a0, $a0, 0x00F0
bne $zero, $zero, bneTest
addi $a0, $a0, 0x0001
bneTest: addi $a0, $a0, 0x00F0
add $a0, $zero, $zero
j Skip
addi $a0, $a0, 0x00F0
Skip: addi $a0, $a0, 0x0001
jal Skip2
addi $a0, $a0, 0x00F0
Skip2: addi $a0, $a0, 0x0001
lui $a0, 0x0040
addi $a0, $a0 0x0050
jr $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
	li   $v0, 10          # system call for exit
      	syscall               # Exit!
