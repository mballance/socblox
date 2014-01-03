/*
 * svf_semaphore.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVF_SEMAPHORE_H_
#define SVF_SEMAPHORE_H_
#include "svf_thread_cond.h"

class svf_semaphore {
	public:
		svf_semaphore(int count=0);

		~svf_semaphore();

		void put(int count=1);

		void get(int count=1);

		bool try_get(int count=1);

	private:
		int					m_count;
		svf_thread_cond		m_cond;
		svf_thread_mutex	m_mutex;
};

#endif /* SVF_SEMAPHORE_H_ */
