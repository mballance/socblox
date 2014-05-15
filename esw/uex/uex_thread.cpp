/*
 * uex_thread.c
 *
 *  Created on: May 11, 2014
 *      Author: ballance
 */
#include "uex_thread.h"
#include "uex_thread_primitives.h"

static void uex_thread_trampoline(void *ud)
{

}


void uex_thread_create(uex_thread_t *thread, uex_thread_main_f main_f, void *main_data)
{
//	uex_thread_init(thread, main);

}

void uex_thread_mutex_init(uex_thread_mutex_t *mutex)
{
	uex_thread_int_mutex_init(mutex);
}

void uex_thread_mutex_lock(uex_thread_mutex_t *mutex)
{
	while (!uex_thread_int_mutex_trylock(mutex)) {
		;
	}
}

void uex_thread_mutex_unlock(uex_thread_mutex_t *mutex)
{
	uex_thread_int_mutex_unlock(mutex);
}



