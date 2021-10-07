# 
      .data
Size: .word 10
Vals: .word 78, 23, 41, 55, 18, 37, 81, 49, 74, 62

      .text
main: 
      lw    $s7, Size                # $s7 is the array size
      li    $s0, 4                   # word size
      mul   $s7, $s7, $s0            # calculate offset to end of array

      la    $s0, Vals                # $s0 points to current array element
      add   $s7, $s7, $s0            # calculate stop address
      lw    $s1, ($s0)               # initial max value is 0-th element
      addi  $s0, $s0, 4              # step pointer to next element

loop: bge   $s0, $s7, done           # see if we're past the array end
      lw    $s2, ($s0)               # get next array element
      bge   $s1, $s2, foo            # no new max
      move  $s1, $s2                 # reset max
foo:  addi  $s0, $s0, 4              # step pointer to next element
      j     loop

done: li    $v0, 1                   # print the result
      move  $a0, $s1
      syscall

exit: li    $v0, 10                  # terminate the program
      syscall
