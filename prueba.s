.text
	addi $1 $0 1
	addi $2 $1 1
	addi $3 $1 1
	add $4 $2 $3
	add $5 $4 $3
	beq $2 $3 m
	add $6 $4 $5
m:	addi $7 $5 6
	add $8 $6 $7
	bne $8 $1 cos
	add $9 $7 $8
cos:	addi $10 $8 9
	add $11 $9 $10
	blez $9 m2
	addi $13 $11 10
m2:	addi $14 $13 10
	bgtz $1 m3
	add $15 $13 $14
m3:	addiu $16 $13 10
	addiu $17 $14 -15
	addi $14 $13 10
	slti $18 $17 10
	sltiu $19 $18 10
	sub $20 $19 $18
	sub $21 $20 $10
	xor $21 $19 $3
	or $22 $19 $3
	sub $23 $22 $21
	sll $22 $21 4
	srl $23 $22 2
	sub $24 $23 $22
	sub $25 $24 $23
	sub $26 $25 $24
	sub $27 $26 $25
	sub $28 $27 $26
