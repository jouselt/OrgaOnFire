# This program uses the myprint_string and myread_string
# system calls as defined in the wk6syscall_hand.er.asm file.
# (c) 2010, Warren Toomey, GPL3


	.data
prompt:	.asciiz	"Please type something on the keyboard\n"
result:	.asciiz	"Here is what you typed:\n"
buffer:	.space 100

	.text
main:
	li $v0, 104	# Perform the myprint_string
	la $a0, prompt	# using the prompt
	syscall

	li $v0, 4	# And also send it on the MARS console
	la $a0, prompt
	syscall

	li $v0, 108	# Now call myread_string
	la $a0, buffer
	li $a1, 100
	syscall

	li $v0, 104	# Print the result string
	la $a0, result	# on display and MARS console
	syscall

	li $v0, 4
	la $a0, result
	syscall

	li $v0, 104	# Print the user's string
	la $a0, buffer	# on display and MARS console
	syscall

	li $v0, 4
	la $a0, buffer
	syscall
			# Now exit the program
	li $v0, 10
	syscall
