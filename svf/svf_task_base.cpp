/*
 * svf_task_base.cpp
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#include "svf_task_base.h"
#include "svf_task_mgr_base.h"
#include "svf_thread.h"

svf_task_base::svf_task_base() {
	// TODO Auto-generated constructor stub

}

svf_task_base::~svf_task_base() {
	// TODO Auto-generated destructor stub
}

void svf_task_base::init(svf_task_mgr_base *task_mgr)
{
	m_task_mgr = task_mgr;
}

void svf_task_base::run()
{
	// TODO: Always raising an objection isn't good
	m_task_mgr->raise_objection();
	body();
	m_task_mgr->drop_objection();
}

