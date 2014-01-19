/*
 * svf_sc_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svf_thread.h"
#ifdef _WIN32
#else
#include <pthread.h>
#endif

static void *svf_host_thread_proc(void *ud) {
	svf_closure_base *closure = static_cast<svf_closure_base *>(ud);

	(*closure)();

	return 0;
}

svf_native_thread_h svf_thread::create_thread(svf_closure_base *closure)
{
	pthread_t *thread = new pthread_t;
	void *ud = (void *)(closure);

	pthread_create(thread, 0, &svf_host_thread_proc, ud);

	return thread;
}

void svf_thread::yield_thread()
{
	pthread_yield();
}

