# This is an example of very simple context switching on the MIPS CPU.
# (c) 2010, Warren Toomey, GPL3
# There are two main programs, both print out a counter, increment it
# and loop back to print it out again. main1 starts at 0 and increments
# in steps of 1. main2 starts at 10000 and increments in steps of 2.
#
# We run this file in combination with an interrupt handler that catches
# the clock tick interrupt from the Digital Lab Sim. When the tick arrives,
# the interrupt handler context switches between the two programs.
#
# There is also a main program here. As everything in this file runs in
# user mode, it cannot start the multitasking going, as it doesn't have
# the privilege to enable the interrupts in the Digital Lab Sim. Instead,
# the main program performs syscall 100, which jumps to the code in the other
# file. This sets up the process control blocks (PCBs) for both programs, and
# starts one of them running. In other words, the CPU never returns back to main.

	.data
m1msg:	 .asciiz "In main1, the counter is "
m2msg:	 .asciiz "In main2, the counter is "
newline: .asciiz "\n"
never:	 .asciiz "We should never get here\n"

	.text
	.globl main
main:	
	la $a0, main1		# Send the base addresses of
	la $a1, main2		# both programs to syscall 100
	li $v0, 100		# to enable the clock ticks and
	syscall			# start main1 running
	
	li $v0 102
	#syscall

	la $a0, never		# syscall 100 never returns, so
	li $v0 4		# we should never print out this mesg
	syscall
	li $v0, 10		# and never take the exit either
	syscall


main1:	li $t0, 0		# Our counter starts at 0
m1loop:	la $a0, m1msg		# Print out the message
	li $v0, 4
	syscall
	move $a0, $t0		# Print out the counter
	li $v0, 1
	syscall
	la $a0, newline		# Print a newline
	li $v0, 4
	syscall
	addi $t0, $t0, 1	# Increment counter by 1
	b m1loop		# and loop back to print the counter again


main2:	li $t0, 10000		# Our counter starts at 10000
m2loop:	la $a0, m2msg		# Print out the message
	li $v0, 4
	syscall
	move $a0, $t0		# Print out the counter
	li $v0, 1
	syscall
	la $a0, newline		# Print a newline
	li $v0, 4
	syscall
	addi $t0, $t0, 2	# Increment counter by 2
	b m2loop		# and loop back to print the counter again
