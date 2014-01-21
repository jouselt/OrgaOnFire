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
m3msg:   .asciiz "In main3, the counter is "
newline: .asciiz "\n"
never:	 .asciiz "We should never get here\n"

	.text
	.globl main
main:
	la $a0, main1  # se crea el primer proceso
	li $v0 100
	syscall

	la $a0, main2	# se crea el segundo proceso
	li $v0 100
	syscall

	la $a0, main3	# se crea el tercer proceso
	li $v0 100
	syscall


	li $v0, 102	     # Habilita interrupciones de reloj e inicia la 
	syscall          # ejecucion del planificador de CPU 
	                 # y selecciona el primer proceso en la lista

	li $v0,10
	syscall
	


main1:
	li $t0, 10			# Our counter starts at 10
m1loop:	
	la $a0, m1msg		# Print out the message
	li $v0, 4
	syscall
	move $a0, $t0		# Print out the counter
	li $v0, 1
	syscall
	la $a0, newline		# Print a newline
	li $v0, 4
	syscall
	addi $t0, $t0, -1	# Decrement counter by 1
	bnez $t0 m1loop		# and loop back to print the counter again
	li $v0, 200			# when the counter reaches 0, the process finishes
	syscall


main2:	
	li $t0, 100		# Our counter starts at 1000
m2loop:	
	la $a0, m2msg		# Print out the message
	li $v0, 4
	syscall
	move $a0, $t0		# Print out the counter
	li $v0, 1
	syscall
	la $a0, newline		# Print a newline
	li $v0, 4
	syscall
	addi $t0, $t0, -5	# Increment counter by 2
	bnez $t0 m2loop		# and loop back to print the counter again
	li $v0, 200			# when the counter reaches 0, the process finishes
	syscall

main3:
	li $t1, -5  		# Our counter starts at -5
m3loop:	
	la $a0, m3msg		# Print out the message
	li $v0, 4
	syscall
	move $a0, $t1		# Print out the counter
	li $v0, 1
	syscall
	la $a0, newline		# Print a newline
	li $v0, 4
	syscall
	addi $t1, $t1, 1	# Increment counter by 1
	bnez $t1, m3loop	# and loop back to print the counter again
	
	li $t0, -5
	li $v0, 110		    # si count es igual a 0 cede el paso al siguiente proceso
	syscall             # en la lista de procesos que esperan por el CPU
	
