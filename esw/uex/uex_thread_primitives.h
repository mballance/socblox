/*
 * uex_thread_primitives.h
 *
 *  Created on: May 8, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_UEX_THREAD_PRIMITIVES_H
#define INCLUDED_UEX_THREAD_PRIMITIVES_H
#include <stdint.h>
#include "uex_thread.h"

#ifdef __cplusplus
extern "C" {
#endif

void uex_thread_swap(uex_thread_t *src, uex_thread_t *dst);

void uex_thread_init(uex_thread_t *src, void *stack_top, void (*f)(void *), void *);

void uex_thread_int_mutex_init(uex_thread_mutex_t *mutex);

int uex_thread_int_mutex_trylock(uex_thread_mutex_t *mutex);

void uex_thread_int_mutex_unlock(uex_thread_mutex_t *mutex);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_UEX_THREAD_PRIMITIVES_H */
