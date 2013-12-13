/*
 * svm_closure.h
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#ifndef SVM_CLOSURE_H_
#define SVM_CLOSURE_H_
#include <stdio.h>

class svm_closure_base {
	public:
		svm_closure_base() { }

		virtual ~svm_closure_base() { }

		virtual void operator()() const { }

};


template <class cls> class svm_closure : public svm_closure_base {
	public:
		svm_closure(cls *t_cls, void (cls::*method)()) : m_cls(t_cls), m_method(method) {}

		void operator()() const {
			fprintf(stdout, "--> calling method\n");
			(*m_cls.*m_method)();
			fprintf(stdout, "<-- calling method\n");
		}

	private:
		cls				*m_cls;
		void (cls::*m_method)();
};

#endif /* SVM_CLOSURE_H_ */
