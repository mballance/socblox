/*
 * axi4_interconnect_testbase.cpp
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#include "axi4_interconnect_test_base.h"
#include "axi4_master_bfm_dpi_mgr.h"

axi4_interconnect_test_base::axi4_interconnect_test_base(const char *name) : svm_test(name) {

}

axi4_interconnect_test_base::~axi4_interconnect_test_base() {
	// TODO Auto-generated destructor stub
}

void axi4_interconnect_test_base::build()
{
	m_env = axi4_interconnect_env::type_id.create("m_env", this);
}

void axi4_interconnect_test_base::connect()
{
	axi4_master_bfm_dpi_mgr::connect("tb.tb.v.bfm_1", m_env->m_m1_bfm->bfm_port);
	axi4_master_bfm_dpi_mgr::connect("tb.tb.v.bfm_2", m_env->m_m2_bfm->bfm_port);
}

void axi4_interconnect_test_base::start()
{
	fprintf(stdout, "start\n");
}

svm_test_ctor_def(axi4_interconnect_test_base);
