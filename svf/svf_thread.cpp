/*
 * svf_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svf_thread.h"

svf_thread::svf_thread() : m_closure(0) {

}

svf_thread::svf_thread(svf_closure_base *closure) : m_closure(closure) {
	// TODO Auto-generated constructor stub

}

void svf_thread::init(svf_closure_base *closure)
{
	if (m_closure) {
		delete m_closure;
	}
	m_closure = closure;
}

svf_thread::~svf_thread() {
	delete m_closure;
}

void svf_thread::start()
{
	if (m_closure) {
		create_thread(m_closure);
	} else {
		// Error:
	}
}

void svf_thread::yield()
{
	yield_thread();
}
