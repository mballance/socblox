/*
 * a23_unicore_sys_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_unicore_sys_test_base.h"
#include "svf_elf_loader.h"

a23_unicore_sys_test_base::a23_unicore_sys_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

a23_unicore_sys_test_base::~a23_unicore_sys_test_base() {
	// TODO Auto-generated destructor stub
}

void a23_unicore_sys_test_base::build()
{
	m_env = a23_unicore_sys_env::type_id.create("m_env", this);
}

void a23_unicore_sys_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	axi4_svf_rom_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.boot_rom", m_env->m_bootrom->port);
	axi4_svf_sram_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.ram", m_env->m_ram->port);

	uart_bfm_dpi_mgr::connect(TB_ROOT + ".u_uart_bfm", m_env->m_uart->bfm_port);

	a23_tracer_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.a23_subsys_0.u_a23_0.u_tracer.u_svf_tracer",
			m_env->m_core1_tracer->port);
	a23_tracer_dpi_mgr::connect(TB_ROOT + ".u_a23_sys.a23_subsys_0.u_a23_1.u_tracer.u_svf_tracer",
			m_env->m_core2_tracer->port);
}

void a23_unicore_sys_test_base::start()
{
	m_runthread.init(this, &a23_unicore_sys_test_base::run);
	m_runthread.start();
}

void a23_unicore_sys_test_base::run()
{
	string target_exe;
	string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	cmdline().valueplusarg("TESTNAME=", testname);

	svf_elf_loader loader(m_env->m_bootrom);

	int ret = loader.load(target_exe.c_str());
}

void a23_unicore_sys_test_base::shutdown()
{

}

svf_test_ctor_def(a23_unicore_sys_test_base)

