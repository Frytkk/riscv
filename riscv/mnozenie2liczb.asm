.data
num1: .space 16
num2: .space 16
result: .space 16

.text
.globl main
main:
  # Wczytanie pierwszej liczby (num1)
  la a0, num1
  li a1, 10
  li a7, 8
  ecall
  
  # Wczytanie drugiej liczby (num2)
  la a0, num2
  li a1, 10
  li a7, 8
  ecall
  
  li s4, '1'
  li s6, 1
  li s5, 2

  # Ustalenie d³ugoœci liczb
  la a0, num1
  li t1, 0  # Licznik bitów num1
count_bits1:
  lbu t2, 0(a0)  # Pobranie bitu
  beqz t2, done_count1  # Koniec, jeœli napotkano zero
  addi a0, a0, 1  # Przesuniêcie wskaŸnika do nastêpnego bitu
  addi t1, t1, 1  # Inkrementacja licznika bitów
  j count_bits1
done_count1:
  la a0, num2
  li t2, 0  # Licznik bitów num2
count_bits2:
  lbu t3, 0(a0)  # Pobranie bitu
  beqz t3, done_count2  # Koniec, jeœli napotkano zero
  addi a0, a0, 1  # Przesuniêcie wskaŸnika do nastêpnego bitu
  addi t2, t2, 1  # Inkrementacja licznika bitów
  j count_bits2
done_count2:

  # Inicjalizacja wyniku zerami
  la a2, result
  li t4, 0
  add t5, t1, t2  # D³ugoœæ wyniku (licznik bitów num1 + licznik bitów num2)
loop_init_result:
  sb t4, 0(a2)
  addi a2, a2, 1
  addi t5, t5, -1
  bnez t5, loop_init_result

  # Inicjalizacja wskaŸników
  la a0, num1
  la a1, num2
  la a2, result

  # Mno¿enie bitów po kolei
multiply_bits:
  lbu t6, 0(a0)  # Pobranie bitu z pierwszej liczby

multiply_bits_loop:
  # Przesuniêcie drugiej liczby w lewo o 1 bit
  slli s7, t2, 1
  addi t2, t2, 1

  # Dodawanie przesuniêtej liczby do wyniku
  la a1, num2
  la a2, result
  li t1, 0
  blt t6, s6, skip_addition

addition_loop:
  lbu s8, 0(a1)  # Pobranie bitu z przesuniêtej liczby
  lbu s9, 0(a2)  # Pobranie bitu wyniku

  add s10, s8, s9  # Dodanie bitów
  add s10, s10, t1  # Dodanie przeniesienia z poprzedniego bitu

  rem s11, s10, s5  # Reszta z dzielenia przez 2 (bit wyniku)
  srli t1, s10, 1  # Przeniesienie do nastêpnego bitu

  sb s11, 0(a2)  # Zapisanie bitu wyniku do pamiêci

  addi a1, a1, 1  # Przesuniêcie wskaŸnika do nastêpnego bitu w przesuniêtej liczbie
  addi a2, a2, 1  # Przesuniêcie wskaŸnika do nastêpnego bitu w wyniku

  addi t4, t4, -1  # Dekrementacja licznika bitów wyniku
  bnez t4, addition_loop  # Powrót do dodawania, jeœli nie wszystkie bity zosta³y przetworzone

  j multiply_bits_end

skip_addition:
  addi a0, a0, 1  # Przesuniêcie wskaŸnika do nastêpnego bitu w pierwszej liczbie
  j multiply_bits_loop

multiply_bits_end:

  # Zakoñczenie programu
  li a7, 10
  ecall
