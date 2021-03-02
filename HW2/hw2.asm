.data
getArraySizeText: .asciiz "Please enter the array size: \n"
getNumText: .asciiz "Please enter the target number: \n"
getArrayNumbersText: .asciiz "Please enter elements of the array: \n"
functionCalledText: .asciiz "Number of function calls: "
possibleText: .asciiz "\nPossible!\n"
notPossibleText: .asciiz "\nNot Possible!\n"
newline: .asciiz "\n"
Array: .word 100					# int array[MAX_SIZE=100]

.text
main:
	# Get ArraySize
	# cin >> arraySize;
	la $a0, getArraySizeText		# $a0 = "Please enter the array size: \n"
	jal printStr					# print string in the $a0
	jal getNum						# get number and load $v0
	move $s0, $v0					# move $v0 to $s0
	
	# Get num
	# cin >> num;
	la $a0, getNumText				# $a0 = "Please enter the target number: \n"
	jal printStr					# print string in the $a0	
	jal getNum						# get number and load $v0
	move $s1, $v0					# move $v0 to $s1
	
	# Get elements of the array
	# for(int i=0;i<arraySize;++i){ cin >> arr[i]; }
	move $s2, $zero					# i = 0; 
	move $s3, $zero					# index
for1:
	slt $t0, $s2, $s0   			# if i >= arraySize, then $t0 = 0
	beq $t0, $zero, exit1			# if i >= arraySize, then go to exit1
	la $a0, getArrayNumbersText		# $a0 = "Please enter elements of the array: \n"
	jal printStr					# print string in the $a0
	jal getNum						# get number and load $v0
	sw $v0, Array($s3)				# move $v0 to array[$s3]
	addi $s3, $s3, 4				# $s3 = $s3 + 4
	addi $s2, $s2, 1				# $s2 = $s2 + 1
	j for1							# jump for1
	
exit1:
	move $a0, $s0					# $a0 = arraySize
	move $a1, $s1					# $a1 = targetNumber
	move $a2, $zero					# $a2 = number of function call
	jal checkSumPossibility			# call the checkSumPossibility procedure
	
possible:
	beq $v0, 0,	notPossible			# if $v0 = 0, then go to notPossible label
	la $a0, possibleText			# $a0 = "\nPossible\n"
	jal printStr					# print string in the $a0
	la $a0, functionCalledText		# $a0 = "Number of function calls: "
	jal printStr					# print string in the $a0
	move $a0,$a2					# $a0 = number of function calls
	jal printNum					# print num in the $a0
	la $a0, newline					# $a0 = "\n"
	jal printStr					# print string in the $a0
	j exit							# call the exit procedure
	
notPossible:
	la $a0, notPossibleText			# $a0 = "\nNot Possible\n"			
	jal printStr					# print string in the $a0
	la $a0, functionCalledText		# $a0 = "Number of function calls: "
	jal printStr					# print string in the $a0
	move $a0,$a2					# $a0 = number of function calls
	jal printNum					# print num in the $a0
	la $a0, newline					# $a0 = "\n"
	jal printStr					# print string in the $a0
	j exit							# call the exit procedure

# Procedure getting number
getNum: 
	li $v0, 5						# $v0 = 5
	syscall							# call the read_int (because $v0 = 5)
	jr $ra							# return
	
# Procedure printing number
printNum:	
	li $v0, 1						# $v0 = 1
	syscall							# call the print_int (because $v0 = 1)
	jr $ra							# return
	
# Procedure printing string
printStr:
	li $v0, 4						# $v0 = 4
	syscall							# call the print_string (because $v0 = 4)
	jr $ra							# return
	
# Procedure exit
exit:
	li $v0, 10						# $v0 = 10
	syscall							# call the exit (because $v0 = 10)
	jr $ra							# return
	
# Procedure CheckSumPossibility
checkSumPossibility:
	addi $sp, $sp, -12					# allocate 12 bytes
	sw $a0, 0($sp)						# save arraySize
	sw $a1, 4($sp)						# save target number
    sw $ra, 8($sp)						# save ra register 
        
    # Base Case
	beq $a0, $zero, recursive_exit2		# if size == 0, then go to exit2 
	blt $a1, $zero, recursive_exit2		# if num < 0, then go to exit2
	beq $a1, $zero, recursive_exit3		# if num == 0, then go to exit3

	addi $a2, $a2, 1					# Function call counter
	
    # Recursive Step 1
	sll $s0, $a0, 2						# $s0 = $a0(size)*4
	addi $s0, $s0, -4					# $s0 = $s0 - 4
	lw $s1, Array($s0)					# $s1 = array[size-1]
	sub $s1, $zero, $s1					# $s1 = -array[size-1]
	add $a1, $a1, $s1					# num = num-arr[size-1]
	addi $a0, $a0, -1					# size = size-1 
	jal checkSumPossibility				# recursive call
	lw $a0, 0($sp)						# restore the saved size
	lw $a1, 4($sp)						# restore the saved target number
	move $t0, $v0						# x = returned value(0 or 1)
	beq $t0, 1, recursive_exit3			# if x == 1, return 1
	
	# Recursive Step 2
	addi $a0, $a0, -1					# size = size-1
	jal checkSumPossibility				# recursive call
	lw $a0, 0($sp)						# restore the saved size		
	move $t1, $v0						# y = returned value(0 or 1)	
	beq $t1, 1, recursive_exit3			# if y == 1, return 1

	or $v0, $t0, $t1					# z = x || y
	j recursive_exit					# go to recursive_exit
		
recursive_exit:
	or $v0, $t0, $t1					# $v0 = x || y
	lw $a0, 0($sp)						# restore the saved size
	lw $a1, 4($sp)						# restore the saved target number
    lw $ra, 8($sp)						# restore the saved ra register
    addi $sp, $sp, 12					# deallocate 12 bytes
    jr $ra								# return x || y
    
recursive_exit2:
	or $v0, $t0, $t1					# $v0 = x || y
	lw $a0, 0($sp)						# restore the saved size
	lw $a1, 4($sp)						# restore the saved target number
    lw $ra, 8($sp)						# restore the saved ra register				
    addi $sp, $sp, 12					# deallocate 12 bytes
    jr $ra								# return x || y
    
recursive_exit3:
	li $v0, 1							# $v0 = 1
	lw $a0, 0($sp)						# restore the saved size
	lw $a1, 4($sp)						# restore the saved target number
    lw $ra, 8($sp)						# restore the saved ra register
    addi $sp, $sp, 12					# deallocate 12 bytes
    jr $ra								# return 1
