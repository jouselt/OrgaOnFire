## Archivo fase2-09-10282.s
# Descripcioin: lee el archivo programa.txt, pasa de letras a hexadecimales, se almacenan 
# en programa el bloque de memoria y luego son interpretadas como instrucciones. 
# autor: Jouselt Fernandez
# Fecha: 11/11/2014

	.data

buffer	:	.space 10
fileName:	.space 20
ask	:	.asciiz "\nIndique nombre del archivo a compilar: "
msg	:	.asciiz "Fin. \n"
err   	:	.ascii "\nError solo se permiten caracteres hexadecimales [0..F]  "
		.ascii "o tal vez estas usando un archivo creado en linux, ver Nota en "
		.ascii "linea 51"
barraN	:	.asciiz "\n"
espacio	:	.asciiz " "
dollar	:	.asciiz " $"
msgReg	:	.asciiz "Registros\n"

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
	.word 0 0 __No		# coop 24 llo
	.word 0 0 __No		# coop 25 lhi
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
	
	la $t9 pila
	sw $t0 registros + 116
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
#      $a0 pasa el numero de registro destino de la instruccion a ejecutar
#      $a1 pasa el numero de registro fuente_1/ base  de la instruccion a ejecutar
#      $a2 pasa el numero de registro fuente_2  de la instruccion a ejecutar
#      $a3 almacena el shamt/desplazamiento de la instruccion.
#
#      $v0 para el syscall // guarda la direccion de la instruccion para hacer el jal.
#      $s0 Guarda la direccion de inicio de "pc" 
#      $s1 contiene la instuccion que se esta ejecutando 
#      $s3 Direccion del arreglo de coop
#      $s4 Direccion de de la instruccion en coop

#########################################################################################

interpretarLobby:	
	#inicializar 
	la $s0 programa
	sw $s0 contador
	la $s3 coop
interpretar:
	
	lw $s1 0($s0) 
	#por convencion mia $s0 tiene la direccion de la proxima instruccion a ejecutar.
	beqz $s1 imprimirReg
	
	#imprimiedo la instruccion en Hexadecimal
	move $a0 $s1
	li $v0 34
	syscall
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
	b fin #imposible que caiga aca.
	
back:

	li $v0 4
	la $a0 barraN
	syscall		
	#flech
	lw $s0 contador
	addi $t0 $s0 4 #muevo el pc a la siguiente instrucion.
	sw $t0 contador
	b interpretar

registro:
	
	#registro destino
	andi $a0 $s1 0x0000f800
	srl $a0 $a0 9
	#copiando en a0 el la direccion del registro.
	la $a0 registros($a0)
	
	#registro fuente 1
	andi $a1 $s1 0x03e00000
	srl $a1 $a1 19
	#en $a1 tengo el numero de registro >>21 <<2
	#lo multiplico por 4 para tener el apuntador al registro virtual.
	la $a1 registros($a1)
	
	#registro fuente 2
	andi $a2 $s1 0x001f0000
	srl $a2 $a2 14
	la $a2 registros($a2)
	
	#shamt
	andi $a3 $s1 0x000007c0
	sll $a3 $a3 21
	sra $a3 $a3 27
	
	lh $t3 2($s4)
	bnez $t3 expansion

	#cargo la instruccion en $t0 para saltar.
	lw $t0 4($s4)
	jalr $t0

b back

expansion:

	la $s5 _Tabla0
	andi $t0 $s1 0x0000003f
	sll $t0 $t0 3 #multiplico por 8
	add $t0 $t0 $s5 
	#en este punto tengo el apuntador de la instruccion
	#cargo la instruccion en $v0 y me preparo para llamar la funcion.
	lw $t0 4($t0)
	jalr $t0

b back

inmediato:

	#registro destino
	andi $a0 $s1 0x001f0000
	srl $a0 $a0 16
	sll $a0 $a0 2
	la $a0 registros($a0)	
	
	#registro base
	andi $a1 $s1 0x03e00000
	srl $a1 $a1 21
	sll $a1 $a1 2
	la $a1 registros($a1)
	
	#offset, desplazamiento
	andi $a3 $s1 0x0000ffff
	sll $a3 $a3 16
	sra $a3 $a3 16
	
	lw $t0 8($s4)
	jalr $t0

b back

salto:
	#toma los primeros 4 bits del "pc"
	lw $s0 contador	
	andi $t0 $s0 0xf0000000	
	
	#obtengo la direccion de salto y la multiplico por 4
	andi $t1 $s1 0x03ffffff
	sll $t1 $t1 2

	#la junto los primeros 4 bits del pc con la direccion desplazada.
	or $a0 $t0 $t1

	lw $t0 8($s4)
	jalr $t0

b back


	
	
imprimirReg:

	li $v0 4
	la $a0 msgReg
	syscall

	#imprime el contenido de los registros en hexadecimal.
	la $t0 registros
	li $t1 0
	li $t2 32
	
sig:	li $v0 4
	la $a0 dollar
	syscall
	
	add $a0 $t1 $0
	li $v0 1
	syscall
	
	li $v0 4
	la $a0 espacio
	syscall	
	
	lw $a0 ($t0)
	li $v0 34
	syscall
	
	la $a0 barraN
	li $v0 4
	syscall
	
	addi $t0 $t0 4
	addi $t1 $t1 1
	#si no he llegado al 31 sigo imprimiendo.	
	bne $t1 $t2 sig
	#al llegar al final salto a terminar el programa.
#	b fin

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
	la $a0 barraN
	syscall
	jr $ra  # No hace nada. Se usa para el caso de los codigos de operacion 
		# no implementados en la arquitectura y evitar tener que preguntar 
		# si el coop existe o no en la maquina
		
__j:
	sw $a0 contador
	jr $ra
	
__jal:
	#cargo el pc y lo guardo en el registro 31 ($ra)
	lw $t0 contador
	sw $t0 registros+124 
	
	#cambio el pc con la nueva direccion.
	sw $a0 contador
	
	jr $ra
	
__beq:
	#pasando el contenido del registro a $t1 para usarlo
	lw $t1 0($a1)
	#pasando el contenido del registro a $t2 para comparar
	lw $t0 0($a0)
	
	#si el contenido de ambos registros es igual salta a siB
	beq $t1 $t0 siB
	b finBranch #no son iguales me salgo.
	
__bne:
	#pasando el contenido del registro a $t1 para usarlo
	lw $t1 0($a1)
	#pasando el contenido del registro a $t2 para comparar
	lw $t0 0($a0)
	#si el contenido de ambos registros es diferete salta a siB
	bne $t1 $t0 siB

	b finBranch #no son iguales me salgo.
	
__blez:
	#pasando el contenido del registro a $t1 para usarlo
	lw $t1 0($a1)
	
	#si el contenido del registro es menor que zero salta a sib
	blez $t1 siB
	b finBranch #no son iguales me salgo.
	
__bgtz:
	#pasando el contenido del registro a $t1 para usarlo
	lw $t1 0($a1)
	
	#si el contenido del registro es mayor a zero salta a sib4
	bgtz $t1 siB
	b finBranch #no se cumple; Me salgo.

siB:	#recordando que en $a3 esta la cantidad de palabras a saltar.
	sll $t3 $a3 2 #multiplico por 4 para tener la cantidad de palabras.
	lw $t0 contador 
	add $t0 $t0 $t3
	#finalmente sumamos (cantidad de palabras)*4 al pc 
	sw $t0 contador

finBranch:
	jr $ra
	
__addi:

	lw $t1 0($a1)
	add $t0 $t1 $a3
	sw $t0 0($a0)
	
	la $a0 _addi
	li $v0 4
	syscall
	jr $ra

__addiu:	 
	lw $t1 0($a1)
	addu $t0 $t1 $a3
	sw $t0 0($a0)
	
	la $a0 _addiu
	li $v0 4
	syscall
	
	jr $ra
	
__slti: 
	lw $t1 0($a1)
	slt $t0 $t1 $a3
	sw $t0 0($a0)
 
	la $a0 _slti
	li $v0 4
	syscall
	jr $ra

__sltiu:
	 
	lw $t1 0($a1)
	sltu $t0 $t1 $a3
	sw $t0 0($a0)

	la $a0 _sltiu
	li $v0 4
	syscall
	jr $ra

__andi:	 
	lw $t1 0($a1)
	and $t1 $t1 $a3
	sw $t1 0($a0)
	
	la $a0 _andi
	li $v0 4
	syscall
	jr $ra

__ori:
	lw $t1 0($a1)
	or $t1 $t1 $a3
	sw $t1 0($a0)

	la $a0 _ori
	li $v0 4
	syscall
	jr $ra

__xori:
 	lw $t1 0($a1)
	xor $t1 $t1 $a3
	sw $t1 0($a0)

	la $a0 _xori
	li $v0 4
	syscall
	jr $ra

__lb:	 
	lw $t1 0($a1)
	#memoria+inmediato+contenido del registro base
	addu $t4 $a3 $t1
	lb $t1 memoria+0($t4)

	la $a0 _lb
	li $v0 4
	syscall
	jr $ra

__lw:
	 
	lw $t1 0($a1)
	#memoria+inmediato+contenido del registro base
	addu $t4 $a3 $t1
	lw $t1 memoria+0($t4)
	
	la $a0 _lw
	li $v0 4
	syscall
	jr $ra

__sb:
	lw $t1 0($a1)
	#memoria+inmediato+contenido del registro base
	addu $t4 $a3 $t1
	sb $t1 memoria+0($t4)

	la $a0 _sb
	li $v0 4
	syscall
	jr $ra

__sh:
	lw $t1 0($a1)
	#memoria+inmediato+contenido del registro base
	addu $t4 $a3 $t1
	sh $t1 memoria+0($t4)
	
	la $a0 _sh
	li $v0 4
	syscall
	jr $ra

__sw:
	 
	lw $t1 0($a1)
	#memoria+inmediato+contenido del registro base
	addu $t4 $a3 $t1
	sw $t1 memoria+0($t4)

	la $a0 _sw
	li $v0 4
	syscall
	jr $ra

__sll:
	lw $t1 0($a1)
	sllv $t1 $t1 $a3
	sw $t1 0($a0)
	
	la $a0 _sll
	li $v0 4
	syscall
	jr $ra

__srl:
	lw $t1 0($a1)
	srlv $t0 $t1 $a3	
	sw $t0 0($a0)
		
	la $a0 _srl
	li $v0 4
	syscall
	jr $ra

__sra:
	lw $t1 0($a1)
	srav $t0 $t1 $a3
	sw $t0 0($a0)

	la $a0 _sra
	li $v0 4
	syscall
	jr $ra

__sllv:
	lw $t1 0($a1)
	lw $t2 0($a2)
	sllv $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _sllv
	li $v0 4
	syscall
	jr $ra

__srlv:
	lw $t1 0($a1)
	lw $t2 0($a2)
	srlv $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _srlv
	li $v0 4
	syscall
	jr $ra
	
__srav:
	lw $t1 0($a1)
	lw $t2 0($a2)
	srav $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _srav
	li $v0 4
	syscall
	jr $ra

__jr:
	lw $t1 0($a1)
	sw $t1 contador
		
	la $a0 _jr
	li $v0 4
	syscall
	jr $ra
	
__jalr:	
	lw $t2 contador
	sw $t2 registros+124
	lw $t1 0($a1)
	sw $t1 contador

	la $a0 _jalr
	li $v0 4
	syscall
	jr $ra
	
__mult:	
	lw $t1 0($a1)
	lw $t2 0($a2)
	mul $t0 $t1 $t2
	sw $t0 0($a0)
	
	la $a0 _mult
	li $v0 4
	syscall
	jr $ra

	
__multu:
	lw $t1 0($a1)
	lw $t2 0($a2)
	mulu $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _multu
	li $v0 4
	syscall
	jr $ra

	
__div:
	lw $t1 0($a1)
	lw $t2 0($a2)
	div $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _div
	li $v0 4
	syscall
	jr $ra

	
__divu:
	lw $t1 0($a1)
	lw $t2 0($a2)
	divu $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _divu
	li $v0 4
	syscall
	jr $ra

	
__add:
	 
	lw $t1 0($a1)
	lw $t2 0($a2)
	add $t0 $t1 $t2
	sw $t0 ($a0)
	
	la $a0 _add
	li $v0 4
	syscall
	jr $ra

		
__addu:

	lw $t1 0($a1)
	lw $t2 0($a2)
	addu $t0 $t1 $t2
	sw $t0 0($a0)
	
	la $a0 _addu
	li $v0 4
	syscall
	jr $ra
__sub:
	 
	lw $t1 0($a1)
	lw $t2 0($a2)
	sub $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _sub
	li $v0 4
	syscall
	jr $ra

__subu:	
	lw $t1 0($a1)
	lw $t2 0($a2)
	subu $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _subu
	li $v0 4
	syscall
	jr $ra
	
__and:
	lw $t1 0($a1)
	lw $t2 0($a2)
	and $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _and
	li $v0 4
	syscall
	jr $ra

	
__or:
	lw $t1 0($a1)
	lw $t2 0($a2)
	or $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _or
	li $v0 4
	syscall
	jr $ra

__xor:	 
	lw $t1 0($a1)
	lw $t2 0($a2)
	xor $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _xor
	li $v0 4
	syscall
	jr $ra

		
__nor:
	#obtiene el contenido de los registros fuente 1 y 2
	 
	lw $t1 0($a1)
	lw $t2 0($a2)
	nor $t0 $t1 $t2
	sw $t0 0($a0)

	la $a0 _nor
	li $v0 4
	syscall
	jr $ra
	