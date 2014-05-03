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
/*
	MOV			r1, #0
	MOV			r3, #0x80000000
sub1:
	ADD			r1, r1, #1
	STR			r1, [r3]
	B			sub1
	 */

	LDR			r0, =0xF1000004
//	ADD			r0, r0, #0x3004
	LDR			r1, [r0]
	MOV			r0, #0
	CMP			r1, r0
not_core0:
	BNE			not_core0


	LDR			r0, =_reset
	LDR			r1, =_cstartup
	MOV			lr, r1
	LDR			sp, =__svc_stack_top__
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

	/* TODO: Initialize stack pointers */

	/* Invoke static constructors */
	/*
	LDR			r12, =__libc_init_array
	MOV			lr, pc
	MOV			pc, r12
	 */
//	B			r12

	/* Finally, call C/C++ code */
	LDR			r12, =main
	MOV			lr, pc
	MOV			pc, r12
//	BL			r12

	/* Cause an exception if main() returns */
	SWI			0xFFFFFF

_service_irq:
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
