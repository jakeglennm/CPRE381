    .globl main

main:

.data
	i: .byte 0  
	end: .word 100 
	sum: .byte 0  
	mod: .byte 5  

.text

lb $t0, i      
lb $t1, end      
lb $t2, sum     
lb $t3, mod    

Loop:     beq $t0, $t1, Exit    # while i <= 100, compute
          div $t0, $t3        # i mod 5
          mfhi $t6           # get mod value
          bne $t6, 0, Incre   # if mod != 0, jump over the add to increment
          add $t2, $t2, $t0   # sum += i
Incre:    add $t0, $t0, 1     # i++
          j Loop               # repeat the while loop


Exit:     li $v0, 1       # system call code to print integer
          move $a0, $t2       # move integer to be printed into $a0
          syscall 	   #output should be 950(values added from 0-100 not including 100)