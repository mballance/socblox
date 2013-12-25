/*
 * svm_root.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_ROOT_H_
#define SVM_ROOT_H_

#include "svm_component.h"

class svm_cmdline;

class svm_root : public svm_component {

	public:
		svm_root(const char *name);

		virtual ~svm_root();

//		static int svm_runtest_init(const char *testname);

		void elaborate();

		void run();

		svm_cmdline &cmdline();

	private:

		void do_build(svm_component *level);

		void do_connect(svm_component *level);

		void do_start(svm_component *level);

	private:

		svm_cmdline					*m_cmdline;

};

#endif /* SVM_ROOT_H_ */
