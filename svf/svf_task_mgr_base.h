/*
 * svf_task_mgr_base.h
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#ifndef SVF_TASK_MGR_BASE_H_
#define SVF_TASK_MGR_BASE_H_
#include "svf_component.h"
#include "svf_thread_mutex.h"
#include <vector>

using std::vector;

class svf_task_base;
class svf_thread;

class svf_task_mgr_base : public svf_component {

	public:
		svf_task_mgr_base(const char *name, svf_component *parent);

		virtual ~svf_task_mgr_base();

		void lock(svf_task_base *task);

		void unlock(svf_task_base *task);

	protected:

		// Non-blocking way to start a task
		void launch(svf_task_base *task);

	private:
		svf_thread_mutex						m_mutex;
		vector<svf_thread *>					m_threads;
};

#endif /* SVF_TASK_MGR_BASE_H_ */
