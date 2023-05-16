.data
test_case_01:	.asciz"Eine ][ kleine ][ Nachtmusik"
.text

main:
	li a7, 4
	la a0, test_case_01
	ecall
	
	
	
	jal replace
	
	li a7, 1
	ecall
	
	li a7, 4
	la a0, test_case_01
	ecall
	

exit:
	li a7, 10
	ecall
	
replace:
	mv t0, a0
	li t1, '['
	li t2, ']'
	li t3, '*'
	replace_loop:
		lb t4, (a0)
		beqz t4, end_loop
		addi a0, a0, 1
		bne t4, t1, replace_loop
	start_replace:
		lb t4, (a0)
		beqz t4, end_loop
		beq t4, t2, end_replace
		sb t3, (a0)
		addi a0, a0, 1
		b start_replace
	end_replace:
		lb t4, (a0)
		beqz t4, end_loop
		addi a0, a0, 1
		b end_replace
				
		
	
end_loop:
	sub a0, a0, t0

	
	
	jr ra
	
