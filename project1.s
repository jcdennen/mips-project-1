#################################################
## project1.s
## Author: Jeremy Dennen
## MergeSort and Merge functions implemented with MIPS Assembly
## For CIS 341 Project 1
#################################################
## Questions:
## Should I be using add or addi in merge?
## How do I use the Helper Array
##
##
#################################################
	.data
Array:		.word	56,3,46,47,34,12,1,5,10,8,33,25,29,31,50,43
Length:		.word	16
ArrayM:		.word	1,4,7,10,25,3,5,13,17,21
LengthM:	.word	10
ArrayC:		.word	0:49		# why not 0:50?

	.text
## main function
## calls merge on ArrayM for Problem 1
## calls full merge_sort funciton on Array for Problem 2
main:
	addi $sp, $sp, -4			# make room for 1 register
	sw $ra, 0($sp)				# save $ra on stack

	la $a0, ArrayM 				# loads ArrayM into an a register
	li $a1, 0					# store low value in a0 : 0
	li $a2, 9					# store high value in a2 : length of ArrayM -1
	li $a3, 4 					# store mid value in a3 : 4
	jal merge 					# jump and link to merge function

    lw $ra, 0($sp)				#
    add $sp, $sp, 4 		 	# restore stack	
    jr $ra 						#
#################################################
## merge_sort function
#################################################
merge_sort:
								# Allocate memory for mid?
	slt $t_, low, high			# use the right registers (if (low<high))
	bne $t_, $zero, ms_block	# jump to ms_block if low<high
	jr  $ra						# return statement (should I be using exit_merge_sort label?)

## merge_sort conditional/logic check (simple if statement passed)
ms_block:
#add mid, low, high
#divi mid, 2 ???
#store values low and mid, then call merge_sort
#store values mid+1 and high, then call merge_sort
#store values low, high, and mid, then call merge
	jr $ra						#return statement

#################################################
## merge function
#################################################
merge:
	add $t0, $zero, $a1 		# i = low = $t0
	add $t1, $zero, $a1			# k = low = $t1
	addi $t2, $a3, 1			# j = mid + 1 = $t2
	#ArrayC
	jal mlc_1_1					# jump to first logic check

## merge logic check 1.1 : while (i<=mid && j<=high) pt 1
mlc_1_1:
	sle $t4, $t0, $a3			# (i<=mid) 
	bne $t4, $zero, mlc_1_2 	# if true, jump to while pt 2
	jal	mlc_2					# if false, jump to second while loop

## merge logic check 1.2 : while (i<=mid && j<=high) pt 2
mlc_1_2:
	sle $t4, $t2, $a2			# (j<=high)
	bne $t4, $zero, mlc_1_3 	# if true, jump to if/else statement
	jal mlc_1_2 				# if false, jump to second while loop

## merge logic check 1.3 (if/else statement) : else
mlc_1_3:
	slt $t4, $t0($a0), $t2($a0) # a[i] < a[j] TODO: check array access and assignment
	bne $t4, $zero, mlc_1_4 	# if true, jump to if
	move $t1(ArrayC), $t2($a0) 	# c[k] = a[j] TODO: check array access and assignment
	addi $t1, $t1, 1 			# k++
	addi $t2, $t2, 1 			# j++
	jal mlc_1_1 				# continue while loop

## merge logic check 1.4 (if/else statement) : if
mlc_1_4:
	move $t1,(ArrayC), $t0($a0)	# c[k] = a[i] TODO: check array access and assignment
	addi $t1, $t1, 1 			# k++
	addi $t0, $t0, 1 			# i++
	jal mlc_1_1 				# continue while loop	

## merge logic check 2 (2nd while loop)
mlc_2:
	sle $t4, $t0, $a3			# (i <= mid)
	bne $t4, $zero, mlc_3 		# if (i > mid) jump to next while
	move $t1,(ArrayC), $t0($a0)	# c[k] = a[i] TODO: check array access and assignment
	addi $t1, $t1, 1 			# k++
	addi $t0, $t0, 1 			# i++
	jal mlc_2					# continue while loop

## merge logic check 3 (3rd while loop)
mlc_3:
	sle $t4, $t2, $a2 			# (j<=high)
	bne $t4, $zero, mlc_4_1 	# if false, jump to for loop
	move $t1(ArrayC), $t2($a0) 	# c[k] = a[j] TODO: check array access and assignment
	addi $t1, $t1, 1 			# k++
	addi $t2, $t2, 1 			# j++
	jal mlc_3					# continue while loop

## merge logic check 4.1 (for loop) : initial i assignment
mlc_4_1:
	add $t0, $zero, $a1 		# (i = low)
	jal mlc_4_2 				# TODO: is this necessary???

## merge logic check 4.2 (for loop) : body
mlc_4_2:
	slt $t4, $t0, $t1 					# (i < k)
	beq $t4, $zero, merge_quit 			# if (i >= k) then quit
	add $t0($a0), $zero, $t0(ArrayC)	# a[i] = c[i] TODO: check array access and assignment
	addi $t0, $t0, 1 					# i++

## quit the merge function & return to the function that called it
merge_quit:
	jr $ra 						#return



