/*
 * wb_2x2_multimaster.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_2x2_multimaster.h"

wb_2x2_multimaster::wb_2x2_multimaster(const char *name) : wb_2x2_test_base(name) {
	// TODO Auto-generated constructor stub

}

wb_2x2_multimaster::~wb_2x2_multimaster() {
	// TODO Auto-generated destructor stub
}

void wb_2x2_multimaster::start()
{
	m0_thread.init(this, &wb_2x2_multimaster::run_m0);
	m1_thread.init(this, &wb_2x2_multimaster::run_m1);

	m0_thread.start();
	m1_thread.start();
}

void wb_2x2_multimaster::run_m0()
{
	uint32_t data;
	raise_objection();
	fprintf(stdout, "--> run_m0\n");

	m_env->m_m0->wait_for_reset();

	for (uint32_t i=0; i<64; i++) {
		uint32_t addr = ((i&1) << 12); // alternate slaves
		addr |= 0x800; // m0 range
		addr += 4*i;

		fprintf(stdout, "--> m0: write32(0x%08x 0x%08x)\n", addr, 0x00000000+i+1);
		m_env->m_m0->write32(addr, 0x00000000+i+1);
		fprintf(stdout, "<-- m0: write32(0x%08x 0x%08x)\n", addr, 0x00000000+i+1);
	}

	for (uint32_t i=0; i<64; i++) {
		uint32_t addr = ((i&1) << 12); // alternate slaves
		addr |= 0x800; // m0 range
		addr += 4*i;

		data = m_env->m_m0->read32(addr);
		if (data != 0x00000000+i+1) {
			fprintf(stdout, "FAIL: wb_2x2_multimaster - m0 expect 0x%08x receive 0x%08x\n",
				(0x00000000+i+1), data);
			drop_objection();
			return;
		}
	}

	fprintf(stdout, "PASS: wb_2x2_multimaster\n");
	fprintf(stdout, "<-- run_m0\n");
	drop_objection();
}

void wb_2x2_multimaster::run_m1()
{
	uint32_t data;
	raise_objection();

	fprintf(stdout, "--> run_m1\n");
	m_env->m_m1->wait_for_reset();

	for (uint32_t i=0; i<64; i++) {
		uint32_t addr = ((i&1) << 12); // alternate slaves
		addr |= 0x000; // m1 range
		addr += 4*i;

		fprintf(stdout, "--> m1: write32(0x%08x 0x%08x)\n", addr, 0x80000000+i+1);
		m_env->m_m1->write32(addr, 0x80000000+i+1);
		fprintf(stdout, "<-- m1: write32(0x%08x 0x%08x)\n", addr, 0x80000000+i+1);
	}

	for (uint32_t i=0; i<64; i++) {
		uint32_t addr = ((i&1) << 12); // alternate slaves
		addr |= 0x000; // m1 range
		addr += 4*i;

		data = m_env->m_m1->read32(addr);
		if (data != 0x80000000+i+1) {
			fprintf(stdout, "FAIL: wb_2x2_multimaster - m1 expect 0x%08x receive 0x%08x\n",
				(0x80000000+i+1), data);
			drop_objection();
			return;
		}
	}

	fprintf(stdout, "PASS: wb_2x2_multimaster\n");
	fprintf(stdout, "<-- run_m1\n");
	drop_objection();
}

svf_test_ctor_def(wb_2x2_multimaster)

