/*
 * svf_thread_mutex_sc.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */
#include "svf_thread_mutex.h"
#include "svf_thread_mutex_sc.h"

svf_thread_mutex_sc::svf_thread_mutex_sc() : m_owner_proc(0)
{
}

void svf_thread_mutex_sc::lock()
{
	sc_process_b *curr = sc_get_current_process_b();
	while (m_owner_proc && m_owner_proc != curr) {
		// Someone else owns this
		wait(m_wait_ev, sc_get_curr_simcontext());
	}
	// We now own this
	m_owner_proc = curr;
}

void svf_thread_mutex_sc::unlock()
{
	sc_process_b *curr = sc_get_current_process_b();
	if (!m_owner_proc) {
		// Error: not owned
	}

	if (m_owner_proc != curr) {
		// Error: someone else trying to unlock
	}

	m_owner_proc = 0;
	m_wait_ev.notify();
}

svf_thread_mutex_h svf_thread_mutex::create()
{
	return new svf_thread_mutex_sc();
}

void svf_thread_mutex::destroy(svf_thread_mutex_h m)
{
	delete static_cast<svf_thread_mutex_sc *>(m);
}

void svf_thread_mutex::lock(svf_thread_mutex_h m)
{
	static_cast<svf_thread_mutex_sc *>(m)->lock();
}

void svf_thread_mutex::unlock(svf_thread_mutex_h m)
{
	static_cast<svf_thread_mutex_sc *>(m)->unlock();
}



