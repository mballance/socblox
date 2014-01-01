/*
 * axi4_interconnect_basic_rw_test.cpp
 *
 *  Created on: Dec 15, 2013
 *      Author: ballance
 */

#include "axi4_interconnect_basic_rw_test.h"

axi4_interconnect_basic_rw_test::axi4_interconnect_basic_rw_test(const char *name) :
	axi4_interconnect_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_interconnect_basic_rw_test::~axi4_interconnect_basic_rw_test() {
	// TODO Auto-generated destructor stub
}

void axi4_interconnect_basic_rw_test::start()
{
	m_run_thread.init(this, &axi4_interconnect_basic_rw_test::run);
	m_run_thread.start();
}

void axi4_interconnect_basic_rw_test::run()
{
	uint8_t resp;
	uint32_t data[16];
	raise_objection();

	fprintf(stdout, "--> wait_for_reset\n");
	m_env->m_m1_bfm->wait_for_reset();
	fprintf(stdout, "<-- wait_for_reset\n");

	for (uint32_t addr=0x80000000; addr<0x80000010; addr += 4) {
		data[0] = addr;
		m_env->m_m1_bfm->write(addr, AXI4_BURST_SIZE_32, 0, data, resp, AXI4_BURST_TYPE_FIXED);
	}

	for (uint32_t addr=0x80000000; addr<0x80000010; addr += 4) {
		m_env->m_m1_bfm->read(addr, AXI4_BURST_SIZE_32, 0, data, resp, AXI4_BURST_TYPE_FIXED);

		fprintf(stdout, "data=0x%08x\n", data[0]);
	}

	drop_objection();
}

svm_test_ctor_def(axi4_interconnect_basic_rw_test)
