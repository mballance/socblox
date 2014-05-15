/*
 * uex_thread.h
 *
 *  Created on: May 11, 2014
 *      Author: ballance
 */

#ifndef UEX_THREAD_H_
#define UEX_THREAD_H_
#include "uex_target_types.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*uex_thread_main_f)(void *);

typedef struct uex_thread_s {
	uex_thread_context_t		ctxt;

	uint8_t						*stack;

	uex_thread_main_f			thread_main;
	void						*main_data;

	uint32_t					core_id;

	struct uex_thread_s			*next;
} uex_thread_t;

typedef struct uex_thread_mutex_s {
	uex_thread_mutex_impl_t		mutex;
} uex_thread_mutex_t;

typedef struct uex_thread_cond_s {


} uex_thread_cond_t;

void uex_thread_create(
		uex_thread_t 			*thread,
		uex_thread_main_f		main_f,
		void					*main_data);

void uex_thread_mutex_init(uex_thread_mutex_t *mutex);

void uex_thread_mutex_lock(uex_thread_mutex_t *mutex);

void uex_thread_mutex_unlock(uex_thread_mutex_t *mutex);

void uex_thread_cond_init(uex_thread_mutex_t *mutex);


#ifdef __cplusplus
}
#endif

#endif /* UEX_THREAD_H_ */
