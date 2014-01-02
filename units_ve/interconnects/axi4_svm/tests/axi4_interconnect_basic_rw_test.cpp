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
	m_m1_run_thread.init(this, &axi4_interconnect_basic_rw_test::run_m1);
	m_m1_run_thread.start();
	m_m2_run_thread.init(this, &axi4_interconnect_basic_rw_test::run_m2);
	m_m2_run_thread.start();
}

void axi4_interconnect_basic_rw_test::run_m1()
{
	uint8_t resp;
	uint32_t data[16];

	fprintf(stdout, "--> run_m1\n");
	raise_objection();

	fprintf(stdout, "--> wait_for_reset\n");
	m_env->m_m1_bfm->wait_for_reset();
	fprintf(stdout, "<-- wait_for_reset\n");

	for (uint32_t i=0; i<128; i++) {
		// swizzle slave
		uint32_t addr = (i&1) << 12;

		// offset address for M1
		addr |= (0 << 11);

		addr += i*4;

		data[0] = addr;
		fprintf(stdout, "M1: W/R 0x%08x\n", addr);
		m_env->m_m1_bfm->write(addr, AXI4_BURST_SIZE_32, 0, data, resp, AXI4_BURST_TYPE_FIXED);
		m_env->m_m1_bfm->read(addr, AXI4_BURST_SIZE_32, 0, data, resp, AXI4_BURST_TYPE_FIXED);

		if (data[0] != addr) {
			fprintf(stdout, "ERROR: mismatch from M1 @ addr 0x%08x: expect 0x%08x receive 0x%08x\n",
					addr, addr, data[0]);
		}
	}

	drop_objection();
	fprintf(stdout, "<-- run_m1\n");
}

void axi4_interconnect_basic_rw_test::run_m2()
{
	uint8_t resp;
	uint32_t data[16];

	fprintf(stdout, "--> run_m2\n");
	raise_objection();

	fprintf(stdout, "--> wait_for_reset\n");
	m_env->m_m2_bfm->wait_for_reset();
	fprintf(stdout, "<-- wait_for_reset\n");

	for (uint32_t i=0; i<128; i++) {
		// swizzle slave
		uint32_t addr = (i&1) << 12;

		// offset address for M2
		addr |= (1 << 11);

		addr += i*4;

		fprintf(stdout, "M2: W/R 0x%08x\n", addr);

		data[0] = addr;
		m_env->m_m2_bfm->write(addr, AXI4_BURST_SIZE_32, 0, data, resp, AXI4_BURST_TYPE_FIXED);
		m_env->m_m2_bfm->read(addr, AXI4_BURST_SIZE_32, 0, data, resp, AXI4_BURST_TYPE_FIXED);

		if (data[0] != addr) {
			fprintf(stdout, "ERROR: mismatch from M2 @ addr 0x%08x: expect 0x%08x receive 0x%08x\n",
					addr, addr, data[0]);
		}
	}


	drop_objection();
	fprintf(stdout, "<-- run_m2\n");
}

svm_test_ctor_def(axi4_interconnect_basic_rw_test)
