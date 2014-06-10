/*
 * uth_coop_thread_mgr.cpp
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */

#include "uth_coop_thread_mgr.h"
#include <memory.h>
#include <stdio.h>

uth_coop_thread_mgr::uth_coop_thread_mgr() {
	// TODO Auto-generated constructor stub

}

uth_coop_thread_mgr::~uth_coop_thread_mgr() {
	// TODO Auto-generated destructor stub
}

void uth_coop_thread_mgr::init()
{
	// Create a thread to represent the main thread
	uth_main_thread_init(&m_main_thread);

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
	append_thread(&m_active_thread_list, thread);
}

void uth_coop_thread_mgr::thread_end(uth_thread_t *thread)
{
	// Remove this thread from
	unlink_thread(&m_active_thread_list, thread);
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
	fprintf(stdout, "yield: m_curr_thread=%p m_scheduler_thread=%p\n", m_curr_thread, &m_scheduler_thread);
	fflush(stdout);
	uth_thread_swap(m_curr_thread, &m_scheduler_thread);
}

void uth_coop_thread_mgr::scheduler_main(void *ud)
{
	uth_coop_thread_mgr *mgr = static_cast<uth_coop_thread_mgr *>(ud);

	mgr->scheduler_main();
}

void uth_coop_thread_mgr::scheduler_main()
{
	while (1) {
		uth_thread_t *next_thread = 0;

		fprintf(stdout, "--> scheduler_main\n");

		uth_mutex_lock(&m_mutex);

		// Grab the thread at the top of the active list
		next_thread = m_active_thread_list;


		// If we find a thread to wake, then swap to it
		if (next_thread) {
			// Move it to the end of the list
			unlink_thread(&m_active_thread_list, next_thread);
			append_thread(&m_active_thread_list, next_thread);

			// Swap to it
			m_curr_thread = next_thread;
			uth_mutex_unlock(&m_mutex);
			uth_thread_swap(&m_scheduler_thread, next_thread);
		} else {
			// We're deadlocked
			// TODO: FATAL
		}

		fprintf(stdout, "<-- scheduler_main\n");
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


