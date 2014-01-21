# This program demonstrate a new syscall handler for MIPS which acts like
# print_string and read_string, except that it uses the keyboard/display 
# device registers from the Keyboard and Display Simulator.
# (c) 2010, Warren Toomey, GPL3
#
# There are two functions, myprint_string and myread_string, which work
# exactly like the MIPS syscalls, i.e. same arguments, same return values.
# There is also a syscall handler which looks at the $v0 value and calls
# the appropriate function depending on the $v0 value.
#

	.kdata
saveat:	.word 0		# Saved value of $at register

# This is the entry point for the syscall handler.
# We can only handle syscalls 104 (print_string)
# and 108 (read string).

	.ktext	0x80000180
handler:
	.set noat
	move $k1, $at
	sw $k1, saveat	# Save $at
	.set at

        mfc0 $k0, $13           # Copy the Cause register
        srl $k0, $k0, 2         # and shift/AND to get the
        andi $k0, $k0, 0xf      # exact reason for the event.
                                # We can only deal with syscalls (8).
				# For anything else, simply call exit()
        beq $k0, 8, syscallhdlr
exit:
        li $v0, 10              # Can't deal with it, exit()
        syscall

# Here is the system call handler
syscallhdlr:

	beq $v0, 104, doprint	# It's a print_string syscall
	beq $v0, 108, doread	# It's a print_string syscall
	b exit			# Not a syscall we know, exit()

doprint: jal myprint_string	# Call the myprint_string() function
	b restore		# and leave the syscall handler
doread: jal myread_string	# Call the myread_string() function

restore:			# Restore registers
        mfc0 $k0, $14           # Get EPC register value
        addiu $k0, $k0, 4       # Skip syscall instruction by skipping
                                # forward by one instruction
        mtc0 $k0, $14           # Reset the EPC register

        .set noat
        lw $k1, saveat          # Reload and
        move $at, $k1           # restore $at
        .set at

        mtc0 $0, $13            # Clear Cause register
        mfc0 $k0, $12           # 
        ori  $k0, 0x1           # Re-enable interrupts
        mtc0 $k0, $12           # in the Status register
        eret                    # and finally return to the old PC

myprint_string:	subu $sp, $sp, 24	# Build a regular stack frame
		sw $ra, 20($sp)		# as we are a regular function
		sw $a0, 0($sp)		# Also save $a0, $a1 and $a2
		sw $a1, 4($sp)		# so we can modify them
		sw $a2, 8($sp)

print_char:	lb $a1, ($a0)		# Get next char to print
		beq $a1, $0, endprint	# Stop if it is a NUL

writeloop:	lw $a2, 0xffff0008	# Can we send a char yet?
		bne $a2, 1, writeloop	# No, not yet
		sb $a1, 0xffff000c	# Yes, write char to send register
		addi $a0, $a0, 1	# Move $a0 up to point to next char
		j print_char		# and loop back

endprint:	lw $ra, 20($sp)		# All done. Reload our registers
		lw $a2, 8($sp)		# from the stack frame
		lw $a1, 4($sp)
		lw $a0, 0($sp)
		addu $sp, $sp, 24	# Destroy the stack frame
		jr $ra			# and return from the function


myread_string: 	subu $sp, $sp, 24	# Build a regular stack frame
		sw $ra, 20($sp)		# as we are a regular function
		sw $a0, 0($sp)		# Also save $a0, $a1 and $a2
		sw $a1, 4($sp)		# so we can modify them
		sw $a2, 8($sp)

readloop:	lw $a2, 0xffff0000	# Char ready to be read yet?
		beq $a2, $0, readloop	# No, not yet
		lb $a2, 0xffff0004	# Yes, read the char in

		sb $a2, ($a0)		# Save the char in the buffer
		addi $a0, $a0, 1	# Move $a0 pointer up
		subi $a1, $a1, 1	# and decrement the # chars left
		beq $a2, '\n', endread	# Stop the loop if user enters newline
		bgt $a1, 1, readloop	# Loop back if >1 char left

endread:	
		sb $0, ($a0)		# NUL terminate the string
		lw $ra, 20($sp)		# All done. Reload our registers
		lw $a2, 8($sp)		# from the stack frame
		lw $a1, 4($sp)
		lw $a0, 0($sp)
		addu $sp, $sp, 24	# Destroy the stack frame
		jr $ra			# and return from the function
		