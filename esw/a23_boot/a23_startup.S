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
 	B			.		// IRQ
 	B			.		// FIQ


 	.string "Copyright (c) Matthew Ballance. All Rights Reserved."
 	.align 4

_reset:
	LDR			r0, =_reset
	LDR			r1, =_cstartup
	MOV			lr, r1
	LDR			sp, =__stack_end__
	B			low_level_init


_cstartup:

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

	.size		_start, . - _start

.endfunc
.end
