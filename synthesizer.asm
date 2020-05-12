# Synthétiseur MIPS
# Quentin DESCHAMPS, Majda EL ATIA

	.data
mesBienvenue:
	.asciiz "Bienvenue sur le synthetiseur MIPS !"
mesFin:
	.asciiz "A bientot sur le synthetiseur MIPS !\n"
sautLigne:
	.asciiz "\n"
mesChangeInstru:
	.asciiz "\nChangement d'instrument : "
mesDuree:
	.asciiz "\nDuree des sons en ms : "
tabNotes:
	.word 97, 233, 122, 34, 101, 114, 40, 116, 45, 121, 232, 117,
	105, 231, 111, 224, 112, 119, 115, 120, 100, 99, 102, 118,
	98, 104, 110, 106, 44, 59, 108, 58, 109, 33, 249, -1


	.text
main:
	la $a0, mesBienvenue		# $a0 <- adr de mesBienvenue
	ori $v0, $0, 4
	syscall				# Affiche message bienvenue

	ori $t0, $0, 32			# $t0 <- SPACE
	ori $t1, $0, 61			# $t1 <- '='
	ori $t2, $0, 38			# $t2 <- '&'
	ori $t6, $0, 60			# $t6 <- '<'
	ori $t7, $0, 62			# $t7 <- '>'
	ori $a1, $0, 200		# $a1 <- 200 ms (durée)
	ori $a2, $0, 0			# $a2 <- piano (instrument)
	ori $a3, $0, 127		# $a3 <- 127 (volume)

loop:
	la $a0, sautLigne		# $a0 <- adr de sautLigne
	ori $v0, $0, 4
	syscall				# Revient à la ligne

	ori $v0, $0, 12
	syscall				# Lit caractère

	beq $v0, $t0, endLoop		# endLoop si touche SPACE
	beq $v0, $t1, instruSuiv	# instruSuiv si caractère =
	beq $v0, $t2, changeInstru 	# changeInstru si caractère &
	beq $v0, $t6, diminueDuree	# diminueDuree si caractère <
	beq $v0, $t7, augmenteDuree	# augmenteDuree si caractère >
	j joueSon			# joueSon sinon

instruSuiv:
	bne $a2, 127, sinon		# Si $a2 != 127, on incrémente
	ori $a2, $0, 0			# Sinon, on réinitialise à 0
	j suite
sinon:
	addi $a2, $a2, 1		# $a2++ (instrument suivant)
suite:
	la $a0, mesChangeInstru		# $a0 <- adr de mesChangeInstru
	ori $v0, $0, 4
	syscall				# Affiche message change instrument
	add $a0, $a2, $0		# $a0 <- $a2 (valeur de l'instrument)
	ori $v0, $0, 1
	syscall				# Affiche valeur instrument
	j loop

changeInstru:
	la $a0, mesChangeInstru		# $a0 <- adr de mesChangeInstru
	ori $v0, $0, 4
	syscall				# Affiche message change instrument
	ori $v0, $0, 5
	syscall				# Lit entier
	bgt $v0, 127, loop		# Si nouvel instrument > 127, pas de changement
	blt $v0, 0, loop		# Si nouvel instrument < 0, pas de changement
	ori $a2, $v0, 0			# $a2 <- nouvel instrument
	j loop

diminueDuree:
	beq $a1, $0, loop		# Si $a1 == 0, recommence le loop
	addi $a1, $a1, -20		# $a1 <- $a1 - 20
	la $a0, mesDuree		# $a0 <- adr de mesDuree
	ori $v0, $0, 4
	syscall				# Affiche message durée sons
	add $a0, $a1, $0		# $a0 <- $a1 (valeur de la durée)
	ori $v0, $0, 1
	syscall				# Affiche valeur durée sons
	j loop

augmenteDuree:
	addi $a1, $a1, 20		# $a1 <- $a1 + 20
	la $a0, mesDuree		# $a0 <- adr de mesDuree
	ori $v0, $0, 4
	syscall				# Affiche message durée sons
	add $a0, $a1, $0		# $a0 <- $a1 (valeur de la durée)
	ori $v0, $0, 1
	syscall				# Affiche valeur durée sons
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
	syscall				# Joue le son
	j loop

endLoop:
	la $a0, mesFin			# $a0 <- adr de mesFin
	ori $v0, $0, 4
	syscall				# Affiche message fin
	ori $v0, $0, 10
	syscall				# Exit
