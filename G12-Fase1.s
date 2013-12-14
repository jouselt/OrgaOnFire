##﻿# Archivo G12-Fase1.s
# Descripcioin: lee el archivo programa.txt, pasa de letras a hexadecimales, se almacenan 
# en programa el bloque de memoria
# y luego son interpretadas como instrucciones.
# autor: Jouselt Fernandez
# Fecha: 26/11/2013

	.data

buffer	:	.space 10
fileName:	.asciiz "programa.txt"
msg: 		.asciiz "Fin.. Por ahora... \n"
err   	: 	.ascii "\nError solo se permiten caracteres hexadecimales [0..F]  "
		.ascii "o tal vez estas usando un archivo creado en linux, ver Nota en "
		.ascii "linea 51"
barraN	:	.asciiz "\n"
espacio	:	.asciiz " "
dollar	:	.asciiz "$"

##########################################################################################
# Tabla de codigos de operacion
# Estructura:
#	Formato (2 bytes): 	0 Registro
#			 	1 Inmediato
#			 	2 Jump
# Extension (2 bytes):		0 No usa
#            			1 Si usa
# Apuntador (4 bytes) a la cadena de caracteres que contiene el nombre de la operacion  
#       	Si usa extension de codigo este campo contiene un apuntador NULO
#  Apuntador (4 bytes) 	a la funcion que implementa la operacion o
#				a la Tabla con los coop extendidos
coop:					
	.half 0 1 		# coop 0 extension de coop
	.word 0 _Tabla0      
	.word 0 0 __No 		# coop 1
	.half 2 0		# coop 2 j
	.word _j __j
	.half 1 0		# coop 3 jal
	.word _jal __jal
	.half 1 0 		# coop 4 beq
	.word _beq __beq
	.half 1 0		# coop 5 bne
	.word _bne __bne
	.half 1 0		# coop 6 blez
	.word _blez __blez
	.half 0 0		# coop 7 bgtz
	.word _bgtz __bgtz	
	.half 1 0		# coop 8 addi
	.word _addi __addi
	.half 1 0		# coop 9 addiu
	.word _addiu __addiu
	.half 1 0		# coop 10 slti
	.word _slti __slti
	.half 1 0		# coop 11 sltiu
	.word _sltiu __sltiu	
	.half 1 0		# coop 12 andi
	.word _andi __andi	
	.half 1 0		# coop 13 ori
	.word _ori  __ori
	.half 1 0 		# coop 14 xori
	.word _xori __xori
	.word 0 0 __No 		# coop 15
	.word 0 0 __No 		# coop 16
	.word 0 0 __No 		# coop 17
	.word 0 0 __No 		# coop 18
	.word 0 0 __No 		# coop 19
	.word 0 0 __No 		# coop 20
	.word 0 0 __No 		# coop 21
	.word 0 0 __No 		# coop 22
	.word 0 0 __No 		# coop 23
	.half 1 0		# coop 24 llo
	.word _llo __llo
	.word 0 0 0 		# coop 25 lhi
	.word 0 0 __No 		# coop 26
	.word 0 0 __No 		# coop 27
	.word 0 0 __No 		# coop 28
	.word 0 0 __No 		# coop 29 
	.word 0 0 __No 		# coop 30
	.word 0 0 __No 		# coop 31
	.half 1 0 		# coop 32 lb
	.word _lb __lb
	.word 0 0 __No 		# coop 33 
	.word 0 0 __No 		# coop 34
	.half 1 0 		# coop 35 lw
	.word _lw __lw	
	.word 0 0 __No 		# coop 36 				
	.word 0 0 __No 		# coop 37 lbu
	.word 0 0 __No 		# coop 38
	.word 0 0 __No 		# coop 39
	.half 1 0 		# coop 40 sb
	.word _sb __sb				
	.half 1 0 		# coop 41 sh
	.word _sh __sh
	.word 0 0 __No		# coop 42
	.half 1 0 		# coop 43 sw
	.word _sw __sw
	.word 0 0 __No 		# coop 44
	.word 0 0 __No 		# coop 45
	.word 0 0 __No 		# coop 46
	.word 0 0 __No 		# coop 47
	.word 0 0 __No 		# coop 48
	.word 0 0 __No 		# coop 49
	.word 0 0 __No 		# coop 50
	.word 0 0 __No 		# coop 51
	.word 0 0 __No 		# coop 52
	.word 0 0 __No 		# coop 53
	.word 0 0 __No 		# coop 54
	.word 0 0 __No 		# coop 55
	.word 0 0 __No 		# coop 56
	.word 0 0 __No 		# coop 57
	.word 0 0 __No 		# coop 58
	.word 0 0 __No 		# coop 59
	.word 0 0 __No 		# coop 60
	.word 0 0 __No 		# coop 61
	.word 0 0 __No 		# coop 62
	.word 0 0 __No 		# coop 63

# Tabla con la extension de codigos para el coop = 0
# Estructura
#Apuntador (4 bytes) 	a la cadena de caracteres que contiene el nombre de la operacion
#       		    	
#Apuntador (4 bytes) 	a la funcion que implementa la operacion 
_Tabla0:
	.word _sll __sll	# coop 0 sll
	.word 0 __No 		# coop 1 
	.word _srl __srl	# coop 2 srl
	.word _sra __sra	# coop 3 sra
	.word _sllv __sllv	# coop 4 sllv
	.word 0 __No		# coop 5
	.word _srlv __srlv	# coop 6 srlv
	.word _srav __srav	# coop 7 srav
	.word _jr __jr		# coop 8 jr
	.word _jalr __jalr	# coop 9 jalr
	.word 0 __No		# coop 10
	.word 0 __No		# coop 11
	.word 0 __No		# coop 12
	.word 0 __No		# coop 13
	.word 0 __No		# coop 14
	.word 0 __No		# coop 15
	.word 0 __No		# coop 16
	.word 0 __No		# coop 17
	.word 0 __No		# coop 18
	.word 0 __No		# coop 19
	.word 0 __No		# coop 20
	.word 0 __No		# coop 21
	.word 0 __No		# coop 22
	.word 0 __No		# coop 23
	.word _mult __mult	# coop 24
	.word _multu __multu	# coop 25
	.word _div __div	# coop 26
	.word _divu __divu	# coop 27
	.word 0 __No		# coop 28
	.word 0 __No		# coop 29
	.word 0 __No		# coop 30
	.word 0 __No		# coop 31
	.word _add __add	# coop 32
	.word _addu __addu	# coop 33
	.word _sub __sub	# coop 34
	.word _subu __subu	# coop 35
	.word _and __and	# coop 36
	.word _or __or		# coop 37
	.word _xor __xor	# coop 38
	.word _nor __nor	# coop 39
	.word 0 __No 		# coop 40
	.word 0 __No 		# coop 41
	.word 0 __No 		# coop 42
	.word 0 __No 		# coop 43
	.word 0 __No 		# coop 44
	.word 0 __No 		# coop 45
	.word 0 __No 		# coop 46
	.word 0 __No 		# coop 47
	.word 0 __No 		# coop 48
	.word 0 __No 		# coop 49
	.word 0 __No 		# coop 50
	.word 0 __No 		# coop 51
	.word 0 __No 		# coop 52
	.word 0 __No 		# coop 53
	.word 0 __No 		# coop 54
	.word 0 __No 		# coop 55
	.word 0 __No 		# coop 56
	.word 0 __No 		# coop 57
	.word 0 __No 		# coop 58
	.word 0 __No 		# coop 59
	.word 0 __No 		# coop 60
	.word 0 __No 		# coop 61
	.word 0 __No 		# coop 62
	.word 0 __No 		# coop 63

_j	:.asciiz "j "
_jal	:.asciiz "jal "
_beq	:.asciiz "beq "
_bne	:.asciiz "bne "
_blez	:.asciiz "blez "
_bgtz	:.asciiz "bgtz "
_addi	:.asciiz "addi "
_addiu	:.asciiz "addiu "
_slti	:.asciiz "slti "
_sltiu	:.asciiz "sltiu "
_andi	:.asciiz "andi "
_ori	:.asciiz "ori "
_xori	:.asciiz "xori " 
_llo	:.asciiz "llo "
_lb	:.asciiz "lb "
_lw	:.asciiz "lw "
_sb	:.asciiz "sb "
_sh	:.asciiz "sh "
_sw	:.asciiz "sw "
_sll	:.asciiz "sll "
_srl	:.asciiz "srl "
_sra	:.asciiz "sra "
_sllv	:.asciiz "sllv "
_srlv	:.asciiz "srlv "
_srav	:.asciiz "srav "
_jr	:.asciiz "jr "
_jalr	:.asciiz "jalr "
_mult	:.asciiz "mult "
_multu	:.asciiz "multu "
_div	:.asciiz "div "
_divu	:.asciiz "divu "
_add	:.asciiz "add "
_addu	:.asciiz "addu "
_sub	:.asciiz "sub "
_subu	:.asciiz "subu "
_and	:.asciiz "and "
_or	:.asciiz "or "
_xor	:.asciiz "xor "
_nor	:.asciiz "nor "

.align 2
registros:.space 128 		# espacio reservado para los registros de la maquina virtual

memoria:.space 1200		# espacio reservado para la memoria estatica de la maquina virtual	

fin_pila:.space 396		# espacio para implementar la pila de la maquina virtual
pila:.word 0			# primera palabra disponible de la pila. La pila crece de direcciones altas a bajas


contador:.word programa		# Registro especial Contador de Programa. Contiene la direccion de la proxima
				# instruccion a ser ejecutada eb la Maquina Virtual
				
programa:.space 800		# espacio reservado para almacenar el codigo ensamblado del programa a ser ejecutado por la
				# maquina virtual

	.text
	
#########################################################################################
#Planificación de registros Main
#########################################################################################
#      $t0 Guarda la cantidad de bits a correr para guardar y mostrar la palabra
#	   Indice de programa
#      $t1 contiene el caracter que se esta leyendo del buffer
#      $t2 se almacena la direccion de "programa" en un momento dado.
#      $t3 guarda la posicion del buffer que se esta leyendo en cada palabra. 0<=t3<8
#      $t4 la palabra que estoy generando.
#      $t5 contador del numero de palabras.
#      $a0 paso de argumentos varios al syscall// contiene las palabras de "programa"
#      $a1 paso de argumentos varios al syscall
#      $v0 para el syscall
#      $s0 contiene el identificador del archivo.
#      $s1 contiene la direccion de inicio de programa

#########################################################################################
main:
	# abro archivo
	li $v0 13
	la $a0 fileName
	li $a1 0x0
	syscall
	#guardo el identificador para poder cerrarlo mas adelante
	move $s0, $v0
	la $s1 programa
	#inicializar t0
	li $t0 0
loop:	# leo de archivo, 10 caracteres cada vez
	add $a0 $s0 $0
	la $a1, buffer
	li $a2 10
	NOTA: #^^ para usar un archivo creado en linux hay que usar 9
	li $v0 14
	syscall
	blez $v0 looby
	#elimina el null o el /n que esta al final.
	sb $zero, buffer + 8
	la $t3 buffer
loopLeerBuffer:	
	
	lb $t1, ($t3)	# Carga un caracter de la cadena en $t1
	addi $t3, $t3, 1
	beq $t1, 0, guardar	#Si llego al fin de palabra salto a guardar.
	
	bge $t1, 71, invalido #asumiendo que la letra es mayuscula
	bge $t1, 65, letra

	bgt $t1, 57 invalido #verifico si es numero o letra
	bge $t1, 48, numero
	
	
invalido:
	#anuncio el error por carácter inválido
	li $v0 4
	la $a0 err
	syscall

	#cierro archivo
	li $v0 16
	move $a0 $s0
	syscall
	#y me voy
	b fin

numero:
	#de ser un numero le resto 48 al ascii para tener el numero deseado
	addi $t1 $t1 -48
	sll  $t4, $t4, 4
	add $t4, $t4, $t1
	b loopLeerBuffer

letra: 
	#le resto 55 para tener el numero equivalente a la letra en 0x
	addi $t1 $t1 -55
	sll  $t4, $t4, 4
	add $t4, $t4, $t1
	b loopLeerBuffer

guardar:
	#una vez se completa una palabra se guarda en memoria.
	sll $t0 $t5 2
	add $t7 $t0 $s1
	sw $t4, 0($t7)
	addi $t5 $t5 1
	addi $t0, $t0 4
	b loop
	 
looby:
	sll $t5 $t5 2
	add $t0 $s1 $t5
	sw $0 0($t0)

	#cierro archivo
	li $v0 16
	move $a0 $s0
	syscall


	#inicializamos t0 en programa para reusarlo como indice.
	add $t0 $s1 $0
	
imprimir:
	#se imprime el contenido de "programa"
	
	lw $a0 0($t0)
	beqz $a0 interpretarLobby
	#si cambio el orden puedo imprimir el 0x0000000, por efecto visual no lo imprimo.
	addi $t0 $t0 4
	li $v0 34
	#syscall

	li $v0 4
	la $a0 barraN
	#syscall	

	b imprimir

interpretarLobby:
	li $v0 4
	la $a0 barraN
	syscall	

	la $t0 programa
	la $s3 coop
interpretar:
	
	lw $t1 0($t0)
	beqz $t1 fin
	move $a0 $t1
	li $v0 34
	syscall
	
	la $a0 espacio
	li $v0 4
	syscall
	
	andi $a0 $t1 0xfc000000
	srl $a0 $a0 26
	mul $a0 $a0 12
	
	add $t2 $a0 $s3 
	#en $s3 tengo la direccion del arreglo 
	#en $t2 tengo la direccion del elemento
#	lw $a0 4($t2)
	lw $a0 4($t2)
	li $v0 4
	syscall
	
	
	lh $t3 0($t2)
	move $a0 $t3
	li $v0 1
	syscall
	#ahora tengo el formato de operaccion
	beq $t3 192 salto
	beq $t3 128 inmediato
	beq $t3 64 registro
	
	lh $t3 2($t2)
	beqz $t3 extencion
	
back:

	li $v0 4
	la $a0 barraN
	syscall		
	
	addi $t0 $t0 4 #me muevo a la siguiente instrucion.
	b interpretar

registro:
	#lw $a0 4($t2)
	li $v0 4
	#syscall

	li $v0 4
	la $a0 dollar
	syscall	

	andi $a0 $t1 0x0000f800
	li $v0 1
	syscall	
	
	li $v0 4
	la $a0 dollar
	syscall	
	
	andi $a0 $t1  0x03e00000
	li $v0 1
	syscall	

	
	li $v0 4
	la $a0 dollar
	syscall	
	andi $a0 $t1 0x001f0000
	li $v0 1
	syscall	

b back
inmediato:

b back
salto:

b back

extencion:
	#hacer algo para la extencion.
b back
fin:	
	#anuncio el fin del programa.
	li $v0 4
	la $a0 msg
	syscall
	
	#fin.
	li $v0 10
	syscall

# Implementacion de las operaciones de la MLMV
__No: jr $ra   	# No hace nada. Se usa para el caso de los codigos de operacion 
		# no implementados en la arquitectura y evitar tener que preguntar 
		# si el coop existe o no en la maquina
		
__j:
	jr $ra
	
__jal:
	jr $ra
	
__beq:
	jr $ra
	
__bne:
	jr $ra
	
__blez:
	jr $ra
	
__bgtz:
	jr $ra
	
__addi:
	jr $ra
	
__addiu:
	jr $ra
	
__slti:
	jr $ra
	
__sltiu:
	jr $ra
	
__andi:
	jr $ra
	
__ori:
	jr $ra
	
__xori:
	jr $ra
	
__llo:
	jr $ra
	
__lb:
	jr $ra
	
__lw:
	jr $ra
	
__sb:
	jr $ra
	
__sh:
	jr $ra
	
__sw:
	jr $ra
	
__sll:
	jr $ra
	
__srl:
	jr $ra
	
__sra:
	jr $ra
	
__sllv:
	jr $ra
	
__srlv:
	jr $ra
	
__srav:
	jr $ra
	
__jr:
	jr $ra
	
__jalr:
	jr $ra
	
__mult:
	jr $ra
	
__multu:
	jr $ra
	
__div:
	jr $ra
	
__divu:
	jr $ra
	
__add:
	jr $ra
		
__addu:
	jr $ra
	
__sub:
	jr $ra
	
__subu:
	jr $ra
	
__and:
	jr $ra
	
__or:
	jr $ra
	
__xor:
	jr $ra
		
__nor:
	jr $ra
