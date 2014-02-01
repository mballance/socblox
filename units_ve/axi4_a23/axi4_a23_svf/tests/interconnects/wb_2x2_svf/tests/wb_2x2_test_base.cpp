/*
 * wb_2x2_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_2x2_test_base.h"

wb_2x2_test_base::wb_2x2_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

wb_2x2_test_base::~wb_2x2_test_base() {
	// TODO Auto-generated destructor stub
}

void wb_2x2_test_base::build()
{
	m_env = wb_2x2_env::type_id.create("m_env", this);
}

void wb_2x2_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	wb_master_bfm_dpi_mgr::connect(TB_ROOT + ".m0", m_env->m_m0->bfm_port);
	wb_master_bfm_dpi_mgr::connect(TB_ROOT + ".m1", m_env->m_m1->bfm_port);

}

svf_test_ctor_def(wb_2x2_test_base)

