/*
 * axi4_a23_svm_coretest.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "axi4_a23_svm_coretest.h"
#include "svm_elf_loader.h"
#include "a23_tracer_dpi_mgr.h"

axi4_a23_svm_coretest::axi4_a23_svm_coretest(const char *name) :
	axi4_a23_svm_test_base(name), tracer_port(this) {
	// TODO Auto-generated constructor stub

}

axi4_a23_svm_coretest::~axi4_a23_svm_coretest() {
	// TODO Auto-generated destructor stub
}

void axi4_a23_svm_coretest::build()
{
	axi4_a23_svm_test_base::build();
}

void axi4_a23_svm_coretest::connect()
{
	axi4_a23_svm_test_base::connect();

	m_env->m_tracer->port.connect(tracer_port);
}

void axi4_a23_svm_coretest::start()
{
	m_run_thread.init(this, &axi4_a23_svm_coretest::run);
	m_run_thread.start();
}

void axi4_a23_svm_coretest::run()
{
	string target_exe;
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	svm_elf_loader loader(m_env->m_s0_bfm);

	int ret = loader.load(target_exe.c_str());

	// TODO: Wait on scoreboard
	fprintf(stdout, "--> end_sem.get()\n");
	m_end_sem.get();
	fprintf(stdout, "<-- end_sem.get()\n");
	fprintf(stdout, "Reached end\n");
	drop_objection();
}

void axi4_a23_svm_coretest::mem_access(
		uint32_t			addr,
		bool				is_write,
		uint32_t			data)
{
	fprintf(stdout, "CoreTest: mem_access 0x%08x\n", addr);
	if (addr == 0xF0000000) {
		fprintf(stdout, "--> end_sem.put()\n");
		m_end_sem.put();
		fprintf(stdout, "<-- end_sem.put()\n");
	}
}

void axi4_a23_svm_coretest::execute(
		uint32_t			addr,
		uint32_t			op)
{
	fprintf(stdout, "CoreTest: execute 0x%08x\n", addr);
}

svm_test_ctor_def(axi4_a23_svm_coretest)

