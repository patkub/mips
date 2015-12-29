# Sum Scores - Patrick Kubiak - 9/28/2015
# Keeps track of a sum of scores.

        .data                           	# items stored in data segment
        .align 0                        	# no automatic alignment

sentinel:
	.space 4				# declare 4 bytes of storage to hold integer sentinel

sum:
	.space 4				# declare 4 bytes of storage to hold integer sum

prompt1:                                	# label
        .asciiz "Enter scores one at a time as requested. When done, enter "      # null-terminated string

prompt2:                                	# label
        .asciiz " to stop. \n"      		# null-terminated string

prompt3:                                	# label
        .asciiz "Enter the first score: "      	# null-terminated string
        
prompt4:                                	# label
        .asciiz "Enter the next score: "      	# null-terminated string
        
outputs:                                	# label
        .asciiz "The sum of the scores is: " 	# null-terminated string
        
        .text                           	# items stored in text segment
        .globl main                     	# label accessible from other files
main:
	# make -1
	addi 		$t0, $zero, -1		# $t0 = -1
	
	# assign -1 to sentinel
        la		$t1, sentinel		# load sentinel address to $t1
        sw 		$t0, 0($t1)		# set sentinel ($t1) to -1 ($t0)
        
        # make 0
	add 		$t0, $zero, $zero	# $t0 = 0
	
	# assign 0 to sum
        la		$t1, sum		# load sum address to $t1
        sw 		$t0, 0($t1)		# set sum ($t1) to 0 ($t0)
        
	j 		prompt			# jump to prompt

prompt:
	# print directions
	la              $a0, prompt1     	# print directions part 1
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        # print sentinel
        la		$t0, sentinel		# load sentinel address to $t0
        lw		$a0, 0($t0)		# set $a0 to sentinel
	
        li		$v0, 1			# service code for printing integer
        syscall                         	# perform service
        
        # print directions part 2
        la              $a0, prompt2     	# print directions part 2
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        # prompt the user for input (enter first score)
	la              $a0, prompt3     	# print prompt
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        # get the user's input
        li              $v0, 5          	# service code for reading integer
        syscall                         	# perform service
        move            $a1, $v0        	# save the input to $a1
        
        # determine path
        lw		$t1, 0($t0)		# set $t1 to sentinel ($t0)
        beq		$a1, $t1, display	# display output if input = sentinel
        j		calc			# compute sum
	                                                
promptNext:
	# prompt the user for input (enter next score)
        la              $a0, prompt4     	# print prompt
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        # get the user's input
        li              $v0, 5          	# service code for reading integer
        syscall                         	# perform service
        move            $a1, $v0        	# save the input to $a1
        
        # load sentinel
        la		$t0, sentinel		# load sentinel address to $t0
        lw		$t1, 0($t0)		# set $t1 to sentinel
        
        # determine path
        beq		$a1, $t1, display	# display output if input = sentinel
        j		calc			# compute sum
	
calc:
	# compute sum
	la 		$t0, sum		# load address sum to $t0
	lw 		$t1, 0($t0)		# load sum word to $t1
	
        add		$t2, $a1, $t1		# set $t2 to $a1 (input) + $t1 (sum)
        sw		$t2, 0($t0)		# save new sum to address
	
	j		promptNext		# prompt next number
	
display:
        # display output sum
        la              $a0, outputs    	# display the output prompt
        li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
        # load sum
        la		$t0, sum		# load sum address to $t0
        lw		$a0, 0($t0)		# set $a0 to sum
        
        li              $v0, 1          	# service code for printing integer
        syscall                         	# perform service
        
        j		exit			# exit program
        
exit:
        # exit code
        li              $v0, 10         	# service code for exit
        syscall                         	# perform service
