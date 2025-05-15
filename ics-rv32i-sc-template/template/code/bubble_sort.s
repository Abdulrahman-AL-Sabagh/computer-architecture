.globl main

.data
	array: .word 34, 561, 7, 1, 124
    
.text
main:
	la a0, array		# a0 = array address
    addi a1, zero, 20	# a1 = n
    
    jal ra, bubble_sort
    
    addi s0, a0, 0
    addi s1, a1, 0
   	addi t0, zero, 0

print_loop:
    bge t0, s1, end
	addi a0, zero, 1
    add t1, s0, t0
    lw a1, 0(t1)
    ecall
    addi t0, t0, 4
    jal zero, print_loop

end:
	addi a0, zero, 10
	ecall
    
bubble_sort:
	addi s0, zero, 0	# s0 = i

outer_for:
	addi t0, a1, -4
    bge s0, t0, end_outer_for
    addi s1, zero, 0	# s1 = j

inner_for:    
    sub t1, a1, s0
    addi t1, t1, -4
    bge s1, t1, end_inner_for
    add t4, a0, s1  
    lw t2, 0(t4)
    lw t3, 4(t4)
    bge t3,t2 else
    sw t2, 4(t4)
    sw t3, 0(t4)

else:
    addi s1, s1, 4
    jal zero, inner_for

end_inner_for:
	addi s0, s0, 4
    jal zero, outer_for

end_outer_for:
	jalr zero, ra, 0