.data
 user_input : .asciiz "Enter integer: "
 new_line : .asciiz "\n"
 asterisk : .asciiz "*"
 
.text
 li $v0, 4 #syscall to print string
 la $a0, user_input #display message to user
 syscall
 li $v0, 5 #reading number from user
 syscall
 move $t2, $v0 # $t2 = user input(number of lines/asterisks on final line)
 li $t0, 0 #$t0 = number of asterisks printed per line
 li $t1, 1 #$t1 = number of lines printed
 
 fill_line:    #fill line with asterisks until you reach value of $t1 which increments after every line while #t0 gets reset
 li $v0, 4
 la $a0, asterisk #load $a0 with the '*' and then print it
 syscall
 addi $t0, $t0, 1 #increment how many asterisks have been printed
 beq $t0, $t1, print_new_line 
 j fill_line #repeat fill_ line loop
 
 print_new_line:
 li $v0, 4 
 la, $a0, new_line #load $ao with "\n" 
 syscall
 beq $t1, $t2, exit #exit if number of new_lines printed is equal to integer entered by user
 li $t0, 0 #update value of asterisks printed on new_line for next loop
 addi $t1, $t1, 1 #update value of lines printed thus far
 j fill_line #jump back to fill_line loop
 
 exit:
 li $v0, 10 #syscall for exiting
 syscall
