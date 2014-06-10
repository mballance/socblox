/*
 * uth_ucontext_thread_primitives.c
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */
#include "uth.h"
#include <ucontext.h>
#include <stdio.h>

static ucontext_t			*main_c;

void uth_thread_swap(uth_thread_t *src, uth_thread_t *dst)
{
	fprintf(stdout, "thread_swap: %p %0\n", &src->ctxt, &dst->ctxt);
	fflush(stdout);
	swapcontext(&src->ctxt, &dst->ctxt);
}

void uth_main_thread_init(
		uth_thread_t			*main_f)
{
	getcontext(&main_f->ctxt);
	main_c = &main_f->ctxt;
	fprintf(stdout, "main_init: %p\n", &main_f->ctxt);
	fflush(stdout);
}

int uth_thread_init(
		uth_thread_t 			*src,
		uint8_t 				*stack_top,
		uth_thread_main_f		main_f,
		void					*ud)
{
	getcontext(&src->ctxt);
	src->ctxt.uc_stack.ss_sp = stack_top;
	src->ctxt.uc_stack.ss_size = 4096;
	src->ctxt.uc_link = main_c;
	makecontext(&src->ctxt, (void (*)(void))main_f, 1, ud);

	fprintf(stdout, "uth_thread_init: ctxt=%p\n", &src->ctxt);
	fflush(stdout);

	return 0;
}

void uth_thread_int_mutex_init(uth_mutex_t *mutex)
{
	mutex->mutex_md.locked = 0;
}

int uth_thread_int_mutex_trylock(uth_mutex_t *mutex)
{
	if (mutex->mutex_md.locked == 0) {
		mutex->mutex_md.locked = 1;
		return 1;
	} else {
		return 0;
	}
}

void uth_thread_int_mutex_unlock(uth_mutex_t *mutex)
{
	mutex->mutex_md.locked = 0;
}

