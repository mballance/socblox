
#include "svf_thread_cond.h"
#include "svf_thread_mutex_sc.h"
#include "svf_thread_cond_sc.h"

svf_thread_cond_sc::svf_thread_cond_sc() : m_waiters(0), m_freelist(0)
{

}

void svf_thread_cond_sc::wait(svf_thread_mutex_sc *m)
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

	// Lock the mutex on the way out
	m->lock();
}

void svf_thread_cond_sc::notify()
{
	// Select a target to notify
	if (m_waiters) {
		// Remove the waiter from the list
		wait_ev *waiter = m_waiters;

		m_waiters = m_waiters->m_next;
		waiter->m_ev.notify(sc_time(0, SC_NS));

		// Move the waiter to the freelist
		waiter->m_next = m_freelist;
		m_freelist = waiter;
	}
}

void svf_thread_cond_sc::notify_all()
{
	// Iterate through the list and notify all
	while (m_waiters) {
		// Remove the waiter from the list
		wait_ev *waiter = m_waiters;

		m_waiters = m_waiters->m_next;
		waiter->m_ev.notify(sc_time(0, SC_NS));

		// Move the waiter to the freelist
		waiter->m_next = m_freelist;
		m_freelist = waiter;
	}
}

svf_thread_cond_h svf_thread_cond::create()
{
	return new svf_thread_cond_sc();
}

void svf_thread_cond::destroy(svf_thread_cond_h c)
{
	delete static_cast<svf_thread_cond_sc *>(c);
}

void svf_thread_cond::wait(svf_thread_cond_h c, svf_thread_mutex_h m)
{
	static_cast<svf_thread_cond_sc *>(c)->wait(static_cast<svf_thread_mutex_sc *>(m));
}

void svf_thread_cond::notify(svf_thread_cond_h c)
{
	static_cast<svf_thread_cond_sc *>(c)->notify();
}

void svf_thread_cond::notify_all(svf_thread_cond_h c)
{
	static_cast<svf_thread_cond_sc *>(c)->notify_all();
}

