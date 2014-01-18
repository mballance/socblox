/*
 * axi4_wb_bridge_multimaster.h
 *
 *  Created on: Jan 14, 2014
 *      Author: ballance
 */

#ifndef AXI4_WB_BRIDGE_MULTIMASTER_H_
#define AXI4_WB_BRIDGE_MULTIMASTER_H_
#include "axi4_wb_bridge_test_base.h"
#include "axi4_wb_bridge_multislave_task.h"


class axi4_wb_bridge_multimaster : public axi4_wb_bridge_test_base {
	svf_test_ctor_decl(axi4_wb_bridge_multimaster)

	public:
		axi4_wb_bridge_multimaster(const char *name);

		virtual ~axi4_wb_bridge_multimaster();

		virtual void start();

		virtual void shutdown();

	private:

		axi4_wb_bridge_multislave_task		m_m0_task;
		axi4_wb_bridge_multislave_task		m_m1_task;
		axi4_wb_bridge_multislave_task		m_m2_task;


};

#endif /* AXI4_WB_BRIDGE_MULTIMASTER_H_ */
