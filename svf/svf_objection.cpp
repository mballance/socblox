/*
 * svf_objection.cpp
 *
 *  Created on: Dec 26, 2013
 *      Author: ballance
 */

#include "svf_objection.h"
#include "svf_thread.h"
#include <stdint.h>

svf_objection::svf_objection() : m_objections(0) {
	// TODO Auto-generated constructor stub

}

svf_objection::~svf_objection() {
	// TODO Auto-generated destructor stub
}

void svf_objection::raise()
{
	m_mutex.lock();
	m_objections++;
	m_mutex.unlock();
}

void svf_objection::drop()
{
//	fprintf(stdout, "--> drop %d\n", m_objections);
	m_mutex.lock();
	if (m_objections > 0) {
		m_objections--;
	} else {
		// Error
	}

	if (m_objections == 0) {
//		fprintf(stdout, " -- notify_all\n");
		m_cond.notify_all();
	}
	m_mutex.unlock();
//	fprintf(stdout, "<-- drop %d\n", m_objections);
}

void svf_objection::wait_all_dropped()
{
	for (int i=0; i<100; i++) {
		svf_thread::yield();
		if (m_objections > 0) {
			break;
		}
	}

	m_mutex.lock();
	while (m_objections > 0) {
//		fprintf(stdout, "-- wait_all_dropped: m_objections=%d\n", m_objections);
		m_cond.wait(m_mutex);
	}
	m_mutex.unlock();
}

