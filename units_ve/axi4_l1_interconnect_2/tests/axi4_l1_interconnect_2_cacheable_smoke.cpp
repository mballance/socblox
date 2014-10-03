/*
 * axi4_l1_interconnect_2_cacheable_smoke.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "axi4_l1_interconnect_2_cacheable_smoke.h"

axi4_l1_interconnect_2_cacheable_smoke::axi4_l1_interconnect_2_cacheable_smoke(const char *name) : axi4_l1_interconnect_2_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_l1_interconnect_2_cacheable_smoke::~axi4_l1_interconnect_2_cacheable_smoke() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_interconnect_2_cacheable_smoke::build() {
	axi4_l1_interconnect_2_test_base::build();
}

void axi4_l1_interconnect_2_cacheable_smoke::connect() {
	axi4_l1_interconnect_2_test_base::connect();
}

void axi4_l1_interconnect_2_cacheable_smoke::start() {
	axi4_l1_interconnect_2_test_base::start();

	m_env->m_m0->wait_for_reset();

	m_main_m0.init(this, &axi4_l1_interconnect_2_cacheable_smoke::main_m0);
	m_main_m0.start();
	m_main_m1.init(this, &axi4_l1_interconnect_2_cacheable_smoke::main_m1);
//	m_main_m1.start();
}

void axi4_l1_interconnect_2_cacheable_smoke::main_m0() {
	raise_objection();
	for (uint32_t i=0; i<16; i++) {
		/*
		int wait_clks = (rand() % 10);
		m_env->m_m0->wait_clks(wait_clks);

		int do_read = (rand() % 1);

		m_env->m_m0->set_cache(axi4_master_bfm::CACHE_CACHEABLE);

		if (do_read) {
			m_env->m_m0->read32(16+4*i);
		} else {
			m_env->m_m0->write32(16+4*i, 16+i);
		}
		 */
		m_env->m_m0->set_cache(axi4_master_bfm::CACHE_CACHEABLE);
		m_env->m_m0->read32(16+4*i);
	}

	drop_objection();
	fprintf(stdout, "<-- main\n");
	fflush(stdout);
}

void axi4_l1_interconnect_2_cacheable_smoke::main_m1() {
	raise_objection();
	for (uint32_t i=0; i<16; i++) {
		int wait_clks = (rand() % 10);
		m_env->m_m1->wait_clks(wait_clks);

		int do_read = (rand() % 1);

		m_env->m_m1->set_cache(axi4_master_bfm::CACHE_CACHEABLE);

		if (do_read) {
			m_env->m_m1->read32(4*i);
		} else {
			m_env->m_m1->write32(4*i, i);
		}
	}

	drop_objection();
	fprintf(stdout, "<-- main\n");
	fflush(stdout);
}

void axi4_l1_interconnect_2_cacheable_smoke::shutdown()
{
	fprintf(stdout, "PASS: axi4_l1_interconnect_2_cacheable_smoke\n");
}

svf_test_ctor_def(axi4_l1_interconnect_2_cacheable_smoke)

