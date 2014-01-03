/*
 * svf_semaphore.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "svf_semaphore.h"

svf_semaphore::svf_semaphore(int count) : m_count(count) {
}

svf_semaphore::~svf_semaphore() {
}

void svf_semaphore::get(int count)
{
	m_mutex.lock();

	while (m_count < count) {
		m_cond.wait(m_mutex);
	}

	m_count -= count;

	m_mutex.unlock();
}

void svf_semaphore::put(int count)
{
	m_mutex.lock();

	m_count += count;
	m_cond.notify_all();

	m_mutex.unlock();
}

bool svf_semaphore::try_get(int count)
{
	bool ret = false;
	m_mutex.lock();

	if (m_count <= count) {
		m_count -= count;
		ret = true;
	}

	m_mutex.unlock();

	return ret;
}

