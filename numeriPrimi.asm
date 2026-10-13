.data 
input_text: .asciiz "Inserisci un numero intero: "
output_notext: .asciiz "Il numero inserito non è primo"
output_text: .asciiz "Il numero inserito è primo"
.text
.globl main 


main: 
	#stampa la richiesta
	li $v0, 4
	la $a0, input_text 
	syscall
	
	#legge il numero 
	li $v0, 5			#salva il numero in v0
	syscall
	#salva il numero 
	move $s1,$v0			#sposta il numero da v0 in t0
	
	#stampa il numero 
#	li $v0, 1
#	move $a0, $s1
#	syscall
	
	la $t0, controllo_nPrimo
	jr $t0

controllo_nPrimo: 
	li $t1, 2 # carico in t1 la costante immediata 2

loop: 	div $s1, $t1
	mfhi $t2  	#salvo il resto della divisione in t2
	beqz $t2, exit_noPrimo
	addi $t1, $t1, 1	#aumento il contatore divisore
	mul $t3, $t1, $t1	#calcolo il quadrato del divisore
	bge $t3, $s1, exit	#se il quadrato del divisore è maggiore del numero inserito interrompo la procedura
	j loop
	

exit_noPrimo: 
	#stampa la conferma che il numero non sia primo
	li $v0, 4
	la $a0, output_notext
	syscall
	li $v0, 10
	syscall

exit: 
	#stampa la conferma che il numero non sia primo
	li $v0, 4
	la $a0, output_text
	syscall
	li $v0, 10
	syscall


