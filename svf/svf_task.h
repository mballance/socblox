/*
 * svf_task.h
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#ifndef SVF_TASK_H_
#define SVF_TASK_H_
#include "svf_task_base.h"

template <class T> class svf_task_mgr;

template <class T> class svf_task : public svf_task_base {

	public:

		svf_task_mgr<T> *task_mgr() const {
			return static_cast<svf_task_mgr<T> *>(m_task_mgr);
		}

		virtual ~svf_task() {}

		T *api() const {
			return static_cast<svf_task_mgr<T> *>(m_task_mgr)->api();
		}

};

#endif /* SVF_TASK_H_ */
