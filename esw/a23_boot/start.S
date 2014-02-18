/*----------------------------------------------------------------
//                                                              //
//  start.S                                                     //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Assembly routines for boot-loader.                          //
//  As boot-loader is a stand-alone application, it needs a     //
//  simple start function written in assembly to call the       //
//  C code main() function.                                     //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
----------------------------------------------------------------*/

#include "amber_registers.h"


	.section .text
	.globl	start 
start:               
        /* 0x00 Reset Interrupt vector address */
        b       startup

        /* 0x04 Undefined Instruction Interrupt vector address */
        b       boot_testfail
        
        /* 0x08 SWI Interrupt vector address */
        b       swi_handler
        
        /* 0x0c Prefetch abort Interrupt vector address */
        b       boot_testfail
        
        /* 0x10 Data abort Interrupt vector address */
        b       boot_testfail
        b       boot_testfail
        
        /* 0x18 IRQ vector address */
        b       irq_handler
        
        /* 0x1c FIRQ vector address */
        b       firq_handler
        
startup:
        /* init SP */
        ldr     sp, AdrSvcStack

        @ Enable the cache
/*        mov     r0, #0xffffffff */
		mov     r0, #0xfffffffd		 @ second 2M non-cached
		mcr	15, 0, r0, cr3, cr0, 0   @ cacheable area
		mov     r0, #1
		mcr	15, 0, r0, cr2, cr0, 0   @ cache enable

        @ Set 32MB memory mode
        ldr     r0, AdrMemCtrl
        mov     r1, #1
        str     r1, [r0]

	/** Switch to IRQ mode */
	mov	r0, #0x00000002
	teqp	pc, r0
	ldr	sp, AdrIrqStack

	/** Switch to User mode */
	mov	r0, #0x00000000
	teqp	pc, r0
	ldr	sp, AdrUsrStack

        /* Unset interrupt mask bits, stay in svc mode */
//        mov     r0, #0x00000003
//        teqp    pc, r0 

 

	// Call pre-main before calling main
	.extern __main
	bl	__main
        
        .extern main
        bl      main
                
        @ ----------------------------------------------
        @ jump to start of program in svc mode with interrupts disabled
        @ ----------------------------------------------
//        mov     r4, r0
//        orr     r4, #0x0c000003
//        mov     r0, #0  
//        mov     pc, r4

boot_testfail:
        ldr     r11, AdrTestStatus
        str     r0, [r11]
        b       boot_testfail

/**
 * swi_handler
 */
swi_handler:
	ldr	r11, =swi_handler_f
	ldr	r0, [r11]
	cmp	r0, #0
	beq	no_swi_handler
	mov	pc, r0
no_swi_handler:
	b	boot_testfail

/**
 * irq_handler
 */
irq_handler:
	// Switch to IRQ mode
//	mov	r0, #0x00000002
//	teqp	pc, r0

	sub	lr, lr, #4
	push	{lr}
	push	{r0-r4, r12, lr}
	ldr	r1, =irq_handler_f
	ldr	r0, [r1]
	cmp	r0, #0
	beq	no_irq_handler
	mov	lr, pc
	mov	pc, r0
	pop	{r0-r4, r12, lr}
	// Switch back to USR mode
//	mov	r0, #0x00000000
//	teqp	pc, r0
	ldm	sp!, {pc}^
//	subs	pc, lr, #4
no_irq_handler:
	b	boot_testfail

/**
 * firq_handler
 */
firq_handler:
	sub	lr, lr, #4
	push	{lr}
//	stmfd	sp!, {r0-r12,r14}
	push	{r0-r4, r12, lr}
	ldr	r11, =firq_handler_f
	ldr	r0, [r11]
	cmp	r0, #0
	beq	no_firq_handler
	mov	lr, pc
	mov	pc, r0
	pop	{r0-r4, r12, lr}
//	ldmfd	sp!, {r0-r12,r14}
	ldm	sp!, {pc}^
//	subs	pc, lr, #4
no_firq_handler:
	b	boot_testfail
	

/* stack at top of ddr3 memory space */
AdrSvcStack:                .word 0x02000000
AdrIrqStack:                .word 0x01FF0000
AdrUsrStack:                .word 0x01FE0000

AdrMemCtrl:                 .word ADR_AMBER_TEST_MEM_CTRL

                            .align 2

AdrTestStatus:  			.word  ADR_AMBER_TEST_STATUS
