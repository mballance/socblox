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
//	m_env->m_m0_mgr->launch(&m_m0_task);
	m_env->m_m1_mgr->launch(&m_m1_task);
	m_env->m_m2_mgr->launch(&m_m2_task);
}

svf_test_ctor_def(axi4_wb_bridge_multimaster)
