/*
 * svf_sc_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svf_thread.h"
#include "systemc.h"

class svf_sc_thread_proc : public sc_process_host {
	public:

		svf_sc_thread_proc(svf_closure_base *closure) : m_closure(closure) {}

		void run() {
			fprintf(stdout, "m_closure=%p\n", m_closure);
			(*m_closure)();
		}

	private:
		svf_closure_base		*const m_closure;
};

svf_native_thread_h svf_thread::create_thread(svf_closure_base *closure)
{
	sc_simcontext *context_p = sc_get_curr_simcontext();
	sc_module *curr = context_p->hierarchy_curr();
	sc_thread_handle *thread = 0;

	fprintf(stdout, "m_closure1=%p\n", closure);

	context_p->create_thread_process(sc_gen_unique_name("svf_thread"), false,
			static_cast<sc_core::SC_ENTRY_FUNC>(&svf_sc_thread_proc::run),
			new svf_sc_thread_proc(closure), 0);


	return thread;
}

void svf_thread::yield_thread()
{
	sc_simcontext *context_p = sc_get_curr_simcontext();

	// Wait for a delta cycle
	wait(sc_time(0, SC_NS), context_p);
}

