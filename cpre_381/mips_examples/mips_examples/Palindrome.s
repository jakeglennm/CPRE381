#   Palindrome
##  Original author:  Daniel J. Ellard   -- 02/21/94
##  Register usage:
##     $t1     - lower array pointer, A
##     $t2     - upper array pointer, B
##     $t3     - character at address A
##     $t4     - character at address B
##     $v0     - syscall parameter / return value
##     $a0     - syscall parameters
##     $a1     - syscall parameters

	.data
string_space:       .space 1024
is_palindrome_msg:  .asciiz "The string is a palindrome.\n"
not_palindrome_msg: .asciiz "The string is not a palindrome.\n"

	.text
main:
        ## read the character string into string_space
	la      $a0, string_space
	li      $a1, 1024
	li      $v0, 8
	syscall
	
	la      $t1, string_space     # lower array pointer = array base
	la      $t2, string_space     # start upper pointer at beginning
	
length_loop:
	lb      $t3, ($t2)            # grab the character at upper ptr
	beqz    $t3, end_length_loop  # if $t3 == 0, we're at the terminator
	addi    $t2, $t2, 1           # increment upper array pointer
	b       length_loop           # repeat the loop
end_length_loop:

	subi    $t2, $t2, 2           # move upper pointer back to last charcter
	
test_loop:
	bge     $t1, $t2, is_palin    # if lower pointer >= upper pointer, yes
	
	lb      $t3, ($t1)            # grab the character at lower ptr
	lb      $t4, ($t2)            # grab the character at upper pointer
	bne     $t3, $t4, not_palin   # if different, it's not a palindrome
	
	addi    $t1, $t1, 1           # increment lower ptr
	subi    $t2, $t2, 1           # decrement upper ptr
	b       test_loop             # repeat the loop
	
is_palin:
	la	$a0, is_palindrome_msg  # print the is-palindrome message
	li      $v0, 4
	syscall
	b	exit
	
not_palin:
	la	$a0, not_palindrome_msg # print the not-palindrome message
	li	$v0, 4
	syscall
	b	exit
	
exit:
	li	$v0, 10
	syscall

# END OF PROGRAM
