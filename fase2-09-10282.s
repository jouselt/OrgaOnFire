## Archivo fase2-09-10282.s
# Descripcioin: lee el archivo programa.txt, pasa de letras a hexadecimales, se almacenan 
# en programa el bloque de memoria
# y luego son interpretadas como instrucciones.
# autor: Jouselt Fernandez
# Fecha: 18/12/2013

	.data

buffer	:	.space 10
fileName:	.space 20
ask	:	.asciiz "indique nombre del archivo a compilar: "
msg	:	.asciiz "Fin.. Por ahora... \n"
err   	:	.ascii "\nError solo se permiten caracteres hexadecimales [0..F]  "
		.ascii "o tal vez estas usando un archivo creado en linux, ver Nota en "
		.ascii "linea 51"
barraN	:	.asciiz "\n"
espacio	:	.asciiz " "
dollar	:	.asciiz " $"

##########################################################################################
# Tabla de codigos de operacion
# Estructura:
#	Formato (2 bytes): 	0 Registro
#			 	1 Inmediato
#			 	2 Jump
# Extension (2 bytes):		0 No usa
#            			1 Si usa
# Apuntador (4 bytes) a la cadena de caracteres que contiene el nombre de la operacion  
#       		Si usa extension de codigo este campo contiene un apuntador NULO
#  Apuntador (4 bytes) 	a la funcion que implementa la operacion o
#			a la Tabla con los coop extendidos
#########################################################################################
	.align 2
coop:					
	.half 0 1 		# coop 0    extension de coop
	.word 0 _Tabla0      
	.word 0 0 __No 		# coop 1
	.half 2 0		# coop 2 j
	.word _j __j
	.half 2 0		# coop 3 jal
	.word _jal __jal
	.half 1 0 		# coop 4 beq
	.word _beq __beq
	.half 1 0		# coop 5 bne
	.word _bne __bne
	.half 1 0		# coop 6 blez
	.word _blez __blez
	.half 1 0		# coop 7 bgtz
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
#########################################################################################
# Tabla con la extension de codigos para el coop = 0	
# Estructura:
#Apuntador (4 bytes) a la cadena de caracteres que contiene el nombre de la operacion
#       		    	
#Apuntador (4 bytes) a la funcion que implementa la operacion 
#########################################################################################
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
registros:.space 128		# espacio reservado para los registros de la maquina virtual

memoria:  .space 1200		# espacio reservado para la memoria estatica de la maquina virtual	

fin_pila: .space 396		# espacio para implementar la pila de la maquina virtual
pila:     .word 0		# primera palabra disponible de la pila. La pila crece 
				# de direcciones altas a bajas


contador:.word programa		# Registro especial Contador de Programa. Contiene la
				# direccion de la proxima instruccion a ser ejecutada 
				# en la Maquina Virtual
				
programa:.space 800		# espacio reservado para almacenar el codigo ensamblado 
				# del programa a ser ejecutado por la maquina virtual

	.text

#########################################################################################
#Planificacion de registros Main
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
#      $s3 contiene el inicio del arreglo de codigos de operacion
#      $s4 tiene el inicio del arreglo de codigos de expansion 

#########################################################################################
main:
	li $v0 4
	la $a0 ask
	syscall
	# indicar el nombre del programa.
	li $v0 8
	la $a0 fileName
	li $a1 15
	syscall
	li $t0 -1
	li $t2 10 #corresponde al valor decimal de un salto de linea
	#no esta implementado en mars que en $v0 regrese el numero de caracteres leidos.
noEOL:
	addi $t0 $t0 1
	lb $t1 fileName($t0)
	bne $t1 $t2 noEOL

	sb $0 fileName($t0)
	#eliminar el /n al final.
	
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
	
	lb $t1, ($t3)		# Carga un caracter de la cadena en $t1
	addi $t3, $t3, 1
	beq $t1, 0, guardar	#Si llego al fin de palabra salto a guardar.
	
	bge $t1, 103, invalido 	#para letras minusculas
	bge $t1, 97, letraMinuscula
	
	bge $t1, 71, invalido 	#si la letra es mayuscula
	bge $t1, 65, letra

	bgt $t1, 57 invalido #si es numero
	bge $t1, 48, numero
	
	#si pasa a este punto es invalido.
invalido:
	#anuncio el error por caracter invalido
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

letraMinuscula: 
	#le resto 87 para tener el numero equivalente a la letra en 0x
	addi $t1 $t1 -87
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
	
	#ya no necesito imprimir, no borre el codigo por si es necesario luego.
	b interpretarLobby

	#inicializamos t0 en programa para reusarlo como indice.
	add $t0 $s1 $0
	
imprimir:
	#se imprime el contenido de "programa"
	
	lw $a0 0($t0)
	beqz $a0 interpretarLobby
	
	#si cambio el orden puedo imprimir el 0x0000000, por efecto visual no lo imprimo.
	addi $t0 $t0 4
	li $v0 34
	syscall

	li $v0 4
	la $a0 barraN
	syscall	

	b imprimir
	
#########################################################################################
#Planificacion de registros Main
#########################################################################################
#      $t0 se guarda el tipo de instruccion.
#      $a0 paso de argumentos varios al syscall // contiene las palabras de "programa"
#	   En un momento dado guarda el codigo de operacion.	
#
#      $a0 guarda el registro destino de la instruccion a ejecutar 
#      $a1 guarda el registro fuente_1/ base  de la instruccion a ejecutar
#      $a2 guarda el registro fuente_2  de la instruccion a ejecutar
#      $a3 almacena el shamt/desplazamiento de la instruccion.
#
#      $v0 para el syscall // guarda la direccion de la instruccion para hacer el jal.
#      $s0 Guarda la direccion de inicio del programa que se esta ejecutando
#      $s1 contiene la instuccion que se esta ejecutando (equivalente al pc)
#      $s3 Direccion del arreglo de coop
#      $s4 Direccion de de la instruccion en coop

#########################################################################################

interpretarLobby:	
	#inicializar 
	la $s0 programa
	la $s3 coop
interpretar:
	
	lw $s1 0($s0)
	beqz $s1 imprimirReg
	
	move $a0 $s1
	li $v0 34
	syscall
	
	#imrpimir instruccion en 0x	
	la $a0 espacio
	li $v0 4
	syscall
	
	#aplico la mascara para luego en $a0 guardar el coop
	andi $a0 $s1 0xfc000000
	srl $a0 $a0 26 
	mul $s4 $a0 12	
	add $s4 $s4 $s3
	 
	#en $s3 tengo la direccion del arreglo 
	#en $s4 tengo la direccion del elemento
	beqz $s4 expansion #si es 0 directo a exp


	lh $t0 0($s4)
	#ahora tengo el formato de operaccion

	beq $t0 2 salto 
	beq $t0 1 inmediato
	beq $t0 0 registro
	
back:

	li $v0 4
	la $a0 barraN
	syscall		
	
	addi $s0 $s0 4 #me muevo a la siguiente instrucion.
	b interpretar

registro:
	
	#registro destino
	andi $a0 $s1 0x0000f800
	srl $a0 $a0 11
	
	##registro fuente 1
	andi $a1 $s1 0x03e00000
	srl $a1 $a1 21
	
	#registro fuente 2
	andi $a2 $s1 0x001f0000
	srl $a2 $a2 16
	
	#shamt
	andi $a3 $s1 0x000007c0
	sll $a3 $a3 21
	sra $a3 $a3 27
	
	lh $t3 2($s4)
	bnez $t3 expansion
		
	#cargo la instruccion en $v0
	lw $v0 4($s4)
	jal loobyCoop

b back

expansion:

	la $s5 _Tabla0
	andi $a0 $s1 0x0000003f
	sll $a0 $a0 3 #multiplico por 8
	add $a0 $a0 $s5 
	#en este punto tengo el apuntador a la pos de la instruccion
	
	#cargo la instruccion en $a0
	lw $v0 4($a0)
	jal loobyCoop

b back

inmediato:

	#registro destino
	andi $a0 $s1 0x001f0000
	srl $a0 $a0 16
	
	#registro base
	andi $a1 $s1 0x03e00000
	srl $a1 $a1 21
	
	#offset, desplazamiento
	andi $a3 $s1 0x0000ffff
	sll $a3 $a3 16
	sra $a3 $a3 16
	
	lw $v0 8($s4)
	jal loobyCoop

b back

salto:

	lw $a0 4($s4)
	li $v0 4
	syscall
	
	la $a0 espacio
	li $v0 4
	syscall
	
	andi $a0 $s1 0x03ffffff
	sll $a0 $a0 2
	li $v0 34
	syscall	
	
	lw $v0 8($s4)
	jal loobyCoop

b back

loobyCoop:
	jr $v0
	
	
imprimirReg:

	b fin

fin:	
	#anuncio el fin del programa.
	li $v0 4
	la $a0 msg
	syscall
	
	#fin.
	li $v0 10
	syscall

# Implementacion de las operaciones de la MLMV
__No: 
	li $v0 4
	la $a0 dollar
	syscall
	jr $ra   	# No hace nada. Se usa para el caso de los codigos de operacion 
		# no implementados en la arquitectura y evitar tener que preguntar 
		# si el coop existe o no en la maquina
		
__j:
	li $v0 4
	la $a0 _j
	syscall
	jr $ra
	
__jal:
	li $v0 4
	la $a0 _jal
	syscall
	jr $ra
	
__beq:
	li $v0 4
	la $a0 _beq
	syscall
	jr $ra
	
__bne:
	li $v0 4
	la $a0 _bne
	syscall
	jr $ra
	
__blez:
	li $v0 4
	la $a0 _blez
	syscall
	jr $ra
	
__bgtz:
	la $a0 _bgtz
	li $v0 4
	syscall
	jr $ra
	
__addi:

	sll $a1 $a1 2
	lw $a1 registros($a1)
	
	add $a1 $a1 $a3
	
	sll $a0 $a0 2
	sw $a1 registros($a0)
	
	la $a0 _addi
	li $v0 4
	syscall
	jr $ra

	
__addiu:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	la $a0 _addiu
	li $v0 4
	syscall
	jr $ra

		
__slti:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _slti
	li $v0 4
	syscall
	jr $ra

__sltiu:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sltiu
	li $v0 4
	syscall
	jr $ra

__andi:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	la $a0 _andi
	li $v0 4
	syscall
	jr $ra

__ori:

	sll $a1 $a1 2
	lw $a1 registros($a1)

	la $a0 _ori
	li $v0 4
	syscall
	jr $ra

__xori:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	la $a0 _bgtz
	li $v0 4
	syscall
	jr $ra

__llo:

	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	jr $ra	
__lb:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _lb
	li $v0 4
	syscall
	jr $ra

__lw:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _lw
	li $v0 4
	syscall
	jr $ra

__sb:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sb
	li $v0 4
	syscall
	jr $ra

__sh:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sh
	li $v0 4
	syscall
	jr $ra

__sw:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sw
	li $v0 4
	syscall
	jr $ra

__sll:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sll
	li $v0 4
	syscall
	jr $ra

__srl:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _srl
	li $v0 4
	syscall
	jr $ra

	
__sra:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sra
	li $v0 4
	syscall
	jr $ra

	
__sllv:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sllv
	li $v0 4
	syscall
	jr $ra

__srlv:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _srlv
	li $v0 4
	syscall
	jr $ra
	
__srav:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _srav
	li $v0 4
	syscall
	jr $ra

	
__jr:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _jr
	li $v0 4
	syscall
	jr $ra

	
__jalr:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _jalr
	li $v0 4
	syscall
	jr $ra

	
__mult:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _mult
	li $v0 4
	syscall
	jr $ra

	
__multu:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _multu
	li $v0 4
	syscall
	jr $ra

	
__div:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _div
	li $v0 4
	syscall
	jr $ra

	
__divu:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _divu
	li $v0 4
	syscall
	jr $ra

	
__add:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _add
	li $v0 4
	syscall
	jr $ra

		
__addu:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _addu
	li $v0 4
	syscall
	jr $ra

	
__sub:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _sub
	li $v0 4
	syscall
	jr $ra

	
__subu:

	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)
	
	la $a0 _subu
	li $v0 4
	syscall
	jr $ra

	
__and:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _and
	li $v0 4
	syscall
	jr $ra

	
__or:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	la $a0 _or
	li $v0 4
	syscall
	jr $ra

	
__xor:
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)


	la $a0 _xor
	li $v0 4
	syscall
	jr $ra

		
__nor:
	#obtiene el contenido de los registros fuente 1 y 2
	sll $a1 $a1 2
	lw $a1 registros($a1)

	sll $a2 $a2 2
	lw $a2 registros($a2)

	nor $t1 $a2 $a1
	
	sll $a0 $a0 2
	sw $t1 registros($a0)
	
	la $a0 _nor
	li $v0 4
	syscall
	jr $ra

