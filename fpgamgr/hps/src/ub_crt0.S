
.text
.code 32

// Entry point
.global _start
.func _start
_start:
	push	{r0,r1,r2}
	ldr	r0, =__bss_start
	ldr	r1, =__bss_end
	mov	r2, #0
1:
	cmp	r0, r1
	stmltia	r0!, {r2}
	blt	1b

	// Call init() methods
	ldr	r1, =__init_array_start
	ldr	r2, =__init_array_end
	cmp	r1, r2
	beq	ia_done
ia_1:
	push	{r1, r2}
	mov	lr, pc
	ldr	pc, [r1]
	pop	{r1, r2}
	add	r1, #4
	cmp	r1, r2
	blt	ia_1
/**
  **/

ia_done:

	pop	{r0,r1,r2}
	blx	_thumb_tramp
//	b	_thumb_tramp

//	ldr	r12, =_thumb_tramp
//	orr	r12, r12, #1
//	bx	r0
.endfunc

.code 16
_thumb_tramp:
	push	{r4}
	ldr r4, =main
	mov	lr, pc
	mov	pc, r4
	pop		{r4}

done:
	b		done

//	b	main
//	ldr	r0, =main
//	mov	lr, pc
//	mov	pc, r0

