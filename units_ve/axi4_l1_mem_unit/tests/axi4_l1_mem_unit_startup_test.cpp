/*
 * axi4_l1_mem_unit_startup_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "axi4_l1_mem_unit_startup_test.h"

axi4_l1_mem_unit_startup_test::axi4_l1_mem_unit_startup_test(const char *name) : axi4_l1_mem_unit_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_l1_mem_unit_startup_test::~axi4_l1_mem_unit_startup_test() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_mem_unit_startup_test::build() {
	axi4_l1_mem_unit_test_base::build();
}

void axi4_l1_mem_unit_startup_test::connect() {
	axi4_l1_mem_unit_test_base::connect();
}

void axi4_l1_mem_unit_startup_test::start() {
	m_thread.init(this, &axi4_l1_mem_unit_startup_test::run);
	m_thread.start();
}

void axi4_l1_mem_unit_startup_test::run() {
	raise_objection();

	m_env->m_m0->wait_for_reset();

	m_env->m_m0->set_cache(0);
	for (uint32_t i=0; i<16; i++) {
		m_env->m_m0->write32(4*i, i+1);
	}

	m_env->m_m0->set_cache(axi4_master_bfm::CACHE_CACHEABLE);
	uint32_t data = m_env->m_m0->read32(4*0); // read the first word
	fprintf(stdout, "READ: 0x%08x 0x%08x\n", 4*0, data);
	m_env->m_m0->write32(4*0, 0+2); // overlapping write
	data = m_env->m_m0->read32(4*1); // read the first word
	fprintf(stdout, "READ: 0x%08x 0x%08x\n", 4*1, data);

	drop_objection();
}

svf_test_ctor_def(axi4_l1_mem_unit_startup_test)

