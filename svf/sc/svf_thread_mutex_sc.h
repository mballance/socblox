#ifndef INCLUDED_SVF_THREAD_MUTEX_SC_H
#define INCLUDED_SVF_THREAD_MUTEX_SC_H
#include <systemc.h>

class svf_thread_mutex_sc {
	public:
		svf_thread_mutex_sc();

		void lock();

		void unlock();

	private:
		sc_event				m_wait_ev;
		sc_process_b			*m_owner_proc;

};

#endif /* INCLUDED_SVF_THREAD_MUTEX_SC_H */

