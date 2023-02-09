// ------------------------------------------
//  Author: Prof. Taeweon Suh
//          Computer Science & Engineering
//          College of Informatics, Korea Univ.
//  Date:   March 29, 2020
// ------------------------------------------

#define csd_LED_ADDR 0x41200000

.extern csd_main

.global main
main:

 	mov r0, #10
 	mov r1, #3
 	add r0, r0, r1

 	ldr r0, =src
 	ldr r1, =dst
 	mov r2, #16

loop:
 	bl csd_main

forever:
	nop
 	b forever

.data
.align 4

src:
 	.word 1, 2, 3, 4, 5, 6, 7, 8
 	.word 11, 12, 13, 14, 15, 16, 17, 18

dst:
 	.space 16	//allocate memory for 16 words
