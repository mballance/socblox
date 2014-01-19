/*
 * wb_uart_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_uart_test_base.h"

wb_uart_test_base::wb_uart_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

wb_uart_test_base::~wb_uart_test_base() {
	// TODO Auto-generated destructor stub
}

void wb_uart_test_base::build()
{
	m_env = wb_uart_env::type_id.create("m_env", this);
}

void wb_uart_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	wb_master_bfm_dpi_mgr::connect(TB_ROOT + ".m0", m_env->m_m0->bfm_port);
	uart_bfm_dpi_mgr::connect(TB_ROOT + ".uart_bfm_0", m_env->m_uart->bfm_port);
}

void wb_uart_test_base::shutdown()
{

}

svf_test_ctor_def(wb_uart_test_base)

