/*
 * svm_root.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_ROOT_H_
#define SVM_ROOT_H_

#include "svm_component.h"
#include "svm_objection.h"

class svm_cmdline;

class svm_root : public svm_component {

	public:
		svm_root(const char *name);

		virtual ~svm_root();

		void elaborate();

		void run();

		svm_cmdline &cmdline();

		virtual void raise_objection();

		virtual void drop_objection();

	private:

		void do_build(svm_component *level);

		void do_connect(svm_component *level);

		void do_start(svm_component *level);

	private:

		svm_cmdline					*m_cmdline;
		svm_objection				m_objection;

};

#endif /* SVM_ROOT_H_ */
