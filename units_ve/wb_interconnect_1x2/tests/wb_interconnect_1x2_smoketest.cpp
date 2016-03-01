/*
 * wb_interconnect_1x2_smoketest.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "wb_interconnect_1x2_smoketest.h"

wb_interconnect_1x2_smoketest::wb_interconnect_1x2_smoketest(const char *name) : wb_interconnect_1x2_test_base(name) {
	// TODO Auto-generated constructor stub

}

wb_interconnect_1x2_smoketest::~wb_interconnect_1x2_smoketest() {
	// TODO Auto-generated destructor stub
}

void wb_interconnect_1x2_smoketest::build() {
	wb_interconnect_1x2_test_base::build();
}

void wb_interconnect_1x2_smoketest::connect() {
	wb_interconnect_1x2_test_base::connect();
}

void wb_interconnect_1x2_smoketest::start() {
	m_run.init(this, &wb_interconnect_1x2_smoketest::run);
	m_run.start();
}

void wb_interconnect_1x2_smoketest::run() {
	int errors=0;

	raise_objection();

	for (uint32_t i=0; i<16; i++) {
		m_env->bfm0->write32(4*i, 1+i);
	}

	for (uint32_t i=0; i<16; i++) {
		uint32_t data = m_env->bfm0->read32(4*i);

		if (data != i+1) {
			fprintf(stdout, "Error: 0x%08x - expect 0x%08x ; receive 0x%08x\n",
					4*i, i+1, data);
			errors++;
		}
	}

	if (errors) {
		fail("bad data");
	} else {
		pass();
	}
	drop_objection();
}

svf_test_ctor_def(wb_interconnect_1x2_smoketest)

