/*
 * axi4_wb_bridge_bringup_test.cpp
 *
 *  Created on: Jan 13, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_bringup_test.h"

axi4_wb_bridge_bringup_test::axi4_wb_bridge_bringup_test(const char *name) : axi4_wb_bridge_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_wb_bridge_bringup_test::~axi4_wb_bridge_bringup_test() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_bringup_test::start()
{
	fprintf(stdout, "start()\n");
	m_m0_thread.init(this, &axi4_wb_bridge_bringup_test::run_m0);
	m_m0_thread.start();
}

void axi4_wb_bridge_bringup_test::run_m0()
{
	uint64_t addr;
	uint32_t data;
	raise_objection();

	for (uint32_t i=0; i<64; i++) {
		addr = 0x00002000; // s1
		addr += i*4;

		m_env->m_m0->write32(addr, i+1);
	}

	for (uint32_t i=0; i<64; i++) {
		addr = 0x00002000; // s1
		addr += i*4;

		data = m_env->m_m0->read32(addr);

		fprintf(stdout, "data=0x%08x\n", data);
		if (data != (i+1)) {
			fprintf(stdout, "ERROR: read=0x%08x expect=0x%08x\n",
					data, (i+1));
		}
	}

	drop_objection();
}

svf_test_ctor_def(axi4_wb_bridge_bringup_test)
