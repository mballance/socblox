/*
 * uth.h
 *
 *  Created on: May 31, 2014
 *      Author: ballance
 */

#ifndef UTH_H_
#define UTH_H_
#include "uth_md.h"
#include <stdint.h>

#ifdef __cplusplus
class uth_thread_mgr;
extern "C" {
#else
typedef struct uth_thread_mgr;
#endif

typedef void (*uth_thread_main_f)(void *);

typedef struct uth_thread_s {
	uth_thread_ctxt_md_t		ctxt;

	uint8_t						*stack;

	uth_thread_main_f			main_f;
	void						*main_ud;

	// Next thread pointer for condition wait
	// Thread can only wait on a single condition at a time
	struct uth_thread_s			*cond_wait_next;

	struct uth_thread_s			*prev_thread;
	struct uth_thread_s			*next_thread;

	uth_thread_mgr				*thread_mgr;
} uth_thread_t;

typedef struct uth_mutex_s {
	uth_thread_t		*owner;
	uth_mutex_md_t		mutex_md;
} uth_mutex_t;

typedef struct uth_cond_s {
	uint32_t					cond;
	uth_thread_t				*cond_wait_list;
} uth_cond_t;

#define UTH_MUTEX_STATIC_INIT \
{ \
	0, \
	UTH_MUTEX_STATIC_INIT_MD \
}

int uth_thread_create(uth_thread_t *thread, uth_thread_main_f main, void *ud);

int uth_thread_join(uth_thread_t *thread);

int uth_thread_yield();

int uth_mutex_init(
		uth_mutex_t		*mutex);

int uth_mutex_lock(uth_mutex_t *mutex);

int uth_mutex_unlock(uth_mutex_t *mutex);

int uth_cond_init(uth_cond_t *cond);

int uth_cond_wait(uth_cond_t *cond, uth_mutex_t *mutex);

int uth_cond_signal(uth_cond_t *cond);

int uth_cond_broadcast(uth_cond_t *cond);


// Internal implementation-specific methods
uth_thread_mgr *uth_get_thread_mgr();

void uth_thread_swap(uth_thread_t *src, uth_thread_t *dst);

void uth_main_thread_init(
		uth_thread_t			*main_t);

int uth_thread_init(
		uth_thread_t 			*src,
		uint8_t 				*stack_top,
		uth_thread_main_f		main_f,
		void					*ud);

void uth_thread_int_mutex_init(uth_mutex_t *mutex);

int uth_thread_int_mutex_trylock(uth_mutex_t *mutex);

void uth_thread_int_mutex_unlock(uth_mutex_t *mutex);

#ifdef __cplusplus
}
#endif

#endif /* UTH_H_ */
