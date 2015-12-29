# Subtract One Until Zero - Patrick Kubiak - 12/2/2015
# Subtracts one from a number in memory until it is zero.

        .data                           	# items stored in data segment
        .align 0                        	# no automatic alignment

number:
	.space 4				# 4 bytes to store number

debug1:
	.asciiz "Number = "			# null-terminated string

debug2:
	.asciiz "\n"				# null-terminated string
	
        .text                           	# items stored in text segment
        .globl main                     	# label accessible from other files
main:
	la		$t0, number		# load number address to $t0
	
	# Set number and $t1 equal to 5
	addi		$t1, $zero, 5		# set $t1 = 5
	sw		$t1, 0($t0)		# store $t1 into memory address number
	
	# START DEBUG
	
	# Print Number
	la              $a0, debug1     	# print debug statement
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
	# display number at $t1
	move		$a0, $t1		# set $a0 to number
	li              $v0, 1          	# service code for print integer
        syscall                         	# perform service
        
        # print new line
        la              $a0, debug2     	# print debug statement
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	# END DEBUG
	
	addi		$t2, $zero, 1		# set $t2 = 1
	j		calc			# loop

calc:
	sub		$t3, $t1, $t2		# $t3 = $t1 (number) - $t2 (1)
	add		$t1, $t3, $zero		# $t1 = $t3 + 0
	sw		$t1, 0($t0)		# store $t1 into memory address number
	
	# START DEBUG
	
	# Print Number
	la              $a0, debug1     	# print debug statement
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
        
	# display number at $t1
	move		$a0, $t1		# set $a0 to number
	li              $v0, 1          	# service code for print integer
        syscall                         	# perform service
        
        # print new line
        la              $a0, debug2     	# print debug statement
	li              $v0, 4          	# service code for printing string
        syscall                         	# perform service
	
	# END DEBUG
	
	beq		$t3, $zero, exit	# exit if $t3 = 0
	j		calc
	
exit:
	# exit code
        li              $v0, 10         	# service code for exit
        syscall                         	# perform service	
