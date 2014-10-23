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
	// Call low-level hardware initialization code
	LDR			r0, =_reset
	LDR			r1, =_post_hw_init
	MOV			lr, r1
	B			low_level_init

_post_hw_init:
	// First, setup a default stack
	ldr			r0, =__stack_end__
	sub			sp, r0, #4

	// Determine which core this is
	ldr			r0, =0xF1000004
	ldr			r1, [r0]
	cmp			r1, #0
	beq			is_core0
	b			not_core0

is_core0:

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

	// Setup the stacks
	bl			setup_stacks

	/* Finally, call C/C++ code */
	LDR			r12, =main
	MOV			lr, pc
	MOV			pc, r12

	/* Cause an exception if main() returns */
	SWI			0xFFFFFF

	/****************************************************************
	 * Non-primary core startup
	 ****************************************************************/
not_core0:
	// TODO:
	bl			setup_stacks

	ldr			r12, =main
	mov			lr, pc
	mov			pc, r12

	// case an exception if main returns
	swi			0xFFFFFF

	b			not_core0

setup_stacks:
	mov			r4, lr

	// Setup the IRQ stack for this core
	mov			r0, #128
	bl			malloc
	mov			r1, #00000002 // IRQ mode
	teqp		pc, r1
	add			sp, r0, #124

	// Next, setup the SVC stack for this core
	mov			r1, #00000002 // SVC mode
	teqp		pc, r1
	mov			r0, #128
	bl			malloc
	add			sp, r0, #124

	// Finally, setup the USR stack
	mov			r0, #4096
	bl			malloc
	mov			r1, #0
	teqp		pc, r1
	add			r0, r0, #4096
	sub			sp, r0, #4

	// Return
	mov			pc, r4

	// Service Routines
_service_irq:
	push {r0-r4, r12, lr}

	// TODO: call C handler
	ldr			r12, =irq_handler
	mov			lr, pc
	mov			pc, r12

	pop {r0-r4, r12, lr}
	subs		pc, lr, #4

_service_dabt:
	// Jump back
	subs		pc, lr, #8

	.size		_start, . - _start

.endfunc

ServiceStackSize:	.word 128
MainStackSize: 		.word 4096
CoreIdAddr:			.word 0xF1000004

.end
