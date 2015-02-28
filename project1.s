#################################################
## project1.s
## Author: Jeremy Dennen
## MergeSort and Merge functions implemented with MIPS Assembly
## For CIS 341 Project 1
#################################################
## Questions:
## There is a set if less than or equal function..?
##
#################################################
## TODO:
##
## ADD merge_sort function call
## ADD merge_sort function body
#################################################
	.data
Newline: 	.asciiz "\n"
Tab: 		.asciiz "\t"

Array:		.word	56,3,46,47,34,12,1,5,10,8,33,25,29,31,50,43
Length:		.word	16
ArrayM:		.word	1,4,7,10,25,3,5,13,17,21
LengthM:	.word	10
ArrayC:		.word	0:50		# why not 0:50?

	.text
#################################################
## main function
## calls merge on ArrayM for Problem 1
## calls full merge_sort funciton on Array for Problem 2
#################################################
main:
	addi    $sp, $sp, -4			# make room for 1 register
	sw      $ra, 0($sp)				# save return address on stack

	la      $a0, ArrayM 			# loads ArrayM into an a register
	li      $a1, 0					# store low value in a0 : 0
	li      $a2, 9					# store high value in a2 : length of ArrayM -1
	li      $a3, 4 					# store mid value in a3 : 4
	jal     print_array             # print unsorted array

	la      $a0, ArrayM 			# loads ArrayM into an a register
	li      $a1, 0					# store low value in a0 : 0
	li      $a2, 9					# store high value in a2 : length of ArrayM -1
	li      $a3, 4 					# store mid value in a3 : 4
	jal     merge 					# jump and link to merge function

    la      $a0, ArrayM 			# loads ArrayM into an a register
	li      $a1, 0					# store low value in a0 : 0
	li      $a2, 9					# store high value in a2 : length of ArrayM -1
	li      $a3, 4 					# store mid value in a3 : 4
    jal     print_array             # print sorted array

    la      $a0, Array
    li      $a1, 0                  # low value
    li      $a2, 15                 # high value
    li      $a3, 7                  # mid value
    jal     print_array             # print unsorted array

    la      $a0, Array              # Array for merge_sort
    li      $a1, 0                  # low value
    li      $a2, 15                 # high value
    li      $a3, 7                  # mid value
    jal     merge_sort              # calls merge_sort

    la      $a0, Array
    li      $a1, 0                  # low value
    li      $a2, 15                 # high value
    li      $a3, 7                  # mid value
    jal     print_array             # print sorted array

    lw      $ra, 0($sp)             # restore stack
    add     $sp, $sp, 4

    ## system exit
    li      $v0, 10
    syscall

#################################################
## merge_sort function
#################################################
merge_sort:
	slt     $t4, $a1, $a2			# use the right registers (if (low<high))
	bne     $t4, $zero, ms_block	# jump to ms_block if low<high
	jr      $ra						# return statement

## merge_sort block (if statement success)
ms_block:
    add     $t1, $a1, $a2           # use $t1 for temp storing mid
    srl     $a3, $t1, 1             # mid((high+low)/2)
	add     $t2, $zero, $a2 		# tempoarily store high in $t2
	add     $a2, $zero, $a3			# store value for mid in high
	jal     merge_sort				# then call merge_sort ($a0(Array), $a1(low), $a2(mid))

	add     $t3, $zero, $a3         # store value for mid in $t3
    addi    $t3, $t3, 1             # mid + 1
    add     $t4, $zero, $a1         # temporarily store low in $t4
    add     $a1, $zero, $t3         # store value for mid+1 in low
	add     $a2, $zero, $t2         # restore high's value
    jal     merge_sort              # then call merge_sort ($a0(Array), $a1(mid+1), $a2(high))

    add     $a1, $zero, $t4         # restore low's value
    jal     merge                   # then call merge
	jr $ra                          # return statement

#################################################
## merge function
#################################################
merge:
	add     $t0, $zero, $a1 		# i = low = $t0
	add     $t1, $zero, $a1			# k = low = $t1
	addi    $t2, $a3, 1             # j = mid + 1 = $t2
	la      $t3, ArrayC             # ArrayC = $t3

	j       mlc_1_1					# jump to first logic check

## merge logic check 1.1 : while (i<=mid && j<=high) pt 1
mlc_1_1:
	slt     $t4, $a3, $t0			# (mid<i)
	bne     $t4, $zero, mlc_1_2 	# if false, jump to while pt 2
	j       mlc_2					# if true, jump to second while loop

## merge logic check 1.2 : while (i<=mid && j<=high) pt 2
mlc_1_2:
	slt     $t4, $a2, $t2			# (high<j)
	bne     $t4, $zero, mlc_1_3 	# if false, jump to if/else statement
	j       mlc_2                   # if true, jump to second while loop

## merge logic check 1.3 (if/else statement) : else
mlc_1_3:

    ## $t5 = a[i]
    sll     $t5, $t0, 2
    add     $t5, $a0, $t5
    lw      $t5, 0($t5)

    ## $t6 = a[j]
    sll     $t6, $t2, 2
    add     $t6, $a0, $t6
    lw      $t6, 0($t6)

	slt     $t4, $t5, $t6           # a[i] < a[j]
	bne     $t4, $zero, mlc_1_4 	# if true, jump to if block

    sll     $t7, $t1, 2             # otherwise compute else block
    add     $t7, $t3, $t7
    sw      $t6, 0($t7)             # c[k] = a[j]
    addi    $t1, $t1, 1             # k++
    addi    $t2, $t2, 1             # j++

	j       mlc_1_1 				# continue while loop

## merge logic check 1.4 (if/else statement) : if
mlc_1_4:
    sll     $t7, $t1, 2
    add     $t7, $t3, $t7
    sw      $t5, 0($t7)             # c[k] = a[i]
    addi    $t1, $t1, 1             # k++
    addi    $t0, $t0, 1             # i++

	j       mlc_1_1 				# continue while loop

## merge logic check 2 (2nd while loop)
mlc_2:
    ## $t5 = a[i]
    sll     $t5, $t0, 2
    add     $t5, $a0, $t5
    lw      $t5, 0($t5)

	slt     $t4, $a3, $t0			# (mid<i)
	bne     $t4, $zero, mlc_3 		# if (i > mid) jump to next while

	sll     $t7, $t1, 2
    add     $t7, $t3, $t7
    sw      $t5, 0($t7)             # c[k] = a[i]
	addi    $t1, $t1, 1 			# k++
	addi    $t0, $t0, 1 			# i++

	j       mlc_2					# continue while loop

## merge logic check 3 (3rd while loop)
mlc_3:
    ## $t6 = a[j]
    sll     $t6, $t2, 2
    add     $t6, $a0, $t6
    lw      $t6, 0($t6)

	slt     $t4, $a2, $t2 			# (high<j)
	bne     $t4, $zero, mlc_4_1 	# if true, jump to for loop

    sll     $t7, $t1, 2
    add     $t7, $t3, $t7
    sw      $t6, 0($t7)             # c[k] = a[j]
	addi    $t1, $t1, 1 			# k++
	addi    $t2, $t2, 1 			# j++

	j       mlc_3					# continue while loop

## merge logic check 4.1 (for loop) : initial i assignment
mlc_4_1:
	add     $t0, $zero, $a1 		# (i = low)

## merge logic check 4.2 (for loop) : body
mlc_4_2:
	slt     $t4, $t0, $t1 			# (i < k)
	beq     $t4, $zero, merge_quit 	# if (i >= k) then quit

    ## $t5 = a[i]
    sll     $t5, $t0, 2
    add     $t5, $a0, $t5
    lw      $t5, 0($t5)             # $t5 = a[i]

    # $t6 = c[i]
    sll     $t6, $t0, 2
    add     $t6, $t3, $t6
    lw      $t6, 0($t6)             # $t6 = c[i]
	addi    $t0, $t0, 1 			# i++

## quit the merge function & return to the function that called it
merge_quit:
	jr      $ra 					#return

#################################################
## print function
#################################################
print_array:
	addi    $t0, $zero, 0
	add     $t6, $zero, $a0
	add     $t7, $zero, $a2

loop_print:
	slt     $t1, $t0, $t7
	beq     $t1, $zero, exit_loop_print

	sll     $t3, $t0, 2
	add     $t2, $t6, $t3 					# Array[$t1*4]
	lw      $a0, 0($t2)
	li,     $v0, 1
	syscall

	addi    $v0, $zero, 4
	la      $a0, Tab
	syscall

	addi    $t0, $t0, 1

	j loop_print

exit_loop_print:
	addi $v0, $zero, 4
	la $a0, Newline
	syscall
	jr $ra


