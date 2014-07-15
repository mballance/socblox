/*
 * uth_coop_thread_mgr.cpp
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */

#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdio.h>

#ifdef UNDEFINED
#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

#define dump_threadlist(l) { \
	uth_thread_t *__tl = (l); \
	uint32_t __tc = 0; \
	while (__tl) { \
		debug("  thread %p %p\n", __tl, &__tl->next_thread); \
		__tl = __tl->next_thread; \
		__tc++; \
	} \
}
#else
#define debug(...)
#define dump_threadlist(l)
#endif


uth_coop_thread_mgr::uth_coop_thread_mgr() {
	m_active_thread_list = 0;
	m_blocked_thread_list = 0;
	m_terminated_thread_list = 0;
}

uth_coop_thread_mgr::~uth_coop_thread_mgr() {
	// TODO Auto-generated destructor stub
}

void uth_coop_thread_mgr::init()
{
	// Create a thread to represent the main thread
	uth_main_thread_init(&m_main_thread);
	m_main_thread.main_f = (uth_thread_main_f)0xFFEEAA55;

	m_curr_thread = &m_main_thread;
	m_active_thread_list = &m_main_thread;

	uth_mutex_init(&m_mutex);
	uth_thread_create(&m_scheduler_thread, &uth_coop_thread_mgr::scheduler_main, this);
}

uth_thread_t *uth_coop_thread_mgr::current_thread()
{
	return m_curr_thread;
}

void uth_coop_thread_mgr::thread_create(uth_thread_t *thread)
{
	debug("--> thread_create %p\n", thread);
	append_thread(&m_active_thread_list, thread);
	dump_threadlist(m_active_thread_list);
	debug("<-- thread_create %p\n", thread);
}

void uth_coop_thread_mgr::thread_end(uth_thread_t *thread)
{
	debug("--> thread_end %p\n", thread);
	// Remove this thread from
	dump_threadlist(m_active_thread_list);
	unlink_thread(&m_active_thread_list, thread);
	append_thread(&m_terminated_thread_list, thread);
	debug("  post unlink\n");
	dump_threadlist(m_active_thread_list);
	debug("  uth_thread_swap %p %p\n", m_curr_thread, &m_scheduler_thread);
	m_curr_thread = &m_scheduler_thread;
	uth_thread_swap(thread, &m_scheduler_thread);
	debug("<-- thread_end %p\n", thread);
}

void uth_coop_thread_mgr::block_thread(uth_thread_t *thread)
{
	unlink_thread(&m_active_thread_list, thread);
	append_thread(&m_blocked_thread_list, thread);
}

void uth_coop_thread_mgr::unblock_thread(uth_thread_t *thread)
{
	unlink_thread(&m_blocked_thread_list, thread);
	append_thread(&m_active_thread_list, thread);
}

void uth_coop_thread_mgr::yield()
{
//	fprintf(stdout, "yield: m_curr_thread=%p m_scheduler_thread=%p\n", m_curr_thread, &m_scheduler_thread);
//	fflush(stdout);
	debug("--> yield %p %p\n", m_curr_thread, &m_scheduler_thread);
	{
		uth_thread_t *tmp_curr = m_curr_thread;
		m_curr_thread = &m_scheduler_thread;
		uth_thread_swap(tmp_curr, &m_scheduler_thread);
	}
	debug("<-- yield %p %p\n", m_curr_thread, &m_scheduler_thread);
}

void uth_coop_thread_mgr::scheduler_main(void *ud)
{
	uth_coop_thread_mgr *mgr = static_cast<uth_coop_thread_mgr *>(ud);

	mgr->scheduler_main();
}

void uth_coop_thread_mgr::scheduler_main()
{
	uint32_t deadlocks = 0;
	while (1) {
		uth_thread_t *next_thread = 0;

//		if (m_terminated_thread_list) {
//			uth_thread_t *
//		}

//		fprintf(stdout, "--> scheduler_main\n");

//		uth_mutex_lock(&m_mutex);

		// Grab the thread at the top of the active list
		next_thread = m_active_thread_list;


		// If we find a thread to wake, then swap to it
		if (next_thread) {
			// Move it to the end of the list
			debug("next_thread=%p\n", next_thread);
			dump_threadlist(m_active_thread_list);
			unlink_thread(&m_active_thread_list, next_thread);
			append_thread(&m_active_thread_list, next_thread);
			debug("post-move\n");
			dump_threadlist(m_active_thread_list);

			if (next_thread == m_curr_thread) {
				// continue
				debug("next_thread == curr_thread %p\n", next_thread);
				continue;
			}

			// Swap to it
			m_curr_thread = next_thread;
//			uth_mutex_unlock(&m_mutex);
			debug("uth_thread_swap: %p %p\n", &m_scheduler_thread, next_thread);
			uth_thread_swap(&m_scheduler_thread, next_thread);
		} else {
			// We're deadlocked
			// TODO: FATAL
			debug("Error: deadlock\n");
			deadlocks++;
		}

//		fprintf(stdout, "<-- scheduler_main\n");
	}
}

void uth_coop_thread_mgr::unlink_thread(uth_thread_t **list, uth_thread_t *thread)
{
	if (thread->prev_thread) {
		thread->prev_thread->next_thread = thread->next_thread;
	}

	if (thread->next_thread) {
		thread->next_thread->prev_thread = thread->prev_thread;
	}

	if (*list == thread) {
		*list = thread->next_thread;
	}
}

void uth_coop_thread_mgr::append_thread(uth_thread_t **list, uth_thread_t *thread)
{
	thread->next_thread = 0;
	if (*list) {
		// Walk to the end
		uth_thread_t *t = *list;
		while (t->next_thread) {
			t = t->next_thread;
		}
		t->next_thread = thread;
		thread->prev_thread = t;
	} else {
		thread->prev_thread = 0;
		*list = thread;
	}
}


