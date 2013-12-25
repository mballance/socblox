/*
 * axi4_a23_svm_test_base.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef AXI4_A23_SVM_TEST_BASE_H_
#define AXI4_A23_SVM_TEST_BASE_H_

#include "svm.h"
#include "axi4_a23_env.h"

class axi4_a23_svm_test_base: public svm_test {

	public:

		axi4_a23_svm_test_base(const char *name);

		virtual ~axi4_a23_svm_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

	protected:
		axi4_a23_env					*m_env;

};

#endif /* AXI4_A23_SVM_TEST_BASE_H_ */
