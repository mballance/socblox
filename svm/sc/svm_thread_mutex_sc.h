#ifndef INCLUDED_SVM_THREAD_MUTEX_SC_H
#define INCLUDED_SVM_THREAD_MUTEX_SC_H
#include <systemc.h>

class svm_thread_mutex_sc {
	public:
		svm_thread_mutex_sc();

		void lock();

		void unlock();

	private:
		sc_event				m_wait_ev;
		sc_process_b			*m_owner_proc;

};

#endif /* INCLUDED_SVM_THREAD_MUTEX_SC_H */

