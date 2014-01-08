#ifndef INCLUDED_SVF_THREAD_COND_SC_H
#define INCLUDED_SVF_THREAD_COND_SC_H

class svf_thread_mutex_sc;

struct wait_ev {
	sc_event			m_ev;
	wait_ev				*m_next;
};

class svf_thread_cond_sc {

	public:

		svf_thread_cond_sc();

		void wait(svf_thread_mutex_sc *m);

		void notify();

		void notify_all();

	private:

		wait_ev			*m_waiters;
		wait_ev			*m_freelist;

};

#endif /* INCLUDED_SVF_THREAD_COND_SC_H */
