/*
 * uex.h
 *
 *  Created on: May 5, 2014
 *      Author: ballance
 */

#ifndef UEX_H_
#define UEX_H_
#include "uex_types.h"
#ifdef __cplusplus
extern "C" {
#endif

void uex_main(void);

void uex_timer_tick(void);

int uex_thread_create(uex_thread_t *t, void (*f)(void *), void *);

#ifdef __cplusplus
}
#endif

#endif /* UEX_H_ */
