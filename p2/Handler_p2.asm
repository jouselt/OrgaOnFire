# This is an example of a clock tick handler to do simple context switching.
# (c) 2010, Warren Toomey, GPL3
#
# This file holds the syscall 100 handler and the interrupt handler
# which allows us to context switch between two programs. We define
# two process control blocks (PCBs) with room to store the registers
# of both programs when they are not running.
#
# syscall 100 takes one arguments: the base address of a programs
# in $a0. It will initialise the PCB for each program you enter (up to 4)
# with the base address and then return.
# syscall 102 enable the clock tick interrupt from the Digital Lab Sim, 
# and then context switch into the 1st program.
# 

# Define a process control block for each program
	.kdata
p1pcb:	.space 36	# Room for a0, v0, t0, t1, a1 a2 a3 v1 and PC (offsets 0, 4, 8, 12, 16, 20, 24, 28, 32)
p2pcb:	.space 36	# Ditto
p3pcb:	.space 36	# Ditto
p4pcb:	.space 36	# Ditto
index: 	.word 0

curpcb:	.word 0		# Offset to the current PCB, either 0, 36, 72, 108
saveat:	.word 0		# Saved value of $at register
text:	.asciiz "\nocurrio una interrupcion por presionar la tecla Q... finalizacion del programa "
text1:	.asciiz "\ninterrupcion por teclado ocurrio en el main 1 "
text2:	.asciiz "\ninterrupcion por teclado ocurrio en el main 2 "
text3:	.asciiz "\ninterrupcion por teclado ocurrio en el main 3 "
text4:	.asciiz "\ninterrupcion por teclado ocurrio en el main 4 "

# This is the entry point for both the syscall handler and
# the clock tick interrupt handler.
	.ktext	0x80000180
handler:
	.set noat
	move $k1, $at
	sw $k1, saveat          # Save $at
	.set at

	mfc0 $k0, $13           # Copy the Cause register
	srl $k0, $k0, 2         # and shift/AND to get the
	andi $k0, $k0, 0xf		# exact reason for the event.
				# We can only deal with interrupts (0)
				# or syscalls (8). For anything else
				# simply call exit()
	beqz $k0, inthandler
	beq $k0, 8, syscallhdlr

		
exit:
	li $v0, 10		# Can't deal with it, exit()
	syscall

syscallhdlr:
	beq $v0, 100, syscall_100	# goto the syscall 100 handler
	beq $v0, 102, syscall_102	# goto the syscall 102 handler
	beq $v0, 110, syscall_110	# goto the syscall 110 handler
	beq $v0, 110, syscall_200	# goto the syscall 200 handler		
	b exit				# Exit if it isn't a syscall we can handle
	
keyboard:

# Leemos el Receiver Data para obtener el caracter
# presionado.

	lw   $a0, 0xffff0004 

	
	beq  $a0, 0x71, tecla_Q #(q)
	beq  $a0, 0x51, tecla_Q #(Q)	
	b restore	  
	
	
# Here is the syscall 100 handler
syscall_100:
	la $k0, p1pcb
	lw $k1 index	#the index has the offset for the loaded programs (ether 0, 36, 72 or 108)
	add $k0 $k1 $k0		#adding the offset to the first one give you th
	sw $0, 0($k0)		#set all the values to 0
	sw $0, 4($k0)
	sw $0, 8($k0)
	sw $0 12($k0)
	sw $0 16($k0)
	sw $0 20($k0)
	sw $0 24($k0)
	sw $0 28($k0)
	sw $a0 32($k0)
	addi $k1 $k1 36	 	
#we don't need this, provded that the user enter up to 4 mains.	
#hence the maximum value index can take is 144
#	bne $k1 144 skip1
#	add $k1 $0 $0
#skip1:
	sw $k1 index
	b finale
	
# Here is the system call 102 handler
syscall_102:
	la $k0, 0xFFFF0013	# Now enable the clock ticks from the Digial Lab Sim
	li $k1, 1
	sb $k1, ($k0)
	b restore		# and context switch into program 1


syscall_110:
 # Here is the system call 110 handler
	la $k0, p1pcb
	lw $k1, curpcb
	add $k0, $k0, $k1	# k0 = p1pcb + curpcb, i.e. base of current PCB
	addi $k0 $k0 -36
	sw $a0, 0($k0)		# Save the a0, v0, t0 and t1 registers
	sw $v0, 4($k0)
	sw $t0, 8($k0)
	sw $t1, 12($k0)
	sw $a1, 16($k0)
	sw $a2, 20($k0)
	sw $a3, 24($k0)
	sw $v1, 28($k0)

	
	mfc0 $k1 $14
	addi $k1 $k1 4
	sw $k1 32($k0)	
	
	lw $k0, curpcb
	addi $k0, $k0 36	# k0 = 36 + curpcb
				
	bne $k0 144 skip2	# if (k0 == 144) => k0 = 0
	add $k0 $0 $0
skip2:
	sw $k0, curpcb		# now the current pcblock is updaded 
				# so we know which is the current program, we can
				# restore that program's state
 	b finale
	
 syscall_200:
	la $k0, p1pcb
	lw $k1, curpcb
	add $k0, $k0, $k1	# k0 = p1pcb + curpcb, i.e. base of current PCB
	sw $0   0($k0)		#set all the values to 0
	sw $0   4($k0)
	sw $0   8($k0)
	sw $0  12($k0)
	sw $0  16($k0)
	sw $0  20($k0)
	sw $0  24($k0)
	sw $0  28($k0)
	sw $a0 32($k0)
	b finale
 # Here is the system call 200 handler


# Here is the clock tick interrupt handler
inthandler:			# First thing, save the program's registers

	la $k0, p1pcb
	lw $k1, curpcb
	add $k0, $k0, $k1	# k0 = p1pcb + curpcb, i.e. base of current PCB
	sw $a0, 0($k0)		# Save the a0, v0, t0 and t1 registers
	sw $v0, 4($k0)
	sw $t0, 8($k0)
	sw $t1, 12($k0)
	sw $a1, 16($k0)
	sw $a2, 20($k0)
	sw $a3, 24($k0)
	sw $v1, 28($k0)

	mfc0 $k1, $14
	sw $k1, 32($k0)		# Save the old program counter from the EPC register
				# With that program's state safely stored away, we can
				# switch our understanding of which is the current program.
	lw $k0, curpcb
	lw $k1 index 
	addi $k0, $k0 36	# k0 = 36 + curpcb
				#meanin th current pcblock is updaded 
	bne $k0 144 skip	# if (k0 == 144) => k0 = 0
	add $k0 $0 $0
skip:
	sw $k0, curpcb
				# Now we know which is the current program, we can
				# restore that program's state
		
restore:			# Restore registers and reset procesor state
	la $k0, p1pcb
	lw $k1, curpcb
	add $k0, $k0, $k1	# k0 = p1pcb + curpcb, i.e. base of current PCB
	lw $a0, 0($k0)		# Reload the a0, v0, t0 and t1 registers
	lw $v0, 4($k0)
	lw $t0, 8($k0)
	lw $t1, 12($k0)
	lw $a1, 16($k0)
	lw $a2, 20($k0)
	lw $a3, 24($k0)
	lw $v1, 28($k0)
	lw $k1, 32($k0)		# Copy the old program counter into the EPC register
	beqz $k1 hup
	mtc0 $k1, $14

	lw   $k0, 0xffff0000     # Verifamos Receiver control (bit 1 en 1 = se ha tecleado algo).
	andi $k0, $k0, 0x1
	bnez $k0, keyboard
			
	b saltito
hup: 
	lw $k1 curpcb
	addi $k1 $k1 36
	bne $k1 144 nxt
	move $k1 $0
nxt:
	sw $k1 curpcb
	b restore

finale:

        mfc0 $k0, $14           # Get EPC register value
        addiu $k0, $k0, 4       # Skip syscall instruction by skipping
                                # forward by one instruction
        mtc0 $k0, $14           # Reset the EPC register
saltito:
        
	.set noat
	lw $k1, saveat          # Reload and
	move $at, $k1           # restore $at
	.set at

	mtc0 $0, $13            # Clear Cause register
	mfc0 $k0, $12           # 
	ori  $k0, 0x1           # Re-enable interrupts
	mtc0 $k0, $12		# in the Status register
	eret			# and finally return to the old PC
	
tecla_Q:

	la $a0, text		# Print out the message
	li $v0, 4
	syscall
	lw $k0, curpcb
#	addi $k0 $k0 -1
	beq $k0, 0, interrupcion_main_1		# la interrupcion ocurrio en el main 1
	beq $k0, 36, interrupcion_main_2	# la interrupcion ocurrio en el main 2
	beq $k0, 72, interrupcion_main_3	# la interrupcion ocurrio en el main 3
	beq $k0, 108, interrupcion_main_4	# la interrupcion ocurrio en el main 4			

	
interrupcion_main_1:

	la $a0, text1		# Print out the message
	li $v0, 4
	syscall
	
	move $a0, $14
	li $v0,	34
	syscall					
				
	li $v0, 10		# Can't deal with it, exit()
	syscall	

interrupcion_main_2:

	la $a0, text2		# Print out the message
	li $v0, 4
	syscall
	
	move $a0, $14
	li $v0,	34
	syscall					
				
	li $v0, 10		# Can't deal with it, exit()
	syscall

interrupcion_main_3:

	la $a0, text3		# Print out the message
	li $v0, 4
	syscall
	
	move $a0, $14
	li $v0,	34
	syscall					
				
	li $v0, 10		# Can't deal with it, exit()
	syscall

interrupcion_main_4:

	la $a0, text4		# Print out the message
	li $v0, 4
	syscall
	
	move $a0, $14
	li $v0,	34
	syscall					
				
	li $v0, 10		# Can't deal with it, exit()
	syscall														
