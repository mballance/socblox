/*
 * svm_thread.h
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#ifndef SVM_THREAD_H_
#define SVM_THREAD_H_
#include "svm_closure.h"

typedef void *svm_native_thread_h;

class svm_thread {
	public:
		template <class cls> svm_thread(cls *client, void (cls::*method)()) :
			m_closure(new svm_closure<cls>(client, method)) { }

		svm_thread();

		svm_thread(const svm_closure_base *closure);

		template <class cls> void init(cls *client, void (cls::*method)()) {
			init(new svm_closure<cls>(client, method));
		}

		void init(const svm_closure_base *closure);

		virtual ~svm_thread();

		void start();

		// Implementation-specific
		static svm_thread *self();

		template <class cls> static svm_thread *create(cls *client, void (cls::*method)()) {
			return new svm_thread(new svm_closure<cls>(client, method));
		}

	private:

		const svm_closure_base				*m_closure;

		static svm_native_thread_h create_thread(const svm_closure_base *closure);

		static void cleanup_thread(svm_native_thread_h);

};

#endif /* SVM_THREAD_H_ */
