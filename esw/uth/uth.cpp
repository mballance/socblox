/*
 * uth.cpp
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */

#include "uth.h"
#include "uth_thread_mgr.h"
#include <stdlib.h>
#include <stdio.h>

static void uth_thread_main_trampoline(void *ud)
{
	uth_thread_t *thread = (uth_thread_t *)ud;

	/*
	fprintf(stdout, "thread=%p\n", ud);
	fflush(stdout);
	fprintf(stdout, "thread->main_f=%p\n", thread->main_f);
	 */

	// Call the real main
	thread->main_f(thread->main_ud);

	// Free the stack
//	free(thread->stack);

	// Post-thread cleanup. Never returns
	thread->thread_mgr->thread_end(thread);
}

int uth_thread_create(
		uth_thread_t		*thread,
		uth_thread_main_f	main_f,
		void				*ud
		)
{
	uint32_t stk_sz = 16*1024;
	uint8_t *stack_top;
	uth_thread_mgr *mgr = uth_get_thread_mgr();

	thread->thread_mgr = mgr;
	thread->stack = (uint8_t *)malloc(stk_sz);
	thread->main_f = main_f;
	thread->main_ud = ud;
	stack_top = thread->stack + stk_sz - 4;

	uth_thread_init(thread, stack_top, uth_thread_main_trampoline, thread);

	mgr->thread_create(thread);

	return 0;
}

int uth_thread_yield()
{
	uth_thread_mgr *mgr = uth_get_thread_mgr();

	mgr->yield();

	return 0;
}

int uth_mutex_init(
		uth_mutex_t		*mutex)
{
	uth_thread_int_mutex_init(mutex);

	return 0;
}

int uth_mutex_lock(
		uth_mutex_t		*mutex)
{
	/*
	 */
	uth_thread_mgr *mgr = uth_get_thread_mgr();

	while (!uth_thread_int_mutex_trylock(mutex)) {
		mgr->yield();
	}

	return 0;
}

int uth_mutex_unlock(
		uth_mutex_t		*mutex)
{
	/*
	 */
	uth_thread_int_mutex_unlock(mutex);

	return 0;
}

int uth_cond_init(uth_cond_t *cond)
{
	return 0;
}

int uth_cond_wait(uth_cond_t *cond, uth_mutex_t *mutex)
{
	uth_thread_mgr *mgr = uth_get_thread_mgr();
	uth_thread_t *self = mgr->current_thread();

	// Entry: mutex locked
	self->cond_wait_next = cond->cond_wait_list;
	cond->cond_wait_list = self;

	// Wait for someone to signal the mutex
	uth_mutex_unlock(mutex);
	mgr->block_thread(self);

	uth_mutex_unlock(mutex);

	// Exit: mutex unlocked

	return 0;
}

int uth_cond_signal(uth_cond_t *cond)
{
	// Entry: mutex locked

	uth_thread_t *unblock = cond->cond_wait_list;

	if (unblock) {
		cond->cond_wait_list = cond->cond_wait_list->cond_wait_next;
	} else {
		// Error:
	}

	unblock->thread_mgr->unblock_thread(unblock);

	return 0;
}

int uth_cond_broadcast(uth_cond_t *cond)
{
	// Entry: mutex locked

	uth_thread_t *unblock;

	while ((unblock = cond->cond_wait_list)) {
		cond->cond_wait_list = cond->cond_wait_list->cond_wait_next;
		unblock->thread_mgr->unblock_thread(unblock);
	}

	return 0;
}

