/*
 * uth_a23_thread_primitives.S
 *
 *  Created on: May 8, 2014
 *      Author: ballance
 */

/**
 * uth_swap_threads
 *
 * - src				r0
 * - dst				r1
 *
 * - Source stack holds:
 *   - Return address
 */
.globl uth_thread_swap
uth_thread_swap:
	// 0, 1 used

	// Store context for src thread
	str			r2, [r0, #8]
	str			r3, [r0, #12]
	str			r4, [r0, #16]
	str			r5, [r0, #20]
	str			r6, [r0, #24]
	str			r7, [r0, #28]
	str			r8, [r0, #32]
	str			r9, [r0, #36]
	str			r10, [r0, #40]
	str			r11, [r0, #44]
	str			sp, [r0, #52]
	str			lr, [r0, #56]

	// Load context for dst thread
	mov			r0, r1					// Address of dst 'regs' block
	ldr			sp, [r0, #52]
	ldr			r1, [r0, #0]
	push		{r1}					// r0 value
	ldr			r1, [r0, #4]
	ldr			r2, [r0, #8]
	ldr			r3, [r0, #12]			// r3
	ldr			r4, [r0, #16]
	ldr			r5, [r0, #20]
	ldr			r6, [r0, #24]
	ldr			r7, [r0, #28]
	ldr			r8, [r0, #32]
	ldr			r9, [r0, #36]
	ldr			r10, [r0, #40]
	ldr			r11, [r0, #44]
	ldr			lr, [r0, #56]

	pop			{r0}					// restore r0 value
	mov			pc, lr

/**
 * uth_init_thread
 *
 * Initializes a thread handle
 *
 * - thread_h			r0
 * - stack_top			r1
 * - thread_main_p		r2
 * - thread_main_arg	r3
 */
.globl uth_thread_init
uth_thread_init:
	push		{fp, lr}

	str			r3, [r0, #0]			// Store thread_main_arg as first parameter
	str			r0, [r0, #4]			// r1
	str			r0, [r0, #8]			// r2
	str			r0, [r0, #12]			// r3
	str			r0, [r0, #16]			// r4
	str			r5, [r0, #20]
	str			r6, [r0, #24]
	str			r7, [r0, #28]
	str			r8, [r0, #32]
	str			r9, [r0, #36]
	str			r10, [r0, #40]
	str			r11, [r0, #44]
	str			r12, [r0, #48]
	str			r1, [r0, #52]			// Store the stack pointer
	str			r2, [r0, #56]			// Store the start argument as the LR

	pop			{fp, pc}

/**
 * uth_thread_int_mutex_init
 *
 *
 */
.globl uth_thread_int_mutex_init
uth_thread_int_mutex_init:
	mov			r1, #0
	str			r1, [r0]

.globl uth_thread_int_mutex_trylock
uth_thread_int_mutex_trylock:
	mov			r1, #0
	mov			r2, #1
	swp			r1, r2, [r0] // [r0] => r1 ; r2 => [r0]

//	ldr			r1, [r0]
//	str			r2, [r0]
	// locked if r1==0
	cmp			r1, #0
	beq			_trylock_locked
	mov			r0, #1
	mov			pc, lr
_trylock_locked:
	mov			r0, #0
	mov			pc, lr

.globl uth_thread_int_mutex_unlock
uth_thread_int_mutex_unlock:
	mov			r1, #0
	str			r1, [r0]

.globl uth_main_thread_init
uth_main_thread_init:
	mov			pc, lr

/**
 * uth_init_main_thread
 *
 * Initializes the main thread handle
 *
 */
.globl uth_init_main_thread
uth_init_main_thread:
	mov			r0, sp
	push		{fp, lr}
	add			fp, sp, #4

	add			r3, r0, #8				// Compute address of 'regs'
//	ldr			r4, [r0, #4]			// Load sp value

	str			r2, [r3, #0]			// Store thread_main_arg as first parameter
	str			r0, [r3, #4]			// r1
	str			r0, [r3, #8]			// r2
	str			r0, [r3, #12]			// r3
	str			r0, [r3, #16]			// r4
	str			r5, [r3, #20]
	str			r6, [r3, #24]
	str			r7, [r3, #28]
	str			r8, [r3, #32]
	str			r9, [r3, #36]
	str			r10, [r3, #40]
	str			r11, [r3, #44]
	str			r12, [r3, #48]
	str			r0, [r3, #52]			// Store the stack pointer
	str			lr, [r3, #56]			// Store the link register

	pop			{fp, pc}
