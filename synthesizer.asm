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
#############   Main   #################
main:
	la $a0, mesBienvenue		# $a0 <- adr de mesBienvenue
	ori $v0, $0, 4
	syscall				# Affiche message bienvenue

	ori $a1, $0, 200		# $a1 <- 200 ms (durée)
	ori $a2, $0, 0			# $a2 <- piano (instrument)
	ori $a3, $0, 127		# $a3 <- 127 (volume)

loop:
	la $a0, sautLigne		# $a0 <- adr de sautLigne
	ori $v0, $0, 4
	syscall				# Revient à la ligne

	ori $v0, $0, 12
	syscall				# Lit caractère

	beq $v0, 32, endLoop		# endLoop si touche SPACE
	beq $v0, 61, instruSuiv		# instruSuiv si caractère =
	beq $v0, 38, changeInstru 	# changeInstru si caractère &
	beq $v0, 60, diminueDuree	# diminueDuree si caractère <
	beq $v0, 62, augmenteDuree	# augmenteDuree si caractère >
	j joueSon			# joueSon sinon

instruSuiv:
	subu $sp, $sp, 16		# OUV
	addiu $fp, $sp, 16		#
	jal fctInstruSuiv		#

	addiu $sp, $sp, 16		# FIN
	ori $a2, $v0, 0			#
	j loop

changeInstru:
	subu $sp, $sp, 16		# OUV
	addiu $fp, $sp, 16		#
	jal fctChangeInstru		#

	addiu $sp, $sp, 16		# FIN
	ori $a2, $v0, 0			#
	j loop

diminueDuree:
	subu $sp, $sp, 16		# OUV
	addiu $fp, $sp, 16		#
	jal fctDiminueDuree		#

	addiu $sp, $sp, 16		# FIN
	ori $a1, $v0, 0			#
	j loop

augmenteDuree:
	subu $sp, $sp, 16		# OUV
	addiu $fp, $sp, 16		#
	jal fctAugmenteDuree		#

	addiu $sp, $sp, 16		# FIN
	ori $a1, $v0, 0			#
	j loop

joueSon:
	ori $a0, $v0, 0			# $a0 <- caractère tapé
	subu $sp, $sp, 32		# OUV
	addiu $fp, $sp, 32		#
	sw $a0, 0($sp)			# 
	sw $a1, 4($sp)			#
	sw $a2, 8($sp)			#
	sw $a3, 12($sp)			#
	jal fctJoueSon			#

	lw $a0, 0($sp)			# FIN
	lw $a1, 4($sp)			#
	lw $a2, 8($sp)			#
	lw $a3, 12($sp)			#
	addiu $sp, $sp, 32		#
	j loop

endLoop:
	la $a0, mesFin			# $a0 <- adr de mesFin
	ori $v0, $0, 4
	syscall				# Affiche message fin
	ori $v0, $0, 10
	syscall				# Exit

###########   Functions   ##############

fctInstruSuiv:
	# Change l'instrument par le suivant
	# Arg : $a2 = instrument actuel
	# Ret : $v0 = instrument suivant
	subu $sp, $sp, 16		# PRO
	sw $ra, 0($sp)			#
	sw $fp, 4($sp)			#
	addiu $fp, $sp, 16		#

	bne $a2, 127, sinonIS		# Si $a2 != 127, on incrémente
	ori $a2, $0, 0			# Sinon, on réinitialise à 0
	j finIS
sinonIS:
	addi $a2, $a2, 1		# $a2++ (instrument suivant)
finIS:
	la $a0, mesChangeInstru		# $a0 <- adr de mesChangeInstru
	ori $v0, $0, 4
	syscall				# Affiche message change instrument
	add $a0, $a2, $0		# $a0 <- $a2 (valeur de l'instrument)
	ori $v0, $0, 1
	syscall				# Affiche valeur instrument

	ori $v0, $a2, 0			# EPI
	lw $ra, 0($sp)			#
	lw $fp, 4($sp)			#
	addiu $sp, $sp, 16		#
	jr $ra				#

########################################

fctChangeInstru:
	# Change l'instrument en demandant le numéro
	# Arg : $a2 = instrument actuel
	# Ret : $v0 = instrument suivant
	subu $sp, $sp, 16		# PRO
	sw $ra, 0($sp)			#
	sw $fp, 4($sp)			#
	addiu $fp, $sp, 16		#

	la $a0, mesChangeInstru		# $a0 <- adr de mesChangeInstru
	ori $v0, $0, 4
	syscall				# Affiche message change instrument
	ori $v0, $0, 5
	syscall				# Lit entier
	bgt $v0, 127, noChangeCI	# Si nouvel instrument > 127, pas de changement
	blt $v0, 0, noChangeCI		# Si nouvel instrument < 0, pas de changement
	j finCI
noChangeCI:
	ori $v0, $a2, 0
finCI:
	lw $ra, 0($sp)			# EPI
	lw $fp, 4($sp)			#
	addiu $sp, $sp, 16		#
	jr $ra				#

########################################

fctDiminueDuree:
	# Diminue de 20 ms la durée des sons
	# Arg : $a1 = durée actuelle
	# Ret : $v0 = durée actuelle - 20
	subu $sp, $sp, 16		# PRO
	sw $ra, 0($sp)			#
	sw $fp, 4($sp)			#
	addiu $fp, $sp, 16		#

	beq $a1, $0, finDD		# Si $a1 == 0, pas de changement
	addi $a1, $a1, -20		# $a1 <- $a1 - 20
	la $a0, mesDuree		# $a0 <- adr de mesDuree
	ori $v0, $0, 4
	syscall				# Affiche message durée sons
	add $a0, $a1, $0		# $a0 <- $a1 (valeur de la durée)
	ori $v0, $0, 1
	syscall				# Affiche valeur durée sons
finDD:
	ori $v0, $a1, 0			# EPI
	lw $ra, 0($sp)			#
	lw $fp, 4($sp)			#
	addiu $sp, $sp, 16		#
	jr $ra				#

########################################

fctAugmenteDuree:
	# Augmente de 20 ms la durée des sons
	# Arg : $a1 = durée actuelle
	# Ret : $v0 = durée actuelle + 20
	subu $sp, $sp, 16		# PRO
	sw $ra, 0($sp)			#
	sw $fp, 4($sp)			#
	addiu $fp, $sp, 16		#

	addi $a1, $a1, 20		# $a1 <- $a1 + 20
	la $a0, mesDuree		# $a0 <- adr de mesDuree
	ori $v0, $0, 4
	syscall				# Affiche message durée sons
	add $a0, $a1, $0		# $a0 <- $a1 (valeur de la durée)
	ori $v0, $0, 1
	syscall				# Affiche valeur durée sons

	ori $v0, $a1, 0			# EPI
	lw $ra, 0($sp)			#
	lw $fp, 4($sp)			#
	addiu $sp, $sp, 16		#
	jr $ra				#

########################################

fctJoueSon:
	# Joue un son selon le caractère donné et les autres paramètres
	# Args :
	# $a0 = caractère tapé
	# $a1 = durée (en ms)
	# $a2 = instrument
	# $a3 = volume
	subu $sp, $sp, 32		# PRO
	sw $ra, 0($sp)			#
	sw $fp, 4($sp)			#
	addiu $fp, $sp, 32		#

	la $t0, tabNotes		# $t0 <- adr liste caractères pour notes
	lw $t1, 0($t0)			# $t1 <- tabNotes[0]
	ori $t2, $a0, 0			# $t2 <- caractère tapé
	ori $a0, $0, 48			# $a0 <- 48 (indice + 48 = note)
tantQueJS:
	beq $t1, $t2, finTantQueJS	# Si le caractère corespond à une note
	beq $t1, -1, finJS		# Si le caractère ne correspond pas à une note
	addi $a0, $a0, 1		# $a0++ (note suivante)
	addi $t0, $t0, 4		# $t0 += 4 (adr suivante)
	lw $t1, 0($t0)			# $t1 <- tabNotes[suiv]
	j tantQueJS
finTantQueJS:				# $a0 contient la note
	ori $v0, $0, 31
	syscall				# Joue le son
finJS:
	lw $ra, 0($sp)			# EPI
	lw $fp, 4($sp)			#
	addiu $sp, $sp, 32		#
	jr $ra				#
