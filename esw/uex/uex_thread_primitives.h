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

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_UEX_THREAD_PRIMITIVES_H */
