/*
 * svm_sc_thread.h
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#ifndef SVM_SC_THREAD_H_
#define SVM_SC_THREAD_H_

#include "svm_closure.h"
#include "svm_thread.h"

class svm_sc_thread : public svm_thread {
	public:
		svm_sc_thread(const svm_closure &closure);

		virtual ~svm_sc_thread();

		void start();

		void join();

		static svm_thread *self();

	private:

		void trampoline();

	private:
		svm_closure				m_closure;
};

#endif /* SVM_SC_THREAD_H_ */
