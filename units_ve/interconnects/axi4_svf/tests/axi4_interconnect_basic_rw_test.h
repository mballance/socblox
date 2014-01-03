/*
 * axi4_interconnect_basic_rw_test.h
 *
 *  Created on: Dec 15, 2013
 *      Author: ballance
 */

#ifndef AXI4_INTERCONNECT_BASIC_RW_TEST_H_
#define AXI4_INTERCONNECT_BASIC_RW_TEST_H_

#include "axi4_interconnect_test_base.h"

class axi4_interconnect_basic_rw_test: public axi4_interconnect_test_base {
	svf_test_ctor_decl(axi4_interconnect_basic_rw_test)

	public:
		axi4_interconnect_basic_rw_test(const char *name);

		virtual ~axi4_interconnect_basic_rw_test();

		virtual void start();

		void run_m1();
		void run_m2();

	private:
		svf_thread				m_m1_run_thread;
		svf_thread				m_m2_run_thread;
};

#endif /* AXI4_INTERCONNECT_BASIC_RW_TEST_H_ */
