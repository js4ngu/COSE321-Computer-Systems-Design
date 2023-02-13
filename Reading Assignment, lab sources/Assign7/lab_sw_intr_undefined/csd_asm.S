// ------------------------------------------
//  Author: Prof. Taeweon Suh
//          Computer Science & Engineering
//          College of Informatics, Korea Univ.
//  Date:   May 06, 2020
// ------------------------------------------

#include "csd_zynq_peripherals.h"

#define Undefined_Mode	0x1B
#define SVC_Mode	    0x13

.align 5

// My Interrupt/Exception Vector Table
csd_vector_table:
	b .
	b csd_undefined
	b csd_software_interrupt
	b .
	b .
	b .
	b .
	b .

.global main
main:

	// Set VBAR (Vector Base Address Register) to my vector table
	ldr	r0, =csd_vector_table
	mcr	p15, 0, r0, c12, c0, 0
	dsb
	isb

	cps  #0x13   // Change to Supervisor (SVC) Mode
	ldr	r13,=svc_stack_top	/* SVC mode stack pointer */

	cps  #0x1b   // Change to Undefined Mode
	ldr	r13,=und_stack_top	/* SVC mode stack pointer */

	cps  #0x10   // Change to User Mode

forever:

    nop
	.word 0xffffffff  // Exception: Undefined instruction
    nop

    b forever


// --------------------------------------------
// Exception Handler for Undefined Instruction
// --------------------------------------------

csd_undefined:
	srsfd sp!, #Undefined_Mode  // SRS(Save Return State): save LR and SPSR to stack
	stmfd sp!, {r0-r12}

	svc #20   // Software Interrupt

   // ISR body: do something

	ldmfd sp!, {r0-r12}
	rfefd sp!   // RFE(Return from Exception): restore PC and CPSR from stack


// --------------------------------------------
// Interrupt Handler for Software Interrupt 
// --------------------------------------------

csd_software_interrupt:

	srsfd sp!, #SVC_Mode  // SRS(Save Return State): save LR and SPSR to stack
	stmfd sp!, {r0-r12}

 	// Toggle LEDs
	ldr  r0, =csd_LED_ADDR
	ldr  r1, =led_value
	ldr  r2, [r1]
	eor  r2, r2, #0xFF  // toggle the data
	strb r2, [r0]       // turn on LEDs
	str  r2, [r1]       // store a new value to led_value

	ldmfd sp!, {r0-r12}
	rfefd sp!   // RFE(Return from Exception): restore PC and CPSR from stack
 //   movs  pc, lr


.data
.align 4

svc_stack:     .space 1024
svc_stack_top:
und_stack:     .space 1024
und_stack_top:

led_value: .word 0xC3
