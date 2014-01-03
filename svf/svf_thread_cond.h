/*
 * svf_thread_cond.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVF_THREAD_COND_H_
#define SVF_THREAD_COND_H_
#include "svf_thread_mutex.h"

typedef void *svf_thread_cond_h;

class svf_thread_cond {

	public:
		svf_thread_cond();

		~svf_thread_cond();

		void wait(svf_thread_mutex &mutex);

		void notify();

		void notify_all();

	private:

		// Disabled
		svf_thread_cond(svf_thread_cond &c) : m_cond_h(0) {}

		static svf_thread_cond_h create();

		static void destroy(svf_thread_cond_h);

		static void wait(svf_thread_cond_h, svf_thread_mutex_h);

		static void notify(svf_thread_cond_h);

		static void notify_all(svf_thread_cond_h);

	private:
		svf_thread_cond_h			m_cond_h;

};

#endif /* SVF_THREAD_COND_H_ */
