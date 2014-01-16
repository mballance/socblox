/*
 * svf_task_base.h
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#ifndef SVF_TASK_BASE_H_
#define SVF_TASK_BASE_H_
#include "svf_closure.h"

class svf_task_mgr_base;

class svf_task_base : public svf_closure_base {

	public:
		svf_task_base();

		virtual ~svf_task_base();

		virtual void body() = 0;

		// Implementation
	public:
		void init(svf_task_mgr_base *task_mgr);

		virtual void run();

	protected:
		svf_task_mgr_base			*m_task_mgr;
};

#endif /* SVF_TASK_BASE_H_ */
