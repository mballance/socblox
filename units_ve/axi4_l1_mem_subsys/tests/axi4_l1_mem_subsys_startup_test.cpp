/*
 * axi4_l1_mem_subsys_startup_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "axi4_l1_mem_subsys_startup_test.h"

axi4_l1_mem_subsys_startup_test::axi4_l1_mem_subsys_startup_test(const char *name) : axi4_l1_mem_subsys_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_l1_mem_subsys_startup_test::~axi4_l1_mem_subsys_startup_test() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_mem_subsys_startup_test::build() {
	axi4_l1_mem_subsys_test_base::build();
}

void axi4_l1_mem_subsys_startup_test::connect() {
	axi4_l1_mem_subsys_test_base::connect();
}

void axi4_l1_mem_subsys_startup_test::start() {
	raise_objection();
	m_env->m_m0->wait_for_reset();

	m_env->m_m0->wait_clks(4);

	m_m0_thread.init(this, &axi4_l1_mem_subsys_startup_test::m0_thread);
	m_m0_thread.start();

	drop_objection();
}

void axi4_l1_mem_subsys_startup_test::m0_thread() {
	raise_objection();

	bool      rnw;
	uint32_t  target;
	uint32_t  cache;
	uint32_t  addr;
	uint32_t  data;
	uint32_t  delay;

	for (uint32_t i=0; i<1000; i++) {
		rnw = (rand() & 1);
//		rnw = 0;
		target = (rand() % 3);
//		cache = (rand() & 1);
		cache = 1;
//		cache = 0;

//		addr = (target == 0)?(0x00000000 + (rand() & 0xFFFC)):
//				(target == 1)?(0x00020000 + (rand() & 0xFFFC)):
//				(0x000F0000 + (rand() & 0xFFFC));
//		addr = (target == 0)?0x00000000:(target == 1)?0x00020000:0x000F0000;
		addr = 0x00000000;

		data = (rand() & 0xFFFF);

		delay = (rand() % 5);

		fprintf(stdout, "--> %s 0x%08x cache=%d data=0x%08x\n",
				(rnw)?"WRITE":"READ", addr, cache, data);
		m_env->m_m0->set_cache((cache)?axi4_master_bfm::CACHE_CACHEABLE:0);
		if (rnw) {
			m_env->m_m0->write32(addr, data);
		} else {
			data = m_env->m_m0->read32(addr);
		}
		fprintf(stdout, "<-- %s 0x%08x cache=%d data=0x%08x\n",
				(rnw)?"WRITE":"READ", addr, cache, data);

		m_env->m_m0->wait_clks(delay);
	}

	drop_objection();
}

svf_test_ctor_def(axi4_l1_mem_subsys_startup_test)

