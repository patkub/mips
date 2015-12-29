        .data                           # items stored in data segment
        .align 0                        # no automatic alignment

sentinel:
	.float -1.0			# store -1.0 in memory
sum:
        .space 4
floatIn:				# label
	.asciiz "Enter the floating-point number: "  # null-terminated string
inputs:                                 # label
        .asciiz "\nEnter first number: "  # null-terminated string
inputs2:                                # label
        .asciiz "Enter second number: "  # null-terminated string
outputs:                                # label
        .asciiz "The first number input is " 	# null-terminated string
outputs2:                                # label
        .asciiz "\nThe second number input is " 	# null-terminated string  
floatOut:                                # label
        .asciiz "The floating-point number input is " 	# null-terminated string
	
        .text                           # items stored in text segment
        .globl main                     # label accessible from other files
main:                                   # label (required)
        #beq		$t0, $t1, sum
        # Error in : invalid program counter value: 0x10010004
         
        li		$t2, 5		# loop 5 times
        lwc1		$f1, sentinel	# assign -1.0 to $f1
        
        #c.eq.s		$f0, $f1
        #bc1t		read
      	
      	# read float
        la              $a0, floatIn     # prompt the user for input
        li              $v0, 4          # service code for printing string
        syscall                         # perform service
        
        # get the input from user
        li              $v0, 6          # service code for read float to $f0
        syscall                         # perform service
        
        mov.s		$f1, $f0	# store input float in $f1
	
        # display text
        la              $a0, floatOut    # display the output prompt
        li              $v0, 4          # service code for printing string
        syscall                         # perform service
        
        # display number at $f1
        mov.s		$f12, $f1	# move number to display from $f1 to $f12
        li		$v0, 2		# service code to print float
        syscall
	
	j		read
	
read:
	beq		$t1, $t2, exit	# exit if equal
	
        # first number
        la              $a0, inputs     # prompt the user for input
        li              $v0, 4          # service code for printing string
        syscall                         # perform service

                                        # get the input from user
        li              $v0, 5          # service code for read integer
        syscall                         # perform service
        
        move            $a1, $v0        # save the input to $a1
        
        # second number
        la              $a0, inputs2    # prompt the user for input of second number
        li              $v0, 4          # service code for printing string
        syscall                         # perform service

                                        # get the input from user
        li              $v0, 5          # service code for read integer
        syscall                         # perform service
        
        move            $a2, $v0        # save the input to $a2
        
        j		next
        
next:
	# output first number
        la              $a0, outputs    # display the output prompt
        li              $v0, 4          # service code for printing string
        syscall                         # perform service

        move            $a0, $a1        # display the user input
        li              $v0, 1          # service code for print integer
        syscall                         # perform service
        
        # output second number
        la              $a0, outputs2   # display the output prompt
        li              $v0, 4          # service code for printing string
        syscall                         # perform service

        move            $a0, $a2        # display the user input
        li              $v0, 1          # service code for print integer
        syscall                         # perform service
	
	addi		$t1, $t1, 1	# increment count
	j		read		# next

exit:
        li              $v0, 10         # service code for exit
        syscall                         # perform service
