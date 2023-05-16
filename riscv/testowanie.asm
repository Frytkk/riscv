.globl main
.data
prompt1: .ascii "Enter first number (binary64 IEEE 754): "
prompt2: .ascii "\nEnter second number (U2): "
buff1:	.align 3
	.space 64
buff2:	.space 32

	.text
main:
	# Wyœwietlenie proœby o podanie pierwszej liczby
	la a0, prompt1
	li a7, 4
	ecall

	# Wczytanie pierwszej liczby
	la a0, buff1
	li a1, 64
	li a7, 8
	ecall
	
	# Skonwertowanie pierwszej liczby na double
	fmv.w.x fa0, x0 # wyzerowanie rejestru fa0
	li t0, 0x7FF00000 # liczba 2^1023 zapisana w formacie IEEE 754
	addi t1, x0, 63 # inicjalizacja licznika pêtli
loop1:
	lbu t2, 0(a0) # pobranie kolejnego znaku
	beqz t2, endloop1 # jeœli koniec ci¹gu, zakoñcz pêtlê
	#slli t3, t1, 52 # obliczenie wartoœci przesuniêcia
	
	slli t3, t1, 31     # przesuniêcie o 31 bitów
	slli t3, t3, 21     # przesuniêcie o dodatkowe 21 bitów

	add t4, t0, t3 # dodanie wartoœci przesuniêcia do 2^1023
	slli t3, t2, 3 # przesuniêcie znaku w lewo o 3 bity
	#andi t5, t4, 0x7FEFFFFF # wyzerowanie bitu znaku
	#andi t5, t4, 0x00000000 # wyzerowanie bitu znaku


	or t5, t5, t3 # ustawienie bitu znaku
	fld fa1, 0(a0) # wczytanie wartoœci double do rejestru fa1
	fadd.d fa0, fa0, fa1 # dodanie wartoœci do sumy
	addi t1, t1, -1 # zmniejszenie licznika pêtli
	addi a0, a0, 1 # zwiêkszenie wskaŸnika bufora
	j loop1
endloop1:
	
	# Wyœwietlenie proœby o podanie drugiej liczby
	la a0, prompt2
	li a7, 8
	ecall

	# Wczytanie drugiej liczby
	la a0, buff2
	li a1, 64
	li a7, 8
	ecall
	
	# Skonwertowanie drugiej liczby na int
	addi t0, x0, 0 # wyzerowanie wartoœci wyniku
	addi t1, x0, 31






loop2:
	lbu t2, 0(a0) # pobranie kolejnego znaku
	beqz t2, endloop2 # jeœli koniec ci¹gu, zakoñcz pêtlê
	addi t1, t1, -1 # zmniejszenie licznika pêtli
	andi t3, t2, 1 # pobranie wartoœci bitu
	sll t4, t3, t1 # przesuniêcie bitu na odpowiednie miejsce
	or t0, t0, t4 # dodanie bitu do wyniku
	addi a0, a0, 1 # zwiêkszenie wskaŸnika bufora
	j loop2
endloop2:
	sub t1, x0, t1 # odwrócenie wartoœci licznika pêtli
	addi t1, t1, 31 # dodanie wartoœci przesuniêcia (31)
	sll t0, t0, t1 # przesuniêcie wyniku na odpowiednie miejsce
	lw a0, buff2 # wczytanie drugiej liczby do rejestru a0
	beqz a0, add1 # jeœli druga liczba jest nieujemna, przejdŸ do dodawania
	not a0, a0 # zanegowanie drugiej liczby
	addi a0, a0, 1 # dodanie 1 do zanegowanej liczby (uzyskanie U2)
	li t1, 0x80000000 # inicjalizacja wartoœci maski bitowej
	and t2, a0, t1 # pobranie wartoœci bitu znaku
	beqz t2, add1 # jeœli druga liczba jest nieujemna, przejdŸ do dodawania
	li t1, 0xFFF00000 # inicjalizacja wartoœci dla liczby -infinity
	
	slli t1, t1, 16   # przesuniêcie wartoœci o 32 bity w lewo, aby znalaz³a siê w polu eksponenty
	slli t1, t1, 16   # przesuniêcie wartoœci o 32 bity w lewo, aby znalaz³a siê w polu eksponenty
	fcvt.s.w fa1, t1  # skonwertowanie wartoœci ca³kowitoliczbowej na zmiennoprzecinkow¹ i zapisanie jej w rejestrze fa1
	
	#or fa1, fa1, t1 # ustawienie wartoœci -infinity w rejestrze fa1
	j exit # zakoñczenie programu
add1:
	fadd.d fa0, fa0, fa1 # dodanie drugiej liczby do sumy
exit:
	# Zakoñczenie programu
	li a7, 10
	ret
