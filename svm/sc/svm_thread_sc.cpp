/*
 * svm_sc_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svm_thread.h"
#include "systemc.h"

class svm_sc_thread_proc : public sc_process_host {
	public:

		svm_sc_thread_proc(const svm_closure_base *closure) : m_closure(closure) {}

		void run() {
			fprintf(stdout, "m_closure=%p\n", m_closure);
			(*m_closure)();
		}

	private:
		const svm_closure_base		*m_closure;
};

svm_native_thread_h svm_thread::create_thread(const svm_closure_base *closure)
{
	sc_simcontext *context_p = sc_get_curr_simcontext();
	sc_module *curr = context_p->hierarchy_curr();
	sc_thread_handle *thread = 0;

	fprintf(stdout, "m_closure1=%p\n", closure);

	context_p->create_thread_process("t1", false,
			static_cast<sc_core::SC_ENTRY_FUNC>(&svm_sc_thread_proc::run),
			new svm_sc_thread_proc(closure), 0);


	return thread;
}

void svm_thread::yield_thread()
{
	sc_simcontext *context_p = sc_get_curr_simcontext();

	// Wait for a delta cycle
	wait(sc_time(0, SC_NS), context_p);
}

