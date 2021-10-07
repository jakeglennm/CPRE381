# Simple procedure call example expanded from P&H

	.data	# Data declaration section
	prompt: .asciiz "Enter an integer value\n"
	
	.text
main:		# Start of code section
        jal     get_integer   # get the four inputs from the user
	move    $s0, $v0
        jal     get_integer
	move    $s1, $v0
        jal     get_integer
	move    $s2, $v0
        jal     get_integer
	move    $s3, $v0
	
	move    $a0, $s0
        li      $v0, 1	      # system call code for print_int
        syscall		      # print it
	
	move    $a0, $s0      # position the parameters
	move    $a1, $s1
	move    $a2, $s2
	move    $a3, $s3
	jal     proc_example  # make the call
	
	move    $t7, $v0
	
	move    $a0, $s0
        li      $v0, 1	      # system call code for print_int
        syscall		      # print it
	
	move    $a0, $t7
        li      $v0, 1	      # system call code for print_int
        syscall		      # print it

        j       exit

get_integer:
################################################### get_integer
# Prompts user for an integer, reads it, returns it.
#
# Parameters:
#   none
#
# Pre:       a global string, labeled "prompt" must exist
# Post:      $v0 contains the value entered by the user
# Returns:   value entered by the user
# Called by: main
# Calls:     none
#
        li $v0, 4	# system call code for printing string = 4
        la $a0, prompt	# address of string is argument to print_string
        syscall		# call operating system to perform print operation

        li $v0, 5	# get ready to read in integers
        syscall		# system waits for input, puts the value in $v0

        jr      $ra
	
proc_example:
################################################### get_integer
# Computes and returns (a + b) - (c + d).
#
# Parameters:  $a0 - $a3
#
# Pre:       $a0 = a, $a1 = b, $a2 = c, $a3 = d
# Post:      $v0 contains (a + b) - (c + d)
# Returns:   value (a + b) - (c + d)
# Called by: main
# Calls:     none
#
        addi    $sp, $sp, -4    # adjust stack pointer to make room for 1 item
	sw      $s0, 0($sp)     # save the value that was in $s0 at the call

	add     $t0, $a0, $a1   # $t0 = a + b
	add     $t1, $a2, $a3   # $t1 = c + d
	sub     $s0, $t0, $t1   # $s0 = (a + b) - (c + d)

	move    $v0, $s0        # put return value into $v0

	lw      $s0, 0($sp)     # restore value of $s0
	addi    $sp, $sp, 12    # restore the stack pointer

	jr      $ra             # jump back to the return address

exit:   
	li	     $v0, 10
	syscall


# END OF PROGRAM
