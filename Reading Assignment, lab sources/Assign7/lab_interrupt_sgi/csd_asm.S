// ------------------------------------------
//  Author: Prof. Taeweon Suh
//          Computer Science & Engineering
//          College of Informatics, Korea Univ.
//  Date:   May 06, 2020
// ------------------------------------------

#include "csd_zynq_peripherals.h"

// Vector table base location should be aligned at 2^5
.align 5

csd_vector_table:
	b .
	b .
	b .
	b .
	b .
	b .
	b csd_IRQ_ISR
	b .

.global main
main:

	// Disable interrupt: CPSR'I = 1
	cpsid i

	// Set VBAR (Vector Base Address Register) to my vector table
	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	cps #0x12                // IRQ mode 
	ldr	r13,=irq_stack_top // IRQ stack pointer 

	cps #0x1f                // SYS mode

// ---------------------------
// Generic Interrupt Controller (GIC) setup - Begin
// ---------------------------

	// CPU Interface ID Register
	ldr r0, =GICC_IIDR 
	ldr r3, [r0]

	// CPU Binary Pointer Register
	ldr r0, =GICC_BPR  
	ldr r3, [r0]

	// Distributor Control Register
	ldr r0, =GICD_CTLR  
	ldr r1, [r0]
	mov r2, #1       // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// According to specifications, 
	// Cortex-A9 supports 5-bit version of priority format [7:3] in secure world
	// ( 0 -> 8 -> 16 -> 24...)

	// Interrupt Priority Register #7
	ldr r0, =GICD_PRIOR0  
	ldr r1, [r0]
	mov r2, #0x8 << 24      // Priority 8 for ID# 3
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// CPU Interface Control Register
	ldr r0, =GICC_CTLR
	ldr r1, [r0]
	mov r2, #1        // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// CPU Interface Interrupt Priority Mask Register
	ldr r0, =GICC_PMR
	ldr r1, [r0]
	mov r2, #0xFF     // Lowest
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

// ---------------------------
// Generic Interrupt Controller (GIC) setup - End
// ---------------------------

	// Generate SGI
	// GICD_SGIR is Write-Only (WO)
	ldr r0, =GICD_SGIR 
   mov r1, #0
	mov r2, #1<<16      // CPUTargetList (CPU Interface 0)
	orr r1, r1, r2
	mov r2, #3          // ID = 3
	orr r1, r1, r2
	str r1, [r0]

	//ldr r0, =GICD_SPENDSGIR0
	//ldr r3, [r0]

 	// Enable IRQ and Change to User Mode
	cpsie i, 0x10

forever:
	nop
	b forever


// ----------------------------
// Interrupt Service Routines (ISRs) - Begin
// ----------------------------

csd_IRQ_ISR:

	stmfd sp!, {r0-r12, lr}

 	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

 	// Toggle LEDs
	ldr r0, =csd_LED_ADDR
	ldr r1, =led_value
	ldr r2, [r1]
	eor r2, r2, #0xF
	str r2, [r0]
	str r2, [r1]

 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldmfd sp!, {r0-r12, lr}
	subs pc, lr, #4

// ----------------------------
// Interrupt Service Routines (ISRs) - End
// ----------------------------


.data
.align 4

irq_stack:     .space 1024
irq_stack_top:

led_value: .word 0x5
