.globl main
	.data
prompt: .asciz "Enter your string: \n"
ans:	.asciz "Your string is: \n"
buf:	.space 100
	.text
main:
	li a7, 4
	la a0, prompt
	ecall
	li a7, 8
	la a0, buf
	li a1, 100
	ecall
	la t0, buf
	la t1, buf
first_loop:
	lb t2, (t1)
	beqz t2, end_first
	addi t1, t1, 1
	b first_loop
end_first:
	addi t1, t1, -1
	li t2, '0'
	li t3, '9'
loop:
	beq t0, t1, end
	lb t4, (t0)
	blt t4, t2, increment_first
	bgt t4, t3, increment_first
	lb t4, (t1)
	blt t4, t2, increment_second
	bgt t4, t3, increment_second
	lb t5, (t0)
	lb t6, (t1)
	add t5, t5, t6
	sub t6, t5, t6
	sub t5, t5, t6
	sb t5, (t0)
	sb t6, (t1)
	addi t0, t0, 1
	addi t1, t1, -1
	b loop
increment_first:
	addi t0, t0, 1
	b loop
increment_second:
	addi t1, t1, -1
	b loop
end:
	li a7, 4
	la a0, buf
	ecall