/*
 * svf_sc_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svf_thread.h"
#include "svf_dpi_int.h"

// extern "C" void svf_dpi_create_thread(void *ud, void **out_p);

typedef void (*create_thread_f)(void *ud, void **out_p);
static create_thread_f				prv_create_thread = 0;

extern "C" int svf_dpi_create_thread_trampoline(void *ud);
int svf_dpi_create_thread_trampoline(void *ud)
{
	const svf_closure_base *closure = static_cast<const svf_closure_base *>(ud);

	(*closure)();
	return 0;
}


svf_native_thread_h svf_thread::create_thread(const svf_closure_base *closure)
{
	svf_native_thread_h *thread;

	get_svf_dpi_api()->create_thread((void *)closure, (void **)&thread);

	fprintf(stdout, "thread=%p\n", thread);

	return thread;
}

void svf_thread::yield_thread()
{
	/*
	sc_simcontext *context_p = sc_get_curr_simcontext();

	// Wait for a delta cycle
	wait(sc_time(0, SC_NS), context_p);
	 */
}

