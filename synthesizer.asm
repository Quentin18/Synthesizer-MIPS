	.data
mesBienvenue:
	.asciiz "Bienvenue sur le synthetiseur MIPS !\n"
mesFin:
	.asciiz "\nA bientot sur le synthetiseur MIPS !\n"
mesChangeInstru:
	.asciiz "\nChangement d'instrument : " 


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

joueSon:
	addi $a0, $v0, -37		# $a0 <- note correspondante à la touche
	ori $v0, $0, 31
	ori $a1, $0, 100		# $a1 <- 100 ms (durée)
	ori $a3, $0, 127		# $a3 <- 100 (volume)
	syscall				# Jouer le son
	j loop

endLoop:
	la $a0, mesFin			# $a0 <- adr de mesFin
	ori $v0, $0, 4
	syscall				# Affiche message fin
	ori $v0, $0, 10
	syscall				# Exit
