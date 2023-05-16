	.globl main
	
	.data
prompt1: .asciz "Enter first number: "
prompt2: .asciz "Enter second number: "

	.text
main:
    	#wyświetlenie prosby o podanie pierwszej liczby
    	la a0, prompt1
  	li a7, 4
    	ecall

    	#wczytanie pierwszej liczby (double)
    	li a7, 7
	ecall

	#wyświetlenie prosby o podanie drugiej liczby
    	la a0, prompt2
  	li a7, 4
    	ecall

    	#wczytanie drugiej liczby (int)
    	li a7, 5
	ecall

	fcvt.d.w fa1, a0
	fmul.d fa0, fa0, fa1

end:
	li a7, 3
	ecall

    	li a7, 10
    	ecall
