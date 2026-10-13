.data
primi: .space 400
str_primi: .asciiz "I numeri primi sono:\n"
str_msg: .asciiz "\nQuanti elementi vuoi inserire?: "
str_input: .asciiz "Scrivi il numero che vuoi inserire nell'array: "
spazio: .asciiz " "
prova: .asciiz "prova"
str_menu: .asciiz "\nChe opzione vuoi selezionare?\n0) Esci\n1) Ordinamento crecente vettore\n2) Media\n3) Mediana\n4) Stampa array\n5) Max \n6) Min\n7)Deviazione standard\n8)Numeri Primi\n"

.text

main: 
	#stampo la scritta str_msg
	li $v0, 4
	la $a0, str_msg
	syscall
	
	#l'utente inserisce il numero di elementi che vuole inserire. Moltiplico per 4 per allocare n byte
	li $v0, 5
	syscall
	
	move $s2, $v0		#numero di elementi 
	sll $a0, $v0, 2
	move $s0, $a0		
	#allocazione dinamica
	li $v0, 9 
	syscall
	
	move $s1, $v0
	move $t1, $s1	
	li $t0, 1 	#contatore, che parte da 1 per farlo allineare al numero di elementi richiesti. 
	jal riempi_array
	j menu
	
menu:
	la $a0, str_menu 
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	li $t0, 0 #contatore
	li $t2, 0 
	li $t1, 0
	li $t8, 0
	li $t4, 0 #var di controllo per max 
	li $t3, 0
	li $t9, 0
	la $s3, primi #s3 usato solo per i numeri primi
	
	move $t1, $s1	#array in $t1
	
	beq $v0, $zero, esci
	beq $v0, 1, bubblesort
	beq $v0, 2, media
	beq $v0, 3, mediana
	beq $v0, 4, stampa_array
	beq $v0, 5, max_numero
	beq $v0, 6, min_numero
	beq $v0, 7, deviazione_standard
	beq $v0, 8, numeri_primi
	
#--------------------#

esci: 
	li $v0, 10
	syscall

#--------------------#

bubblesort: 
	move $t1, $s1
	li $t7, 0
	bgt $t8, $s2, selettore
	sub $t6, $s2, $t8
	addi $t6, $t6, -1
	addi $t8, $t8, 1
	j ordinamento 

ordinamento: 
	bge $t7, $t6, bubblesort
	lw $t4, 0($t1)
	addiu $t1, $t1, 4
	lw $t5, 0($t1)
	addi $t7, $t7, 1
	bgt $t4,$t5, scambio
	j ordinamento
	
	
scambio: 
	sw $t4, 0($t1)
	sw $t5, -4($t1)
	j ordinamento


selettore: 
	bne $t2, 1, menu
	j stampa_mediana

#--------------------#

media:
	beq $t0, $s2, selettore_media	#controllo quante operazioni siano state fatte
	lw $t2, 0($t1)
	add $t3, $t3, $t2	#sommo tutti gli elementi del vettore
	addiu $t1, $t1, 4
	addiu $t0, $t0, 1
	j media



selettore_media: 	#la media serve anche per calcolare la deviazione standard. Selettore usato per capire se si tratta di DS o media pura
	mtc1 $t3, $f0
	mtc1 $s2, $f1
	cvt.s.w $f0, $f0
	cvt.s.w $f1,$f1
	
	div.s  $f12, $f0, $f1
	beq $t9, 1, torna_ra
	j stampa_media


stampa_media: 
	li $v0, 2
	syscall
	j menu

#--------------------#

mediana: 			#per calcolare la mediana ho bisogno di avere l'array ordinato
	li $t2,1
	j bubblesort 

stampa_mediana: 
	li $t2, 2	#in questo caso uso t2 come divisore
	div $s2, $t2
	mflo $t4 #quoziente
	mfhi $t5 #resto
	
	beq $t5, $zero, stampa_mediana_pari
	j stampa_mediana_dispari

stampa_mediana_pari: 		#nella mediana pari, si prendono i due elementi centrali

	addiu $t4, $t4, -1
	sll $t4, $t4, 2
	addu $t1, $t1, $t4
	lw $t3, 0 ($t1)
	
	li $a0, 0
	add $a0, $a0, $t3		#uso $t3 per sommare i due valori centrali della mediana
	
	lw $t3, 4($t1)
	add $a0, $a0, $t3
	
	mtc1 $a0, $f0
	mtc1 $t2, $f2
	cvt.s.w $f0, $f0
	cvt.s.w $f2, $f2
	
	div.s $f12, $f0, $f2
	li $v0, 2
	syscall

	j menu

stampa_mediana_dispari: 
	sll $t4, $t4, 2		#vincolo di allineamento
	addu $t1, $t1, $t4
	lw $a0, 0 ($t1)
	li $v0,1
	syscall
	j menu


#--------------------#

stampa_array:
	beq $t0, $s2,  menu	#controllo quante operazioni siano state fatte
	lw $t2, 0($t1)
	move $a0, $t2
	li $v0, 1	# li $v0, 1 per gli interi
	syscall	
	
	#stampa lo spazio fra un elemento e l'altro
	la $a0, spazio 
	li $v0, 4
	syscall
	
	addiu $t1, $t1, 4
	addiu $t0, $t0, 1
	j stampa_array
	
#--------------------#



max_numero: 
	bgt $t2, $s2, stampa_max_min
	lw $t5, 0($t1)
	bgt $t5, $t4, scambio_max
	addiu $t1, $t1, 4
	addiu $t2, $t2, 1 #incremento il contatore, per scorrere i vari elementi dell'array
	j max_numero
	
scambio_max:
	move $t4, $t5
	addiu $t1, $t1, 4
	addiu $t2, $t2, 1 
	j max_numero


min_numero: 
	bgt $t2, $s2, stampa_max_min
	lw $t5, 0($t1)
	blt $t5, $t4, scambio_min
	addiu $t1, $t1, 4
	addiu $t2, $t2, 1 #incremento il contatore, per scorrere i vari elementi dell'array
	j min_numero
	
scambio_min:
	move $t4, $t5
	addiu $t1, $t1, 4
	addiu $t2, $t2, 1 
	j min_numero
	
	
stampa_max_min: 
	move $a0, $t4	#ho usato una sola routine di stampa, andando a passare al registro argomento il registro da stampare
	li $v0, 1
	syscall
	j menu 	
	
	
#--------------------#

	
deviazione_standard: 
	#la formula è rad(somma(xi - media)^2/(N-elementi))
	#ottengo la media
	li $t9, 1	#uso t9 come flag da controllare nel selettore media
	jal media
	li $t0, 0	#la media aumenta t0, quindi lo reimposto a 0
	move $t1, $s1 	#reimposto t1, che viene sovrascritto dalla media
	mov.s $f4, $f12 #sposto la media calcolata da f12 in $f4
	mtc1 $zero, $f0 	#imposto f0 = 0.0
 	jal clc_somma_quadrati	
	jal rapporto_n_elementi
	

rapporto_n_elementi:
	mtc1 $s2, $f1 	#sposto il numero di elementi in un registro float
	cvt.s.w $f1, $f1	
	div.s $f2, $f0, $f1 	#divisione in virgola mobile della somma / N elementi
	sqrt.s $f12, $f2
	li $v0, 2
	syscall
	j menu 
	
clc_somma_quadrati: 
	
	beq $t0, $s2, torna_ra
	lw $t3, 0 ($t1)
	mtc1 $t3, $f3
	cvt.s.w $f3, $f3 	#l'elemento prelevato dal vettore convertito in singola precisione
	sub.s $f3, $f3, $f4 	#sottraggo all'elemento del vettore la media
	mul.s $f3, $f3, $f3 	#calcolo il quadrato
	add.s $f0, $f0, $f3	#uso $f0 per raccogliere il quadrato di tutti gli xi - media
	addiu $t0, $t0, 1
	addiu $t1, $t1, 4
	j clc_somma_quadrati
	




#--------------------#

numeri_primi: 

	beq $t0, $s2, selettore_primi
	lw $t4, 0($t1)
	li $t2, 2
	jal calcolo_n_primi
	addiu $t1, $t1, 4
	addiu $t0, $t0,1
	j numeri_primi
	
selettore_primi:
	la $s3, primi
	la $a0, str_primi 
	li $v0, 4
	syscall
	j stampa_primi
	
calcolo_n_primi: 
	div $t4, $t2
	mfhi $t3 	#salvo il resto il t3
	beqz $t3, torna_ra	
	addiu $t2, $t2, 1 #aumento il divisore
	mul $t5, $t2, $t2	#calcolo il quadrato del divisore
	bgt $t5, $t4, aggiungi_primo
	j calcolo_n_primi
	
aggiungi_primo: 
	sw $t4, 0($s3)
	addiu $t8, $t8, 1	#uso $t8 per contare quanti numeri primi inserisco in s3
	addiu $s3, $s3, 4
	addiu $t1, $t1, 4
	addiu $t0, $t0, 1
	j numeri_primi

stampa_primi: 
	beq $t9, $t8, menu
	lw $a0, 0($s3)	
	li $v0, 1
	syscall
	la $a0, spazio
	li $v0 4
	syscall
	addiu $s3, $s3, 4
	addiu $t9, $t9, 1
	j stampa_primi
	


#--------------------#


riempi_array: 
	li $v0, 4
	la $a0, str_input
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 0 ($t1)
	
	beq $t0, $s2, torna_ra
	addiu $t1, $t1,4
	addiu $t0, $t0, 1
	j riempi_array

#--------------------#


torna_ra: 
	jr $ra	
	

	
	
