/*
 * svf_thread_uth.cpp
 *
 *  Created on: Jul 21, 2014
 *      Author: ballance
 */

#include "svf_thread.h"
#include "svf_thread_mutex.h"
#include "svf_thread_cond.h"
#include "uth.h"

static void svf_uth_thread_proc(void *ud) {
	svf_closure_base *closure = static_cast<svf_closure_base *>(ud);

	(*closure)();
}


svf_native_thread_h svf_thread::create_thread(svf_closure_base *closure)
{
	uth_thread_t *thread = new uth_thread_t();
	uth_thread_create(thread, &svf_uth_thread_proc, closure);

	return thread;
}

void svf_thread::yield_thread()
{
	uth_thread_yield();
}

svf_thread_mutex_h svf_thread_mutex::create()
{
	return new uth_mutex_t();
}

void svf_thread_mutex::destroy(svf_thread_mutex_h m)
{
	delete static_cast<uth_mutex_t *>(m);
}

void svf_thread_mutex::lock(svf_thread_mutex_h m)
{
	uth_mutex_lock(static_cast<uth_mutex_t *>(m));
}

void svf_thread_mutex::unlock(svf_thread_mutex_h m)
{
	uth_mutex_unlock(static_cast<uth_mutex_t *>(m));
}

svf_thread_cond_h svf_thread_cond::create()
{
	return new uth_cond_t();
}

void svf_thread_cond::destroy(svf_thread_cond_h c)
{
	delete static_cast<uth_cond_t *>(c);
}

void svf_thread_cond::wait(svf_thread_cond_h c, svf_thread_mutex_h m)
{
	uth_cond_wait(
			static_cast<uth_cond_t *>(c),
			static_cast<uth_mutex_t *>(m));
}

void svf_thread_cond::notify(svf_thread_cond_h c)
{
	uth_cond_signal(static_cast<uth_cond_t *>(c));
}

void svf_thread_cond::notify_all(svf_thread_cond_h c)
{
	uth_cond_broadcast(static_cast<uth_cond_t *>(c));
}

