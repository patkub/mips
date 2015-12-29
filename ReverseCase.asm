# Reverse Case - Patrick Kubiak - 10/17/2015
# Reverse the case of the input string. Accepts up to 100 characters of input.

        .data                           	# items stored in data segment
        .align 0                        	# no automatic alignment

string:
	.space 400				# store 100 characters

# keep strings at the bottom to fix alignment

inputs:                                 	# label
        .asciiz "\nEnter a string: "  		# null-terminated string

output:                                 	# label
	.asciiz "\nThe reverse case is: "  	# null-terminated string

        .text                           	# items stored in text segment
        .globl main                     	# label accessible from other files
        
main:                                   	# label (required)
        
        la              $a0, inputs     	# prompt the user for input
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        la		$a0, string             # get the input from user
        li		$a1, 101		# max characters to read (space / 4) + 1
        li              $v0, 8          	# service code for read string
        syscall                         	# perform service
        
        la		$t0, string		# load address of string to $t0
	addi		$t2, $t0, 400		# make $t2 = $t0 + 400
	
        j		reverseCase		# reverse case of string

reverseCase:
	# reverse case of string
	beq		$t0, $t2, display	# go to display if all characters are read
	lb		$t1, ($t0)		# load current byte of string to $t1
	
	# uppercase = 65 to 90
	li		$t3, 65
	li		$t4, 91
	
	# lowercase = 97 to 122
	li		$t5, 97
	li		$t6, 122
	
	slt		$t7, $t1, $t3		# if byte < 65, $t7 = 1, else $t7 = 0
	beq		$t7, $zero, upperCase	# branch if byte >= 65
	
	addi		$t0, $t0, 1		# increment to next character
	j		reverseCase

upperCase:
	# we know byte >= 65, check byte <= 90 ($t4)
	slt		$t7, $t1, $t4			# if byte < 91, $t7 = 1, else $t7 = 0
	beq		$t7, $zero, lowerCaseCheck	# check for lowercase if byte > 90
	
	# we know its uppercase now, convert to lowercase
	addi		$t1, $t1, 32		# add 32 to convert to lowercase
	sb		$t1, ($t0)		# store uppercase byte
	
	addi		$t0, $t0, 1		# increment to next character
	j		reverseCase		# continue changing case

lowerCaseCheck:
	slt		$t7, $t1, $t5		# if byte < 97, $t7 = 1, else $t7 = 0
	beq		$t7, $zero, lowerCase	# branch if byte >= 97
	
	addi		$t0, $t0, 1		# increment to next character
	j		reverseCase		# continue changing case	
			
lowerCase:                                                                
       	# we know byte >= 97, check byte <= 122 ($t6)
       	slt		$t7, $t1, $t6		# if byte < 122, $t7 = 1, else $t7 = 0
       	beq		$t7, $zero, noCase	# branch if byte > 122
       
       	# we know its lowercase now, convert to uppercase
       	addi		$t1, $t1, -32		# subtract 32 to convert to uppercase
       	sb		$t1, ($t0)		# store lowercase byte
       
       	addi		$t0, $t0, 1		# increment to next character
       	j		reverseCase		# continue changing case
       
noCase:
	# not a letter         
       
       	addi		$t0, $t0, 1		# increment to next character
       	j		reverseCase		# continue changing case
       	                                                            
display:        
        la              $a0, output     	# load output
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        la              $a0, string     	# load string input by user
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        j		exit

exit:        
        # exit
        li              $v0, 10         	# service code for exit
        syscall                         	# perform service
