/*
 * svm_thread_mutex.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "svm_thread_mutex.h"

svm_thread_mutex::svm_thread_mutex() {
	m_mutex_h = create();
}

svm_thread_mutex::~svm_thread_mutex() {
	destroy(m_mutex_h);
}

void svm_thread_mutex::lock()
{
	lock(m_mutex_h);
}

void svm_thread_mutex::unlock()
{
	unlock(m_mutex_h);
}
