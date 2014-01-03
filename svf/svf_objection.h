/*
 * svf_objection.h
 *
 *  Created on: Dec 26, 2013
 *      Author: ballance
 */

#ifndef SVF_OBJECTION_H_
#define SVF_OBJECTION_H_
#include "svf_thread_mutex.h"
#include "svf_thread_cond.h"
#include <stdint.h>

class svf_objection {

	public:
		svf_objection();

		virtual ~svf_objection();

		void raise();

		void drop();

		void wait_all_dropped();

	private:
		uint32_t			m_objections;
		svf_thread_mutex	m_mutex;
		svf_thread_cond		m_cond;
};

#endif /* SVF_OBJECTION_H_ */
