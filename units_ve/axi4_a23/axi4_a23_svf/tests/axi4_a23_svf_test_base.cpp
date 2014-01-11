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

/*
#ifdef QUESTA
#define TB_ROOT "axi4_a23_svf_tb"
#else
#define TB_ROOT "tb.tb.v"
#endif
 */

void axi4_a23_svf_test_base::connect()
{
	const char *TB_ROOT_c;

	if (get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "TB_ROOT=%s\n", TB_ROOT_c);
	} else {
		fprintf(stdout, "TB_ROOT: FAIL\n");
	}

	string TB_ROOT(TB_ROOT_c);

	// Connect the BFM to the sram device in the Verilog testbench
	axi4_svf_sram_dpi_mgr::connect(TB_ROOT + ".s0", m_env->m_s0_bfm->port);

	// Connect the tracer to the
	a23_tracer_dpi_mgr::connect(TB_ROOT + ".core.u_tracer.u_svf_tracer", m_env->m_tracer->port);
}

void axi4_a23_svf_test_base::start()
{

}

