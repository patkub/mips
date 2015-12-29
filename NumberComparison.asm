# Number Comparison - Patrick Kubiak - 9/30/2015
# Read up to 10 integers and ouput the integers greater than or equal to the last one entered.

        .data                           	# items stored in data segment
        .align 0                        	# no automatic alignment

numbers:
	.space 40				# 40 bytes = 10 words of space to store 10 integers
	
sentinel:
	.space 4				# declare 4 bytes of storage to hold integer sentinel

instructions:
	.asciiz "Displays numbers greater than or equal to the last one entered.\nEnter -1 to stop entering numbers.\n"

prompt1:                                	# label
        .asciiz "Enter up to 10 integers: "     # null-terminated string

output:                                					# label
	.asciiz "Numbers greater than or equal to last one entered: "	# null-terminated string

comma:                                		# label
	.asciiz ", "     			# null-terminated string
        
        .text                           	# items stored in text segment
        .globl main                     	# label accessible from other files
main:
	# make -1
	addi 		$t0, $zero, -1		# $t0 = -1
	
	# make 10
	addi 		$t2, $zero, 10		# $t2 = 10
	
	# make 0
	addi		$a1, $zero, 0		# keep track of how many numbers are entered
	
	# assign -1 to sentinel
        la		$t1, sentinel		# load sentinel address to $t1
        sw 		$t0, 0($t1)		# set sentinel ($t1) to -1 ($t0)
	
	la		$t0, numbers		# load numbers address to $t0
	
	# display instructions
	la              $a0, instructions	# display the instructions string
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	j		prompt			# jump to prompt
	
prompt:
        # print prompt
	la              $a0, prompt1     	# print prompt
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	# get the input from user
        li              $v0, 5          	# service code for read integer
        syscall                         	# perform service
	
	# branch to display if user entered -1
	la		$t1, sentinel		# load sentinel address to $t1
        lw		$a0, 0($t1)		# set $a0 to sentinel
	beq		$v0, $a0, display	# no more input
	
	# save input if not sentinel
	move            $a2, $v0        	# save the input to $a2 (last number entered)
	
	# store number
	addi		$a1, $a1, 1		# increment $a1 by 1, this is how many numbers we entered
	sw		$a2, 0($t0)		# add $a2 to numbers ($t0)
	addi		$t0, $t0, 4		# increment address of numbers ($t0) to store next number.
	
	# branch if numbers entered is 10
	slt		$t1, $a1, $t2		# if $a1 (numbers entered count) is less than $t2 (10), then set $t1 to 1 else set $t1 to 0
	beq		$t1, $zero, display	# $t1 is 0 if numbers entered is $t2 (10), display output
	
	j		prompt			# ask for next number
	
display:
        # display output
        addi		$a3, $zero, 0		# store count of numbers displayed
        
        # display output string
	la              $a0, output	   	# display the output string
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        # display numbers
        la		$t1, numbers		# load numbers address to $t1
        
	j		display2
	
display2:
	beq		$a3, $a1, exit		# exit if count of numbers displayed ($a3) equals count of numbers entered ($a1)
	
	lw		$t3, 0($t1)		# read the number from address ($t1) into register $t3
	
	slt		$t2, $t3, $a2 		# if $t3 (current number) is less than $a2 (last number entered), then set $t2 to 1 else set $t2 to 0
	beq		$t2, $zero, display3	# $t2 is 0 if current number is greater than last number entered
	j		display4
	
display3:
	# display number at $t1
	lw		$a0, 0($t1)		# load number at $t1
	li              $v0, 1          	# service code for print integer
        syscall                         	# perform service
        
        # display comma
        la              $a0, comma    		# display comma
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	j		display4
display4:        
        # increment count
        addi		$t1, $t1, 4		# increment address of numbers ($t1) to read next number.
      	addi		$a3, $a3, 1		# increment count of numbers read ($a3)
        
	j		display2

exit:
        # exit code
        li              $v0, 10         	# service code for exit
        syscall                         	# perform service
