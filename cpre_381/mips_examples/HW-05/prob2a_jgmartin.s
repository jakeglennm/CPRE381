.data
   arrayOne: .byte '0','1','0','9'
   arrayTwo: .byte '1','0','9','0'
   length: .word 4

.text
  la $a1, arrayOne
  la $a2, arrayTwo
  lw $a3, length
  add $s0, $zero, $zero #sum
  add $t1, $zero, $zero #i

loop:
  add $t3, $a1, $t1 #a[i]
  lb $t3, 0($t3)
  add $t4, $a2, $t1 #b[i]
  lb $t4, 0($t4)
  sub $t5, $t3, $t4 #a - b
  jal abs
  add $s0, $s0, $t6 
  addi $t1, $t1, 1
  bne $t1, $a3, loop
  j end
  
abs:
        move $t6,$t5      #copy r1 into r2
        slt $t7, $t6, $zero      #is value < 0 ?
        beq $t7, $zero, pos #if r1 is positive, skip next inst
        sub $t6, $zero, $t5      #r2 = 0 - r1
pos:
jr $ra #r2 now contains the absolute value of r1

end: 
li $v0 1
move $a0, $s0
syscall

	
