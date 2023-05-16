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

  # Ustalenie d�ugo�ci liczb
  la a0, num1
  li t1, 0  # Licznik bit�w num1
count_bits1:
  lbu t2, 0(a0)  # Pobranie bitu
  beqz t2, done_count1  # Koniec, je�li napotkano zero
  addi a0, a0, 1  # Przesuni�cie wska�nika do nast�pnego bitu
  addi t1, t1, 1  # Inkrementacja licznika bit�w
  j count_bits1
done_count1:
  la a0, num2
  li t2, 0  # Licznik bit�w num2
count_bits2:
  lbu t3, 0(a0)  # Pobranie bitu
  beqz t3, done_count2  # Koniec, je�li napotkano zero
  addi a0, a0, 1  # Przesuni�cie wska�nika do nast�pnego bitu
  addi t2, t2, 1  # Inkrementacja licznika bit�w
  j count_bits2
done_count2:

  # Inicjalizacja wyniku zerami
  la a2, result
  li t4, 0
  add t5, t1, t2  # D�ugo�� wyniku (licznik bit�w num1 + licznik bit�w num2)
loop_init_result:
  sb t4, 0(a2)
  addi a2, a2, 1
  addi t5, t5, -1
  bnez t5, loop_init_result

  # Inicjalizacja wska�nik�w
  la a0, num1
  la a1, num2
  la a2, result

  # Mno�enie bit�w po kolei
multiply_bits:
  lbu t6, 0(a0)  # Pobranie bitu z pierwszej liczby

multiply_bits_loop:
  # Przesuni�cie drugiej liczby w lewo o 1 bit
  slli s7, t2, 1
  addi t2, t2, 1

  # Dodawanie przesuni�tej liczby do wyniku
  la a1, num2
  la a2, result
  li t1, 0
  blt t6, s6, skip_addition

addition_loop:
  lbu s8, 0(a1)  # Pobranie bitu z przesuni�tej liczby
  lbu s9, 0(a2)  # Pobranie bitu wyniku

  add s10, s8, s9  # Dodanie bit�w
  add s10, s10, t1  # Dodanie przeniesienia z poprzedniego bitu

  rem s11, s10, s5  # Reszta z dzielenia przez 2 (bit wyniku)
  srli t1, s10, 1  # Przeniesienie do nast�pnego bitu

  sb s11, 0(a2)  # Zapisanie bitu wyniku do pami�ci

  addi a1, a1, 1  # Przesuni�cie wska�nika do nast�pnego bitu w przesuni�tej liczbie
  addi a2, a2, 1  # Przesuni�cie wska�nika do nast�pnego bitu w wyniku

  addi t4, t4, -1  # Dekrementacja licznika bit�w wyniku
  bnez t4, addition_loop  # Powr�t do dodawania, je�li nie wszystkie bity zosta�y przetworzone

  j multiply_bits_end

skip_addition:
  addi a0, a0, 1  # Przesuni�cie wska�nika do nast�pnego bitu w pierwszej liczbie
  j multiply_bits_loop

multiply_bits_end:

  # Zako�czenie programu
  li a7, 10
  ecall
