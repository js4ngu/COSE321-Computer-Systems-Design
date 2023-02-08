#define csd_LED_ADDR 0x41200000
.extern csd_main
.global main

main:
	//	1. Variable Setting
	ldr r1, =Input_data		//	r1 = addr of Input_data
	ldr r2, =Output_data	//	r2 = addr of Output_data
	sub r3, r2, r1
	lsr r3, r3, #2			//	r3 = Number of Input_data

	//	2. copy Input to Output
	mov r4, #0				// r4 = counter of copy loop
	mov r5, r1				// r5 = src_addr
	mov r6, r2				// r6 = dst_addr
copy:
	ldr r7, [r5], #4		// copy data  & src_addr++
	str r7, [r6], #4		// paste data & dst_addr++
	add r4, r4, #1
	cmp r4, r3
	bne copy



	//	3. Order Output_data
	//	0                      r10
	//	[---- Not Sorted(A) ---- ] [-- Sorted(B) --]
	//  Find biggest number in (A) and replace with end number in (A)
	//	Place end number to (B) and keep sorting (A)
	mov r4, #0					// r4 = outer_loop_counter
loop:
	//	loop default setting
	mov 	r5, #0				// r5 = inner_loop_counter
	mov 	r6, r2				// r6 = current_pointer
	ldr 	r7, [r6]			// r7 = current_number
	mov 	r8, r2				// r8 = biggest_number_pointer
	ldr 	r9, [r6]			// r9 = biggest_number (default first number)
	sub 	r10, r3, r4			// r10 = end_of_inner_counter
	sub		r10, r10, #1

	//	3-1. find biggest number
loop2:
	add 	r5, r5, #1			//	inner_couter++
	add 	r6, r2, r5, LSL#2	// 	current_pointer update
	ldr		r7, [r6]			// 	r7 = current_number

	cmp		r7, r9				//	if ( current_number > biggest_number)
	movgt 	r9, r7				//			biggest_number = current_number
	movgt 	r8, r6				// 			biggest_number_pointer = current_number_pointer

	cmp 	r5, r10				//  if ( inner_counter < end_of_inner_counter)
	blt	loop2					//			keep loop2

	//	3-2. swap biggest number & end number
	str 	r7, [r8]			//	*current_number_pointer = biggest_number
	str 	r9, [r6]			//	*biggest_number_pointer = current_number
								//	(current_number_pointer points end_number of unsorted part here)

	add	r4, r4, #1
	cmp	r4, r3
	blt	loop

forever:
nop
	b forever


.data
.align 4
Input_data:
	.word 2, 0, -7, -1, 3, 8, -4, 10
	.word -9, -16, 15, 13, 1, 4, -3, 14
	.word -8, -10, -15, 6, -13, -5, 9, 12
	.word -11, -14, -6, 11, 5, 7, -2, -12

Output_data:
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
