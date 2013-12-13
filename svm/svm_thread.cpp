/*
 * svm_thread.cpp
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#include "svm_thread.h"

svm_thread::svm_thread(const svm_closure_base *closure) : m_closure(closure) {
	// TODO Auto-generated constructor stub

}

svm_thread::~svm_thread() {
	// TODO Auto-generated destructor stub
}

void svm_thread::start()
{
	create_thread(m_closure);

}
