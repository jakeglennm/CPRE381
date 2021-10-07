add $a0, $zero, $zero
addi $a1, $zero, 0x000F
beq $zero, $zero, Test
addi $a0, $a0, 0x0001
addi $a0, $a0, 0x0001
Test: addi $a0, $a0, 0x0001
bne $a1, $a0, Test
j Jumptest
addi $a0, $a0, 0x0001
Jumptest: addi $a0, $a0, 0x0001
li   $v0, 10          # system call for exit
syscall               # Exit!