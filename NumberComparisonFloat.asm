# Number Comparison Floating-Point - Patrick Kubiak - 11/9/2015
# Read up to 10 single percision floating-point numbers and ouput the floats greater than or equal to the last one entered.

        .data                           	# items stored in data segment
        .align 0                        	# no automatic alignment

numbers:
	.space 40				# 40 bytes = 10 words of space to store 10 floats

sentinel:
	.space 4				# store float sentinel
		
neg1:
	.float -1.0				# single percision floating-point -1.0

instructions:
	.asciiz "Displays numbers greater than or equal to the last one entered.\nEnter -1 to stop entering numbers.\n"

prompt1:                                	# label
        .asciiz "Enter up to 10 floats: "       # null-terminated string

output:                                					# label
	.asciiz "Numbers greater than or equal to last one entered: "	# null-terminated string

comma:                                		# label
	.asciiz ", "     			# null-terminated string
        
        .text                           	# items stored in text segment
        .globl main                     	# label accessible from other files
main:
	# make 10
	addi 		$t2, $zero, 10		# $t2 = 10
	
	# make 0
	addi		$a1, $zero, 0		# $a1 keeps track of how many numbers are entered
	
	# make sentinel $f1
	lwc1		$f1, neg1		# assign -1.0 to $f1
	la		$t0, sentinel		# load sentinel address to $t0
	swc1		$f1, 0($t0)		# store -1.0 in sentinel
	
	# display instructions
	la              $a0, instructions	# display the instructions string
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	# load numbers address
	la		$t0, numbers		# load numbers address to $t0
	
	j		prompt			# jump to prompt
	
prompt:
        # print prompt
	la              $a0, prompt1     	# print prompt
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	# get the input from user
        li              $v0, 6          	# service code to read float into $f0
        syscall                         	# perform service
	
	# load sentinel
	la		$t1, sentinel		# load sentinel address to $t0
	lwc1		$f1, 0($t1)		# load sentinel float to $f1
	
	# branch to display if user entered -1
	c.eq.s		$f0, $f1		# set Coproc1 condition flag 0 to true if input ($f0) equals sentinel ($f1), else false
	bc1t		display			# branch to display if condition flag 0 is true (input equals sentinel)
	
	# save last input if not sentinel
	mov.s		$f2, $f0		# store input float in $f2
	
	# store number
	addi		$a1, $a1, 1		# increment $a1 by 1, this is how many numbers we entered
	swc1		$f2, 0($t0)		# store input ($f2) at next space in numbers address
	addi		$t0, $t0, 4		# increment address of numbers ($t0) to store next number
	
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
	lwc1		$f1, 0($t1)		# read float from address $t1 to $f1
	
	c.lt.s		$f1, $f2		# if $f1 (current number) is less than $f2 (last number entered), then set Coproc 1 condition flag 0 to true, else false
	bc1f		display3		# branch if current number is greater than or equal to last number entered
	j		display4
	
display3:
	# display number at $f1
	mov.s		$f12, $f1		# move number to display ($f1) to $f12
	li		$v0, 2			# service code to print float
	syscall					# perform service
        
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
