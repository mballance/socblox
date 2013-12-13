#ifndef INCLUDED_SVM_THREAD_COND_SC_H
#define INCLUDED_SVM_THREAD_COND_SC_H

class svm_thread_mutex_sc;

struct wait_ev {
	sc_event			m_ev;
	wait_ev				*m_next;
};

class svm_thread_cond_sc {

	public:

		svm_thread_cond_sc();

		void wait(svm_thread_mutex_sc *m);

		void notify();

		void notify_all();

	private:

		wait_ev			*m_waiters;
		wait_ev			*m_freelist;

};

#endif /* INCLUDED_SVM_THREAD_COND_SC_H */
