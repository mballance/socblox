/*
 * axi4_wb_bridge_bringup_test.h
 *
 *  Created on: Jan 13, 2014
 *      Author: ballance
 */

#ifndef AXI4_WB_BRIDGE_BRINGUP_TEST_H_
#define AXI4_WB_BRIDGE_BRINGUP_TEST_H_
#include "axi4_wb_bridge_test_base.h"

class axi4_wb_bridge_bringup_test : public axi4_wb_bridge_test_base {

	svf_test_ctor_decl(axi4_wb_bridge_bringup_test)

	public:
		axi4_wb_bridge_bringup_test(const char *name);

		virtual ~axi4_wb_bridge_bringup_test();

		virtual void start();

		void run_m0();

	private:
		svf_thread				m_m0_thread;
		svf_thread				m_m1_thread;
		svf_thread				m_m2_thread;
};

#endif /* AXI4_WB_BRIDGE_BRINGUP_TEST_H_ */
