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

	m_c0mon_logger = new axi4_monitor_stream_logger("c0mon", stdout, 0);
}

void a23_dualcore_sys_test_base::connect()
{
	svf_string en_trace_ic_s, en_trace_dis_s;
	bool en_trace_ic=false, en_trace_dis=false;
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);
	string D_ROOT(TB_ROOT + ".u_a23_sys");

	axi4_monitor_bfm_dpi_mgr::connect(TB_ROOT + ".u_c0mon", m_env->m_c0mon->bfm_port);

	timebase_dpi_mgr::connect(TB_ROOT + ".u_time", m_env->m_timebase->bfm_port);

	m_env->m_c0mon->ap.connect(m_c0mon_logger->api_export);
	m_c0mon_logger->set_timebase(m_env->m_timebase->bfm_port.consumes());

}

void a23_dualcore_sys_test_base::shutdown()
{

}

svf_test_ctor_def(a23_dualcore_sys_test_base)

