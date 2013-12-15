/*
 * axi4_interconnect_test_base.h
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#ifndef AXI4_INTERCONNECT_TEST_BASE_H_
#define AXI4_INTERCONNECT_TEST_BASE_H_

#include "svm.h"
#include "axi4_interconnect_env.h"
// #include "axi4_interconnect_tb.h"

class axi4_interconnect_test_base : public svm_test {
	svm_test_ctor_decl(axi4_interconnect_test_base);

	public:
		axi4_interconnect_env		*m_env;

	public:
		axi4_interconnect_test_base(const char *name);

		virtual ~axi4_interconnect_test_base();

		void build();

		void connect();

		void start();

};

#endif /* AXI4_INTERCONNECT_TEST_BASE_H_ */
