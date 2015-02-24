#################################################
## project1.s
## Author: Jeremy Dennen
## MergeSort and Merge functions implemented with MIPS Assembly
## For CIS 341 Project 1
#################################################

	.data
Array:		.word	56,3,46,47,34,12,1,5,10,8,33,25,29,31,50,43
Length:		.word	16
ArrayM:		.word	1,4,7,10,25,3,5,13,17,21
LengthM:	.word	10
ArrayC:		.word	0:49		#why not 0:50?


	.text
## main function
## calls merge on ArrayM for Problem 1
## calls full merge_sort funciton on Array for Problem 2
main:
	addi $sp, $sp, -20			#make room for 5 registers
	sw $ra, 16($sp)				#save $ra on stack
	sw $s3, 12($sp) 			#save $s3 on stack
	sw $s2, 8($sp) 				#save $s2 on stack
	sw $s1, 4($sp) 				#save $s1 on stack
	sw $s0, 0($sp) 				#save $s0 on stack

	la $t0, Array 				#
	la $t1, 0					#
	la $t2, 15					#$t2 holds length of array -1

## merge_sort function
merge_sort:
								#Allocate memory for mid?
	slt $t_, low, high			#use the right registers (if (low<high))
	bne $t_, $zero, ms_block	#jump to ms_block if low<high
	jr  $ra						#return statement (should I be using exit_merge_sort label?)

## merge_sort conditional/logic check (simple if statement passed)
ms_block:
#add mid, low, high
#divi mid, 2 ???
#store values low and mid, then call merge_sort
#store values mid+1 and high, then call merge_sort
#store values low, high, and mid, then call merge
	jr $ra						#return statement

## merge function
merge:
#i = low
#k = low
#j = mid + 1
	jal mlc_1_1					#jump to first logic check

## merge logic check 1.1 : while (i<=mid && j<=high) 1st part
mlc_1_1:
	sle $t_, i, mid				#use right registers (i<=mid) 
	bne $t_, $zero, mlc_1_2 	#
	jal	mlc_1_2						

## merge logic check 1.2 : while (i<=mid && j<=high) 2nd part
mlc_1_2:

## merge logic check 1.3 (if/else statement)
mlc_1_2:

## merge logic check 2
mlc_2:

## merge logic check 3
mlc_3:

## merge logic check 4 (for loop)
mlc_4:

exit_merge_sort:
	jr $ra 				#return statement

