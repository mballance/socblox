/*
 * svm_objection.h
 *
 *  Created on: Dec 26, 2013
 *      Author: ballance
 */

#ifndef SVM_OBJECTION_H_
#define SVM_OBJECTION_H_
#include "svm_thread_mutex.h"
#include "svm_thread_cond.h"
#include <stdint.h>

class svm_objection {

	public:
		svm_objection();

		virtual ~svm_objection();

		void raise();

		void drop();

		void wait_all_dropped();

	private:
		uint32_t			m_objections;
		svm_thread_mutex	m_mutex;
		svm_thread_cond		m_cond;
};

#endif /* SVM_OBJECTION_H_ */
