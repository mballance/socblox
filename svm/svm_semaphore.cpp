/*
 * svm_semaphore.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "svm_semaphore.h"

svm_semaphore::svm_semaphore(int count) : m_count(count) {
}

svm_semaphore::~svm_semaphore() {
}

void svm_semaphore::get(int count)
{
	m_mutex.lock();

	while (m_count < count) {
		m_cond.wait(m_mutex);
	}

	m_count -= count;

	m_mutex.unlock();
}

void svm_semaphore::put(int count)
{
	m_mutex.lock();

	m_count += count;
	m_cond.notify();

	m_mutex.unlock();
}
