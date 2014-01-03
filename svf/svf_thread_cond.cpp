/*
 * svf_thread_cond.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "svf_thread_cond.h"

svf_thread_cond::svf_thread_cond() {
	m_cond_h = create();
}

svf_thread_cond::~svf_thread_cond() {
	destroy(m_cond_h);
}

void svf_thread_cond::wait(svf_thread_mutex &mutex)
{
	wait(m_cond_h, mutex.m_mutex_h);
}

void svf_thread_cond::notify()
{
	notify(m_cond_h);
}

void svf_thread_cond::notify_all()
{
	notify_all(m_cond_h);
}
