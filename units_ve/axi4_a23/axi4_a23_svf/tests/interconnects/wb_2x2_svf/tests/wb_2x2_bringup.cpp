/*
 * wb_2x2_bringup.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_2x2_bringup.h"

wb_2x2_bringup::wb_2x2_bringup(const char *name) : wb_2x2_test_base(name) {
	// TODO Auto-generated constructor stub

}

wb_2x2_bringup::~wb_2x2_bringup() {
	// TODO Auto-generated destructor stub
}

void wb_2x2_bringup::start()
{
	m_run_thread.init(this, &wb_2x2_bringup::run);
	m_run_thread.start();
}

void wb_2x2_bringup::run()
{
	uint32_t tmp;

	raise_objection();

	fprintf(stdout, "--> WAIT RESET\n");
	m_env->m_m0->wait_for_reset();
	fprintf(stdout, "<-- WAIT RESET\n");

	for (uint32_t i=0; i<16; i++) {
		m_env->m_m0->write32(i*4, i+1);
		tmp = m_env->m_m0->read32(i*4);

		if (tmp != i+1) {
			fprintf(stdout, "FAIL: wb_2x2_bringup - expect 0x%08x receive 0x%08x\n",
					(i+1), tmp);
		}
	}

	fprintf(stdout, "PASS: wb_2x2_bringup\n");

	drop_objection();
}

svf_test_ctor_def(wb_2x2_bringup)
