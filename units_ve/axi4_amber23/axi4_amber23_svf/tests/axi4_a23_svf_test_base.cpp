/*
 * axi4_a23_svf_test_base.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "axi4_a23_svf_test_base.h"
#include "axi4_svf_sram_dpi_mgr.h"
#include "a23_tracer_dpi_mgr.h"

axi4_a23_svf_test_base::axi4_a23_svf_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

axi4_a23_svf_test_base::~axi4_a23_svf_test_base() {
	// TODO Auto-generated destructor stub
}

void axi4_a23_svf_test_base::build()
{
	m_env = axi4_a23_env::type_id.create("m_env", this);
}

void axi4_a23_svf_test_base::connect()
{
	// Connect the BFM to the sram device in the Verilog testbench
	axi4_svf_sram_dpi_mgr::connect("tb.tb.v.s0", m_env->m_s0_bfm->port);

	// Connect the tracer to the
	a23_tracer_dpi_mgr::connect("tb.tb.v.core.u_tracer.u_svf_tracer", m_env->m_tracer->port);
}

void axi4_a23_svf_test_base::start()
{

}

