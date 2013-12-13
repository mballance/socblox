/*
 * svm_thread_cond.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVM_THREAD_COND_H_
#define SVM_THREAD_COND_H_
#include "svm_thread_mutex.h"

typedef void *svm_thread_cond_h;

class svm_thread_cond {

	public:
		svm_thread_cond();

		~svm_thread_cond();

		void wait(svm_thread_mutex &mutex);

		void notify();

		void notify_all();

	private:

		// Disabled
		svm_thread_cond(svm_thread_cond &c) : m_cond_h(0) {}

		static svm_thread_cond_h create();

		static void destroy(svm_thread_cond_h);

		static void wait(svm_thread_cond_h, svm_thread_mutex_h);

		static void notify(svm_thread_cond_h);

		static void notify_all(svm_thread_cond_h);

	private:
		svm_thread_cond_h			m_cond_h;

};

#endif /* SVM_THREAD_COND_H_ */
