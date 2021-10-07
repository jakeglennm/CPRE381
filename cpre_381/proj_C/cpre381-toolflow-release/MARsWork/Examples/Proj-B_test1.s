addiu $a2, $zero, 0x000F
addu $a3, $a2, $a2
and $a0, $a0, $a1
andi $a0, $a0, 0x000F
lui $a0, 0x1001
sw $a0, 0($a0)
lw $a1, 0($a0)
addi $a0, $zero, 5
slt $a0, $zero, $a0
addi $a0, $zero, 5
addi $a1, $zero, 1
sub $a0, $a0, $a1
subu $a0, $a0, $a1
nor $a1, $zero, $a0
xor $a1, $zero, $a0
xori $a1, $zero, 0x00FF
or $a1, $zero, $a0
ori $a0, $zero, 0x00FF
addi $a0, $zero, 5
sll $a0, $a0, 2
srl $a0, $a0, 2
addi $a1, $zero, 2
sllv $a0, $a0, $a1
srlv $a0, $a0, $a1
addi $a0, $zero, 5
addi $a1, $zero, 1
sra $a0, $a0, 1
srav $a0, $a0, $a1
slti $a0, $zero, 0x0001
sltiu $a0, $zero, 0x0001
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
addi $a0, $a0 0x00D0
jr $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
add $a0, $a0, $a0
li   $v0, 10          # system call for exit
syscall               # Exit!
