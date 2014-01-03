/*
 * svf_thread_mutex.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "svf_thread_mutex.h"

svf_thread_mutex::svf_thread_mutex() {
	m_mutex_h = create();
}

svf_thread_mutex::~svf_thread_mutex() {
	destroy(m_mutex_h);
}

void svf_thread_mutex::lock()
{
	lock(m_mutex_h);
}

void svf_thread_mutex::unlock()
{
	unlock(m_mutex_h);
}
