/*
 * svm_thread_cond.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "svm_thread_cond.h"

svm_thread_cond::svm_thread_cond() {
	m_cond_h = create();
}

svm_thread_cond::~svm_thread_cond() {
	destroy(m_cond_h);
}

void svm_thread_cond::wait(svm_thread_mutex &mutex)
{
	wait(m_cond_h, mutex.m_mutex_h);
}

void svm_thread_cond::notify()
{
	notify(m_cond_h);
}

void svm_thread_cond::notify_all()
{
	notify_all(m_cond_h);
}
