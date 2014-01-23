# This is an example of a clock tick handler to do simple context switching.
# (c) 2010, Warren Toomey, GPL3
#
# This file holds the syscall 100 handler and the interrupt handler
# which allows us to context switch between two programs. We define
# two process control blocks (PCBs) with room to store the registers
# of both programs when they are not running.
#
# syscall 100 takes two arguments: the base address of both programs
# in $a0 and $a1. It will initialise the PCB for each program with
# the base address, enable the clock tick interrupt from the
# Digital Lab Sim, and then context switch into the 1st program.
# In other words, the syscall will not return back to the syscaller.

# Define a process control block for each program
	.kdata
programs:	.space 32	# Room for $v0, $v1, $a0, $a1, $a2, $a3, $t0, $t1 and PC (offsets 0, 4, 8, 12, 16, 20, 24, 28)
		.space 32	# igual para el segundo
		.space 32       # el tercero 
		.space 32	# el cuarto.


mainCounter: .word 0   # Contiene la cantidad de mains agregados 
index:	.word 0		# Offset to the current PCB, either 0 or 32 or 64 or 96
saveat:	.word 0		# Saved value of $at register

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
	andi $k0, $k0, 0xf	# exact reason for the event.
				# We can only deal with interrupts (0)
				# or syscalls (8). For anything else
				# simply call exit()
	beqz $k0, inthandler
	beq $k0, 8, syscallhdlr
exit:
	li $v0, 10		# Can't deal with it, exit()
	syscall

# Here is the system call 100 handler
syscallhdlr:


	beq $v0, 100, Syscall_100
	beq $v0, 102, Syscall_102
	beq $v0, 110, Syscall_110
	beq $v0, 200, Syscall_200
	
	b exit		

Syscall_100:

	lw $k0, mainCounter 		# mainCounter tiene la cantidad de programas agregados.
	sll $k0 $k0 5 			# $k0*32 para tener la direccion del arreglo de programas
	la $k1 programs
	add $k0 $k1 $k0 		# k0 ahora tiene ela direccion del programa que se guardara.
	sw $a0, 28($k0) 		# guarda la primera instruccion del main 
	sw $0, 24($k0)
	sw $0, 20($k0)
	sw $0, 16($k0)			# Save the 1st instruction address for prog1
	sw $0, 12($k0)			# and fill the other PCB values as initially 0
	sw $0, 8($k0)
	sw $0, 4($k0)
	sw $0, 0($k0)
	
	lw $k0, mainCounter
	addi $k0, $k0, 1
	sw $k0, mainCounter

	b fin_interrupcion
	
Syscall_102:
	
	la $k0, 0xFFFF0013	# Now enable the clock ticks from the Digial Lab Sim
	li $k1, 1
	sb $k1, ($k0)
	
	b fin_interrupcion		# and context switch into programs

Syscall_110:

	

Syscall_200:




# Here is the clock tick interrupt handler

inthandler:			# First thing, save the program's registers

	lw $k0, mainCounter # mainCounter tiene la cantidad de programas agregados.
	lw $k1, index
	srl $k1, $k1, 5
	
	beq $k0, $k1, restore_index
	
back_restore_index:
	  

	la $k0, programs
	lw $k1, index
	add $k0, $k0, $k1
	sw $v0, 0($k0)		# Reload the a0, v0, t0 and t1 registers
	sw $v1, 4($k0)
	sw $a0, 8($k0)
	sw $a1, 12($k0)
	sw $a2, 16($k0)
	sw $a3, 20($k0)
	sw $t0, 24($k0)			
	mfc0 $k1, $14
	sw $k1, 28($k0)		# Save the old program counter from the EPC register

				# With that program's state safely stored away, we can
				# switch our understanding of which is the current program.

	lw $k0, index
	addi  $k0, $k0, 32	# k0 = 20 - curpcb, i.e. 20 => 0, or 0 => 20
	sw $k0, index

				# Now we know which is the current program, we can
				# restore that program's state
	b restore

restore_index:

	sw $0, index
	
	b back_restore_index																																
		
restore:			# Restore registers and reset procesor state
	la $k0, programs
	lw $k1, index
	add $k0, $k0, $k1	# k0 = p1pcb + curpcb, i.e. base of current PCB
	lw $v0, 0($k0)		# Reload the a0, v0, t0 and t1 registers
	lw $v1, 4($k0)
	lw $a0, 8($k0)
	lw $a1, 12($k0)
	lw $a2, 16($k0)
	lw $a3, 20($k0)
	lw $t0, 24($k0)			
	lw $k1, 28($k0)		# Copy the old program counter into the EPC register
	mtc0 $k1, $14

fin_interrupcion:

	.set noat
	lw $k1, saveat          # Reload and
	move $at, $k1           # restore $at
	.set at

	mtc0 $0, $13            # Clear Cause register
	mfc0 $k0, $12           # 
	ori  $k0, 0x1           # Re-enable interrupts
	mtc0 $k0, $12		# in the Status register
	eret			# and finally return to the old PC
