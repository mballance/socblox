
#include "svf_thread_cond.h"
#include <stdio.h>
#include "svf_dpi_int.h"

#ifdef UNDEFINED
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

	// Move the waiter to the freelist
	waiter->m_next = m_freelist;
	m_freelist = waiter;

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
		waiter->m_ev.notify();
	}
}

void svf_thread_cond_sc::notify_all()
{
	// Iterate through the list and notify all
	while (m_waiters) {
		// Remove the waiter from the list
		wait_ev *waiter = m_waiters;

		m_waiters = m_waiters->m_next;
		waiter->m_ev.notify();
	}
}
#endif

svf_thread_cond_h svf_thread_cond::create()
{
	void *ret;
	uint32_t cond_id = get_svf_dpi_api()->create_cond();

	return reinterpret_cast<svf_thread_cond_h>(cond_id);
}

void svf_thread_cond::destroy(svf_thread_cond_h c)
{
//	delete static_cast<svf_thread_cond_sc *>(c);
}

void svf_thread_cond::wait(svf_thread_cond_h c, svf_thread_mutex_h m)
{
	get_svf_dpi_api()->cond_wait((uint32_t)c, (uint32_t)m);
}

void svf_thread_cond::notify(svf_thread_cond_h c)
{
	get_svf_dpi_api()->cond_notify((uint32_t)c);
}

void svf_thread_cond::notify_all(svf_thread_cond_h c)
{
	get_svf_dpi_api()->cond_notify_all((uint32_t)c);
}

