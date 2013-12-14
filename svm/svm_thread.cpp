/*
 * svm_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svm_thread.h"

svm_thread::svm_thread() : m_closure(0) {

}

svm_thread::svm_thread(const svm_closure_base *closure) : m_closure(closure) {
	// TODO Auto-generated constructor stub

}

void svm_thread::init(const svm_closure_base *closure)
{
	if (m_closure) {
		delete m_closure;
	}
	m_closure = closure;
}

svm_thread::~svm_thread() {
	delete m_closure;
}

void svm_thread::start()
{
	if (m_closure) {
		create_thread(m_closure);
	} else {
		// Error:
	}
}
