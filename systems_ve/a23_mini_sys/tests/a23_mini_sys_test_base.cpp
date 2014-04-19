/*
 * a23_mini_sys_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_mini_sys_test_base.h"
#include "svf_elf_loader.h"

a23_mini_sys_test_base::a23_mini_sys_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

a23_mini_sys_test_base::~a23_mini_sys_test_base() {
	// TODO Auto-generated destructor stub
}

void a23_mini_sys_test_base::build()
{
	m_env = a23_mini_sys_env::type_id.create("m_env", this);

	m_trace_fp = fopen("trace.dis", "w");
	m_disasm_tracer = new a23_disasm_tracer(m_trace_fp);
}

void a23_mini_sys_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	generic_rom_dpi_mgr::connect(TB_ROOT + ".u_mini_sys.u_rom.u_rom", m_env->m_rom_bfm->bfm_port);
	generic_sram_byte_en_dpi_mgr::connect(TB_ROOT + ".u_mini_sys.u_ram.ram", m_env->m_sram_bfm->bfm_port);

	a23_tracer_bfm_dpi_mgr::connect(TB_ROOT + ".u_mini_sys.u_a23.u_tracer.u_tracer_bfm", m_env->m_a23_tracer->bfm_port);

	m_env->m_a23_tracer->port.connect(m_disasm_tracer->port);

	// TODO: connect BFMs
}

void a23_mini_sys_test_base::start()
{
	m_runthread.init(this, &a23_mini_sys_test_base::run);
	m_runthread.start();
}

void a23_mini_sys_test_base::run()
{
	string target_exe;
	string testname = "unknown";
	fprintf(stdout, "run thread\n");
	fprintf(stdout, "--> raise_objection()\n");
	raise_objection();
	fprintf(stdout, "<-- raise_objection()\n");

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
		fprintf(stdout, "FATAL: no TARGET_EXE specified\n");
	} else {
		fprintf(stdout, "NOTE: Loading %s\n", target_exe.c_str());
		svf_elf_loader loader(m_env->m_mem_mgr);
		loader.load(target_exe.c_str());
	}

	cmdline().valueplusarg("TESTNAME=", testname);

}

void a23_mini_sys_test_base::shutdown()
{
	fclose(m_trace_fp);
}

svf_test_ctor_def(a23_mini_sys_test_base)

