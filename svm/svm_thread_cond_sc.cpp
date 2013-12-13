
#include "svm_thread_cond.h"
#include "svm_thread_mutex_sc.h"
#include "svm_thread_cond_sc.h"

svm_thread_cond_sc::svm_thread_cond_sc() : m_waiters(0), m_freelist(0)
{

}

void svm_thread_cond_sc::wait(svm_thread_mutex_sc *m)
{
	// Expect mutex to be locked on entry
	wait_ev *waiter;
	if (m_freelist) {
		waiter = m_freelist;
		m_freelist = m_freelist->m_next;
	} else {
		waiter = new wait_ev();
	}

	waiter->m_next = m_waiters;
	m_waiters = waiter;

	m->unlock();

	// Wait
	sc_core::wait(waiter->m_ev, sc_get_curr_simcontext());

	// Move the waiter to the freelist
	waiter->m_next = m_freelist;
	m_freelist = waiter;

	// Lock the mutex on the way out
	m->lock();
}

void svm_thread_cond_sc::notify()
{
	// Select a target to notify
	if (m_waiters) {
		// Remove the waiter from the list
		wait_ev *waiter = m_waiters;

		m_waiters = m_waiters->m_next;
		waiter->m_ev.notify();
	}
}

void svm_thread_cond_sc::notify_all()
{
	// Iterate through the list and notify all
	while (m_waiters) {
		// Remove the waiter from the list
		wait_ev *waiter = m_waiters;

		m_waiters = m_waiters->m_next;
		waiter->m_ev.notify();
	}
}

svm_thread_cond_h svm_thread_cond::create()
{
	return new svm_thread_cond_sc();
}

void svm_thread_cond::destroy(svm_thread_cond_h c)
{
	delete static_cast<svm_thread_cond_sc *>(c);
}

void svm_thread_cond::wait(svm_thread_cond_h c, svm_thread_mutex_h m)
{
	static_cast<svm_thread_cond_sc *>(c)->wait(static_cast<svm_thread_mutex_sc *>(m));
}

void svm_thread_cond::notify(svm_thread_cond_h c)
{
	static_cast<svm_thread_cond_sc *>(c)->notify();
}

void svm_thread_cond::notify_all(svm_thread_cond_h c)
{
	static_cast<svm_thread_cond_sc *>(c)->notify_all();
}

