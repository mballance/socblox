/*
 * svf_task_mgr_base.cpp
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#include "svf_task_mgr_base.h"
#include "svf_task_base.h"
#include "svf_thread.h"

svf_task_mgr_base::svf_task_mgr_base(const char *name, svf_component *parent) : svf_component(name, parent) {
	// TODO Auto-generated constructor stub

}

svf_task_mgr_base::~svf_task_mgr_base() {
	// TODO Auto-generated destructor stub
}

void svf_task_mgr_base::launch(svf_task_base *task)
{
	svf_thread *t = new svf_thread(task);
	m_threads.push_back(t);

	task->init(this);

	t->start();
}

