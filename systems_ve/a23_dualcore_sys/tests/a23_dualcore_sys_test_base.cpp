/*
 * a23_dualcore_sys_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_test_base.h"

a23_dualcore_sys_test_base::a23_dualcore_sys_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

a23_dualcore_sys_test_base::~a23_dualcore_sys_test_base() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_test_base::build()
{
	m_env = a23_dualcore_sys_env::type_id.create("m_env", this);
}

void a23_dualcore_sys_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	axi4_svf_rom_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.boot_rom", m_env->m_bootrom->port);
	uart_bfm_dpi_mgr::connect(TB_ROOT + ".u_uart_bfm", m_env->m_uart->bfm_port);

	a23_tracer_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.a23_subsys_0.u_a23_0.u_tracer.u_svf_tracer",
			m_env->m_core1_tracer->port);
	a23_tracer_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.a23_subsys_0.u_a23_1.u_tracer.u_svf_tracer",
			m_env->m_core2_tracer->port);
}

void a23_dualcore_sys_test_base::shutdown()
{

}

svf_test_ctor_def(a23_dualcore_sys_test_base)

