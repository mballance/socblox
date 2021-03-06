/*
 * axi4_a23_svf_coretest.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "axi4_a23_svf_coretest.h"
#include "svf_elf_loader.h"

axi4_a23_svf_coretest::axi4_a23_svf_coretest(const char *name) :
	axi4_a23_svf_test_base(name), tracer_port(this) {
	m_instr_timeout = 100000;
	m_instr_count = 0;

}

axi4_a23_svf_coretest::~axi4_a23_svf_coretest() {
	// TODO Auto-generated destructor stub
}

void axi4_a23_svf_coretest::build()
{
	fprintf(stdout, "--> coretest::build\n");
	fflush(stdout);
	axi4_a23_svf_test_base::build();
	fprintf(stdout, "<-- coretest::build\n");
	fflush(stdout);
}

void axi4_a23_svf_coretest::connect()
{
	axi4_a23_svf_test_base::connect();

	m_env->m_tracer->port.connect(tracer_port);
}

void axi4_a23_svf_coretest::start()
{
	m_run_thread.init(this, &axi4_a23_svf_coretest::run);
	m_run_thread.start();
}

void axi4_a23_svf_coretest::run()
{
	svf_string target_exe;
	svf_string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	cmdline().valueplusarg("TESTNAME=", testname);

	svf_elf_loader loader(m_env->m_s0_bfm);

	int ret = loader.load(target_exe.c_str());

	// TODO: Wait on scoreboard
	m_end_sem.get();
	fprintf(stdout, "Reached end\n");

	if (m_test_status == 0x11) {
		fprintf(stdout, "PASS: %s\n", testname.c_str());
	} else {
		fprintf(stdout, "FAIL: %s 0x%08x\n", testname.c_str(), m_test_status);
	}
	drop_objection();
}

void axi4_a23_svf_coretest::mem_access(
		uint32_t			addr,
		bool				is_write,
		uint32_t			data)
{
	fprintf(stdout, "CoreTest: mem_access %s 0x%08x = 0x%08x\n",
			(is_write)?"Write":"Read", addr, data);
	if (addr == 0xF0000000) {
		fprintf(stdout, "Test Status: %d\n", data);
		fprintf(stdout, "--> end_sem.put()\n");
		m_test_status = data;
		m_end_sem.put();
		fprintf(stdout, "<-- end_sem.put()\n");
	}
}

void axi4_a23_svf_coretest::execute(
		uint32_t			addr,
		uint32_t			op)
{
	uint32_t mem_op = m_env->m_s0_bfm->read32(addr);
	fprintf(stdout, "CoreTest: execute 0x%08x 0x%08x\n", addr, op);
	m_instr_count++;

	if (mem_op != op) {
		fprintf(stdout, "CoreTest ERROR: opcode in memory is 0x%08x\n", mem_op);
		m_end_sem.put();
	}

	if (m_instr_count > m_instr_timeout) {
		fprintf(stdout, "CoreTest ERROR: timeout - %d instructions executed\n", m_instr_count);
		m_end_sem.put();
	}
}

void axi4_a23_svf_coretest::regchange(
		uint32_t			reg,
		uint32_t			val)
{
	fprintf(stdout, "CoreTest: regchange R%d 0x%08x\n", reg, val);
}

svf_test_ctor_def(axi4_a23_svf_coretest)

