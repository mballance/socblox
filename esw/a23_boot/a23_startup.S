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

 	B			_reset			// 0x00000000: Reset
 	B			.				// 0x00000004: Undefined instruction
 	B			.				// 0x00000008: SWI
 	B			.				// 0x0000000C: PREF
 	B			_service_dabt	// 0x00000010: DABT
 	B			.				// 0x00000014: Reserved
 	B			_service_irq	// 0x00000018: IRQ
 	B			.				// 0x0000001c: FIQ


 	.string "Copyright (c) Matthew Ballance. All Rights Reserved."
 	.align 4

_reset:
	// First, setup the SVC stack for this core
	ldr			r0, =__svc_stack0_top__
	sub			r0, r0, #4
	mov			sp, r0


	// Next, setup the IRQ stack for this core
	ldr			r3, =__irq_stack_top__
	// r3 holds irq stack address
	// r0 holds the core id
	mov			r1, #00000002
	teqp		pc, r1
	mov			sp, r3

// Change mode to SVC
	mov			r1, #00000003
	teqp		pc, r1

#ifdef HAVE_COREID
// Spin for non-0 core
//	mov			r1, #0
//	cmp			r1, r0
//not_core0:
//	BNE			not_core0
#endif

/*
	LDR			r0, =_reset
	LDR			r1, =_cstartup
	MOV			lr, r1
	B			low_level_init
 */


_cstartup:

	// Switch to IRQ mode
	mov			r0, #00000002
	teqp		pc, r0
	LDR			sp, =__irq_stack_top__

	// Switch to user mode
	mov			r0, #00000000
	teqp		pc, r0
	ldr			r0, =__c_stack_top__
	sub			r0, r0, #4
	mov			sp, r0

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
	LDR			r0, =__data_load
	LDR			r1, =__data_start
	LDR			r2, =_edata

1:
	CMP			r1, r2
	LDMLTIA		r0!, {r3}
	STMLTIA		r1!, {r3}
	BLT			1b


	/* Clear .bss */
	LDR			r1, =__bss_start__
	LDR			r2, =__bss_end__
	MOV			r3, #0

1:
	CMP			r1, r2
	STMLTIA		r1!, {r3}
	BLT			1b


	/* Fill stack section */
	LDR			r1, =__stack_start__
	LDR			r2, =__stack_end__
	MOV			r3, #0

1:
	CMP			r1, r2
	STMLTIA		r1!, {r3}
	BLT			1b

	// Call init methods
	LDR			r1, =__init_array_start
	LDR			r2, =__init_array_end
	CMP			r1, r2
	BEQ			ia_done
ia_1:
	push		{r1, r2}
	MOV			lr, pc
	LDR			pc, [r1]
	pop			{r1, r2}
	ADD			r1, #4
	CMP			r1, r2
	BLT			ia_1
ia_done:

	/* Finally, call C/C++ code */
	LDR			r12, =main
	MOV			lr, pc
	MOV			pc, r12
//	BL			r12

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

_service_dabt:
	// Jump back
	mov			pc, lr

	.size		_start, . - _start

.endfunc
.end
