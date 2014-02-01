/*
 * axi4_wb_bridge_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_test_base.h"

axi4_wb_bridge_test_base::axi4_wb_bridge_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

axi4_wb_bridge_test_base::~axi4_wb_bridge_test_base() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_test_base::build()
{
	m_env = axi4_wb_bridge_env::type_id.create("m_env", this);
}

void axi4_wb_bridge_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	axi4_master_bfm_dpi_mgr::connect(TB_ROOT + ".m0", m_env->m_m0->bfm_port);
	axi4_master_bfm_dpi_mgr::connect(TB_ROOT + ".m1", m_env->m_m1->bfm_port);
	wb_master_bfm_dpi_mgr::connect(TB_ROOT + ".m2", m_env->m_m2->bfm_port);
}

void axi4_wb_bridge_test_base::shutdown()
{

}

svf_test_ctor_def(axi4_wb_bridge_test_base)

