/*
 * svm_thread_mutex_sc.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */
#include "svm_thread_mutex.h"
#include "svm_thread_mutex_sc.h"

svm_thread_mutex_sc::svm_thread_mutex_sc() : m_owner_proc(0)
{
}

void svm_thread_mutex_sc::lock()
{
	sc_process_b *curr = sc_get_curr_process_handle();
	while (m_owner_proc && m_owner_proc != curr) {
		// Someone else owns this
		wait(m_wait_ev, sc_get_curr_simcontext());
	}
	// We now own this
	m_owner_proc = curr;
}

void svm_thread_mutex_sc::unlock()
{
	sc_process_b *curr = sc_get_curr_process_handle();
	if (!m_owner_proc) {
		// Error: not owned
	}

	if (m_owner_proc != curr) {
		// Error: someone else trying to unlock
	}

	m_owner_proc = 0;
	m_wait_ev.notify();
}

svm_thread_mutex_h svm_thread_mutex::create()
{
	return new svm_thread_mutex_sc();
}

void svm_thread_mutex::destroy(svm_thread_mutex_h m)
{
	delete static_cast<svm_thread_mutex_sc *>(m);
}

void svm_thread_mutex::lock(svm_thread_mutex_h m)
{
	static_cast<svm_thread_mutex_sc *>(m)->lock();
}

void svm_thread_mutex::unlock(svm_thread_mutex_h m)
{
	static_cast<svm_thread_mutex_sc *>(m)->unlock();
}



