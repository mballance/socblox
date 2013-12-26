/*
 * svm_objection.cpp
 *
 *  Created on: Dec 26, 2013
 *      Author: ballance
 */

#include "svm_objection.h"
#include "svm_thread.h"
#include <stdint.h>

svm_objection::svm_objection() : m_objections(0) {
	// TODO Auto-generated constructor stub

}

svm_objection::~svm_objection() {
	// TODO Auto-generated destructor stub
}

void svm_objection::raise()
{
	m_mutex.lock();
	m_objections++;
	m_mutex.unlock();
}

void svm_objection::drop()
{
	m_mutex.lock();
	if (m_objections > 0) {
		m_objections--;
	} else {
		// Error
	}

	if (m_objections == 0) {
		m_cond.notify_all();
	}
	m_mutex.unlock();
}

void svm_objection::wait_all_dropped()
{
	for (int i=0; i<100; i++) {
		svm_thread::yield();
	}

	m_mutex.lock();
	while (m_objections > 0) {
		m_cond.wait(m_mutex);
	}
	m_mutex.unlock();
}

