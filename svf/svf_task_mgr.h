/*
 * svf_task_mgr.h
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#ifndef SVF_TASK_MGR_H_
#define SVF_TASK_MGR_H_
#include "svf_task_mgr_base.h"

template <class T> class svf_task;

template <class T> class svf_task_mgr : public svf_task_mgr_base {

	public:
		svf_task_mgr(const char *name, svf_component *parent) :
			svf_task_mgr_base(name, parent) { }

		virtual ~svf_task_mgr() {}

		void connect(T *api) { m_api = api; }

		void launch(svf_task<T> *task) {
			svf_task_mgr_base::launch(static_cast<svf_task_base *>(task));
		}

		T *api() const {
			return m_api;
		}

	private:

		T						*m_api;




};

#endif /* SVF_TASK_MGR_H_ */
