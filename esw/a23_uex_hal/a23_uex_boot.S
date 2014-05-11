/****************************************************************************
 * a23_startup.S
 *
 * Core startup routines
 ****************************************************************************/

 .text
 .code 32

 .global _start
 .func _start

 _start:

 	B			_reset
 	B			.		// Undefined instruction
 	B			.		// SWI
 	B			.		// PREF
 	B			.		// DABT
 	B			.		// Reserved
 	B			_service_irq	// IRQ
 	B			.		// FIQ


 	.string "Copyright (c) Matthew Ballance. All Rights Reserved."
 	.align 4

_reset:
	// First, see which core we are
	LDR			r0, =0xF1000004
	LDR			r0, [r0]

	mov			r1, #0
	cmp			r1, r0
	BNE			not_core0
	B			_core0_init
not_core0:
	B			_coreN_init

	// End

//	BNE			not_core0
	// First, setup the SVC stack for this core
	/*
	ldr			r1, =__svc_stack0_top__
	ldr			r2, =__svc_stack0_start__
	sub			r3, r1, r2
	add			r2, r0, #1
	mul			r3, r3, r2
	sub			r3, r3, #4
	add			r3, r3, r2
	// r3 holds svc stack address
	// r0 holds the core id
	mov			sp, r3

	// Next, setup the IRQ stack for this core
	ldr			r1, =__irq_stack0_top__
	ldr			r2, =__irq_stack0_start__
	sub			r3, r1, r2
	add			r2, r0, #1
	mul			r3, r3, r2
	sub			r3, r3, #4
	add			r3, r3, r2
	// r3 holds irq stack address
	// r0 holds the core id
	mov			r1, #00000002
	teqp		pc, r1
	mov			sp, r3
	 */

// Change mode to SVC
	mov			r1, #00000003
	teqp		pc, r1

// Spin for non-0 core
	mov			r1, #0
	cmp			r1, r0
//not_core0:
	BNE			not_core0


	LDR			r0, =_reset
	LDR			r1, =_cstartup
	MOV			lr, r1
	B			low_level_init


_cstartup:

	// Switch to IRQ mode
	mov			r0, #00000002
	teqp		pc, r0
	LDR			sp, =__irq_stack_top__

	// Switch to user mode
	mov			r0, #00000000
	teqp		pc, r0
	LDR			sp, =__c_stack_top__

	/* Relocate the .fastcode section from ROM to RAM */
/*
	LDR			r0, =__fastcode_load
	LDR			r1, =__fastcode_start
	LDR			r2, =__fastcode_end

1:
	CMP			r1, r2
	LDMLTIA		r0!, {r3}
	STMLTIA		r1!, {r3}
	BLT			1b
 */

	/* Relocate the .data section from ROM to RAM */
/** TODO:
	LDR			r0, =__data_load
	LDR			r1, =__data_start
	LDR			r2, =_edata

1:
	CMP			r1, r2
	LDMLTIA		r0!, {r3}
	STMLTIA		r1!, {r3}
	BLT			1b
 */



	/* Fill stack section */
	LDR			r1, =__stack_start__
	LDR			r2, =__stack_end__
	MOV			r3, #0

1:
	CMP			r1, r2
	STMLTIA		r1!, {r3}
	BLT			1b

	/* TODO: Initialize stack pointers */

//	B			r12


_core0_init:
	/* Clear .bss */
	LDR			r1, =__bss_start__
	LDR			r2, =__bss_end__
	MOV			r3, #0

1:
	CMP			r1, r2
	STMLTIA		r1!, {r3}
	BLT			1b

	/* Invoke static constructors */
	/*
	LDR			r12, =__libc_init_array
	MOV			lr, pc
	MOV			pc, r12
	 */

	/* Finally, call C/C++ code */
	LDR			r12, =main
	MOV			lr, pc
	MOV			pc, r12

	/* Cause an exception if main() returns */
	SWI			0xFFFFFF

_coreN_init:
	ldr			r0, =__non_primary_core_release
	ldr			r1, [r0]
	ldr			r2, =0xFFFFFFFF
	eor			r1, r1, r2 // Compute release value

_coreN_wait_release:
	ldr			r2, [r0]
	cmp			r1, r2
	bne			_coreN_wait_release

	// Proceed with coreN initialization
	// - Wait until we can lock the startup mutex
	// - Use the setup stack to perform initialization
	// - Invoke

	/* Cause an exception if main() returns */
	SWI			0xFFFFFF

_service_irq:
	// First, see if we're in 'startup' mode

//	stmfd		sp!, {lr}
	push {r0-r4, r12, lr}

	// TODO: call C handler
	ldr			r12, =irq_handler
	mov			lr, pc
	mov			pc, r12

	pop {r0-r4, r12, lr}
//	ldmfd		sp!, {lr}
	subs		pc, lr, #4

	.size		_start, . - _start

.endfunc
.end
