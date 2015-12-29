# readstring - Patrick Kubiak - 9/17/2015

        .data                           	# items stored in data segment
        .align 0                        	# no automatic alignment

string:
	.space 40				# store 10 characters

# keep strings at the bottom to fix alignment

inputs:                                 	# label
        .asciiz "\nEnter a string: "  		# null-terminated string

output:                                 	# label
	.asciiz "\nThe string entered is: "  	# null-terminated string

        .text                           	# items stored in text segment
        .globl main                     	# label accessible from other files
        
main:                                   	# label (required)
        add		$t0, $t1, $t2
        
        la              $a0, inputs     	# prompt the user for input
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        la		$a0, string             # get the input from user
        li		$a1, 9
        li              $v0, 8          	# service code for read integer
        syscall                         	# perform service
        
        # reverse string
        
        j		display
        
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
