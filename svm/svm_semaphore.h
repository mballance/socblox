/*
 * svm_semaphore.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVM_SEMAPHORE_H_
#define SVM_SEMAPHORE_H_
#include "svm_thread_cond.h"

class svm_semaphore {
	public:
		svm_semaphore(int count=0);

		~svm_semaphore();

		void put(int count=1);

		void get(int count=1);

	private:
		int					m_count;
		svm_thread_cond		m_cond;
		svm_thread_mutex	m_mutex;
};

#endif /* SVM_SEMAPHORE_H_ */
