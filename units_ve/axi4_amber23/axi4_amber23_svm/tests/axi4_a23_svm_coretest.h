/*
 * axi4_a23_svm_coretest.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef AXI4_A23_SVM_CORETEST_H_
#define AXI4_A23_SVM_CORETEST_H_

#include "axi4_a23_svm_test_base.h"

class axi4_a23_svm_coretest: public axi4_a23_svm_test_base {
	svm_test_ctor_decl(axi4_a23_svm_coretest)

	public:
		axi4_a23_svm_coretest(const char *name);

		virtual ~axi4_a23_svm_coretest();

		virtual void build();

		virtual void connect();

		virtual void start();

		void run();

	private:
		svm_thread					m_run_thread;

};

#endif /* AXI4_A23_SVM_CORETEST_H_ */
