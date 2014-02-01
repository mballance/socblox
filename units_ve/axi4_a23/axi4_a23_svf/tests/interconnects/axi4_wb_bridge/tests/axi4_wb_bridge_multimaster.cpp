/*
 * axi4_wb_bridge_multimaster.cpp
 *
 *  Created on: Jan 14, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_multimaster.h"

axi4_wb_bridge_multimaster::axi4_wb_bridge_multimaster(const char *name) : axi4_wb_bridge_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_wb_bridge_multimaster::~axi4_wb_bridge_multimaster() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_multimaster::start() {
	m_m0_task.addr_bases.push_back(0x0);
	m_m0_task.addr_bases.push_back(0x1000);
	m_m0_task.addr_bases.push_back(0x2000);
	m_m2_task.addr_offset = 0;

	m_m1_task.addr_bases.push_back(0x0);
	m_m1_task.addr_bases.push_back(0x1000);
	m_m1_task.addr_bases.push_back(0x2000);
	m_m2_task.addr_offset = 0x400;

	m_m2_task.addr_bases.push_back(0x1000);
	m_m2_task.addr_bases.push_back(0x2000);
	m_m2_task.addr_offset = 0x800;

	m_env->m_m0_mgr->launch(&m_m0_task);
	m_env->m_m1_mgr->launch(&m_m1_task);
	m_env->m_m2_mgr->launch(&m_m2_task);
}

void axi4_wb_bridge_multimaster::shutdown()
{
	if (
			m_m0_task.pass &&
			m_m1_task.pass &&
			m_m2_task.pass
		) {
		fprintf(stdout, "PASS: axi4_wb_bridge_multimaster\n");
	} else {
		fprintf(stdout, "FAIL: axi4_wb_bridge_multimaster\n");
	}
}

svf_test_ctor_def(axi4_wb_bridge_multimaster)
