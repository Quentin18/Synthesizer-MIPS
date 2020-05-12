# Synthétiseur MIPS
# Quentin DESCHAMPS, Majda EL ATIA

	.data
mesBienvenue:
	.asciiz "Bienvenue sur le synthetiseur MIPS !\n"
mesFin:
	.asciiz "\nA bientot sur le synthetiseur MIPS !\n"
mesChangeInstru:
	.asciiz "\nChangement d'instrument : "
tabNotes:
	.word 97, 233, 122, 34, 101, 114, 40, 116, 45, 121, 232, 117,
	105, 231, 111, 224, 112, 119, 115, 120, 100, 99, 102, 118,
	98, 104, 110, 106, 44, 59, 108, 58, 109, 33, 249, -1


	.text
main:
	la $a0, mesBienvenue		# $a0 <- adr de mesBienvenue
	ori $v0, $0, 4
	syscall				# Affiche message bienvenue
	
	ori $t1, $0, 32			# $t1 <- SPACE
	ori $t2, $0, 38			# $t2 <- '&'
	ori $a2, $0, 58			# $a2 <- piano (instrument)
loop:
	ori $v0, $0, 12
	syscall				# Lire caractère
	
	beq $v0, $t1, endLoop		# endLoop si touche SPACE
	bne $v0, $t2, joueSon 		# changeInstru si caractère &, joueSon sinon

changeInstru:
	la $a0, mesChangeInstru		# $a0 <- adr de mesChangeInstru
	ori $v0, $0, 4
	syscall				# Affiche message change instrument
	ori $v0, $0, 5
	syscall				# Lire entier
	ori $a2, $v0, 0			# $a2 <- nouvel instrument
	j loop

joueSon:				# $v0 contient le caractère
	la $t3, tabNotes		# $t3 <- adr liste caractères pour notes
	lw $t4, 0($t3)			# $t4 <- tabNotes[0]
	ori $t5, $0, -1			# $t5 <- -1 (valeur stop)
	ori $a0, $0, 48			# $a0 <- 48 (indice + 48 = note)
tantQueJS:
	beq $t4, $v0, finTantQueJS	# Si le caractère corespond à une note
	beq $t4, $t5, loop		# Si le caractère ne correspond pas à une note
	addi $a0, $a0, 1		# $a0++ (note suivante)
	addi $t3, $t3, 4		# $t3 += 4 (adr suivante)
	lw $t4, 0($t3)			# $t4 <- tabNotes[suiv]
	j tantQueJS
finTantQueJS:				# $a0 contient la note
	ori $v0, $0, 31
	ori $a1, $0, 200		# $a1 <- 200 ms (durée)
	ori $a3, $0, 127		# $a3 <- 127 (volume)
	syscall				# Jouer le son
	j loop

endLoop:
	la $a0, mesFin			# $a0 <- adr de mesFin
	ori $v0, $0, 4
	syscall				# Affiche message fin
	ori $v0, $0, 10
	syscall				# Exit
