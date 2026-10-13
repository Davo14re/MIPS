.data

stringa_g1: .asciiz "Ciao, inserisci il nome per giocatore 1 (sarai la X): \n"
stringa_g2: .asciiz "Inserisci il nome per giocatore 2 (sarai O): \n"
str_g1: .asciiz "In che posizione vuoi inserire la X giocatore 1: "
str_g2: .asciiz "In che posizione vuoi inserire la O giocatore 2: "
str_err: .asciiz "L'input inserito non va bene, riprova!\n"
str_parr: .asciiz "La partita è finita in pareggio"
str_vittoria: .asciiz "Ha vinto: "
nome1: .space 20 
nome2: .space 20
tabella: .byte '-', '-', '-', '-', '-', '-', '-', '-', '-'

.text 

main: 
	
	#Stampo a video la stringa del g1
	la $a0, stringa_g1
	li $v0, 4 # il codice 4 stampa la stringa
	syscall
	
	#Chiedo nome giocatore 1
	la $a0, nome1
	li $a1, 20   #legge al massimo 20 caratteri
	li $v0, 8
	syscall	    #legge e salva a partire dall'indirizzo contenuto in a0
	
	#Stampo a video la stringa del g2
	la $a0, stringa_g2
	li $v0, 4
	syscall
	
	#Chiedo nome giocatore 2
	la $a0, nome2 
	li $a1, 20
	li $v0, 8
	syscall
	move $s0, $zero #pseudoistruzione, uso il registro s0 come registro "flag" per capire se il gioco è finito o meno
	
	#inserisco nei registri i valori che poi uso per il controllo
	li $t1, 0
	li $t2, 3 #carico in registro il valore della costante da controllare per il print
	li $t3, 9
	li $s2, 'X'
	li $s3, 'O'
	li $s6, '-'
	add $s4, $s2,$s2		#s2 = X e sommo il valore ascii di X per tre volte
	add $s4,$s4, $s2
	add $s5, $s3,$s3		#s3 = O e sommo il valore ascii di X per tre volte
	add $s5,$s5, $s3
	li $t7, 0 #contatore per le mosse
	
	j gioco

gioco:	
	jal stampa_tb
	jal giocatore1
	jal stampa_tb
	jal vittoria_controllo_X
	jal vittoria_controllo_O
	beq $t7, 9 , pareggio
	jal giocatore2
	jal vittoria_controllo_X
	jal vittoria_controllo_O
	beq $t7, 9 , pareggio
	j gioco


vittoria_controllo_X:
	addiu $sp, $sp, -4 #cresce dall'alto verso il basso, per evitare di perdere il return address, lo devo salvare nello stack
    	sw $ra, 0($sp)
	la $t0, tabella
	li $a0, 0
	li $a1, 1
	li $a2, 2
	jal controlla_tripla
	
	li $a0, 0
	li $a1, 3
	li $a2, 6
	jal controlla_tripla
	
	li $a0, 0
	li $a1, 4
	li $a2, 8
	jal controlla_tripla
	
	li $a0, 1
	li $a1, 4
	li $a2, 7
	jal controlla_tripla
	
	li $a0, 2
	li $a1, 5
	li $a2, 8
	jal controlla_tripla
	
	li $a0, 2
	li $a1, 4
	li $a2, 6
	jal controlla_tripla
	
	li $a0, 3
	li $a1, 4
	li $a2, 5
	jal controlla_tripla
	
	li $a0, 6
	li $a1, 7
	li $a2, 8
	jal controlla_tripla
	
	lw $ra, 0($sp)
    	addiu $sp, $sp, 4

    	jr $ra
	
controlla_tripla:
	li $t9, 0
	addu $t5, $t0, $a0
	lb $t4, 0($t5)
	addu $t9, $t9, $t4
	
	addu $t5, $t0,$a1
	lb $t4, 0($t5)
	addu $t9, $t9, $t4
	
	addu $t5, $t0,$a2
	lb $t4, 0($t5)
	addu $t9, $t9, $t4
	
	beq $t9, $s4, fine1
	jr $ra
	
vittoria_controllo_O:
	addiu $sp, $sp, -4 #cresce dall'alto verso il basso, per evitare di perdere il return address, lo devo salvare nello stack
    	sw $ra, 0($sp)
	la $t0, tabella
	li $a0, 0
	li $a1, 1
	li $a2, 2
	jal controlla_tripla_O
	
	li $a0, 0
	li $a1, 3
	li $a2, 6
	jal controlla_tripla_O
	
	li $a0, 0
	li $a1, 4
	li $a2, 8
	jal controlla_tripla_O
	
	li $a0, 1
	li $a1, 4
	li $a2, 7
	jal controlla_tripla_O
	
	li $a0, 2
	li $a1, 5
	li $a2, 8
	jal controlla_tripla_O
	
	li $a0, 2
	li $a1, 4
	li $a2, 6
	jal controlla_tripla_O
	
	li $a0, 3
	li $a1, 4
	li $a2, 5
	jal controlla_tripla_O
	
	li $a0, 6
	li $a1, 7
	li $a2, 8
	jal controlla_tripla_O
	
	
	lw $ra, 0($sp)
    	addiu $sp, $sp, 4

    	jr $ra
	
controlla_tripla_O:
	li $t9, 0
	addu $t5, $t0, $a0
	lb $t4, 0($t5)
	addu $t9, $t9, $t4
	
	addu $t5, $t0,$a1
	lb $t4, 0($t5)
	addu $t9, $t9, $t4
	
	addu $t5, $t0,$a2
	lb $t4, 0($t5)
	addu $t9, $t9, $t4
	
	beq $t9, $s4, fine2
	jr $ra	
	
	
giocatore1: 
	la $t0, tabella
	#Stampo a video la stringa del str_g1
	la $a0, str_g1
	li $v0, 4 # il codice 4 stampa la stringa
	syscall
	
	
	#leggo un intero
	li $v0, 5
	syscall	    #legge e salva a partire dall'indirizzo contenuto in a0
	
	bgt $v0, $t3, errore1 #riuso il registro $t3 che contiene 9
	blez $v0, errore1 #salta se è uguale o minore di zero
	
	addiu $v0, $v0, -1	#per allinearlo con l'indice dell'array
	addu $t0, $t0, $v0
	lb $t6, 0($t0) 
	bne $t6, $s6, errore1
	sb $s2, 0($t0)
	addiu $t7, $t7, 1
	jr $ra

giocatore2: 
	la $t0, tabella
	#Stampo a video la stringa del str_g1
	la $a0, str_g2
	li $v0, 4 # il codice 4 stampa la stringa
	syscall
	
	
	#leggo un intero
	li $v0, 5
	syscall	    #legge e salva a partire dall'indirizzo contenuto in a0
	
	bgt $v0, $t3, errore2 #riuso il registro $t3 che contiene 9
	blez $v0, errore2 #salta se è uguale o minore di zero
	
	addiu $v0, $v0, -1	#per allinearlo con l'indice dell'array
	addu $t0, $t0, $v0
	lb $t6, 0($t0) 
	bne $t6, $s6, errore2
	sb $s3, 0($t0)
	addiu $t7, $t7, 1
	jr $ra
	
errore1: 
	#Stampo a video la stringa errore
	la $a0, str_err
	li $v0, 4 # il codice 4 stampa la stringa
	syscall
	j giocatore1

errore2: 
	#Stampo a video la stringa errore
	la $a0, str_err
	li $v0, 4 # il codice 4 stampa la stringa
	syscall
	j giocatore2	
	
stampa_tb: 
	la $t0, tabella
    	li $t1, 0
    	li $t2, 3	
stampa:
	lb $a0, 0($t0)
    	li $v0, 11
    	syscall

    	addiu $t0, $t0, 1
    	addiu $t1, $t1, 1

    	beq $t1, $t2, vai_capo

    	j stampa

vai_capo:

    	li $a0, '\n'
    	li $v0, 11
    	syscall

    	beq $t2, $t3, torna_gioco

    	addiu $t2, $t2, 3
    	j stampa
    	
torna_gioco: 
	jr $ra	
	
fine1: 
 	# stampa "Ha vinto "
    	la $a0, str_vittoria
    	li $v0, 4
    	syscall

    	# stampa il nome del giocatore 1
    	la $a0, nome1
    	li $v0, 4
    	syscall

    	# termina programma
    	li $v0, 10
    	syscall
    	
fine2: 
 	# stampa "Ha vinto "
    	la $a0, str_vittoria
    	li $v0, 4
    	syscall

    	# stampa il nome del giocatore 1
    	la $a0, nome2
    	li $v0, 4
    	syscall

    	# termina programma
    	li $v0, 10
    	syscall 
    	

pareggio: 

    	la $a0, str_parr
    	li $v0, 4
    	syscall
    	
	# termina programma
    	li $v0, 10
    	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	 

