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

	// First, initialize the memory
//	for (uint32_t i=0; i<1024; i++) {
//		m_env->m_sram->write32(4*i, 0x55000000 + i);
//	}

	m_main_m0.init(this, &axi4_l1_interconnect_2_cacheable_smoke::main_m0);
	m_main_m0.start();
	m_main_m1.init(this, &axi4_l1_interconnect_2_cacheable_smoke::main_m1);
//	m_main_m1.start();
}

void axi4_l1_interconnect_2_cacheable_smoke::main_m0() {
	uint32_t data;
	raise_objection();

	// Uncacheable read
	data = m_env->m_m0->read32(0);
	fprintf(stdout, "uncached data=0x%08x\n", data);
	fflush(stdout);
//	fprintf(stdout, "uncached data=0x%08x\n", data);

	// Uncacheable write
//	m_env->m_m0->write32(0, 0x55000055);

	// First, perform a cacheable read
	m_env->m_m0->set_cache(axi4_master_bfm::CACHE_CACHEABLE);

	m_env->m_m0->read32(0);
	fprintf(stdout, "cached data=0x%08x\n", data);
	fflush(stdout);

	// Modify read-back data
	fprintf(stdout, "--> write32\n"); fflush(stdout);
	m_env->m_m0->write32(4, 0x55AAEEFF);
	fprintf(stdout, "<-- write32\n"); fflush(stdout);

//	data = m_env->m_sram->read32(4);
//	fprintf(stdout, "4 direct read-back: 0x%08x\n", data);
//	fflush(stdout);

	// Now, invalidate that line from the other master
//	m_env->m_m1->write32(8, 0x55AAEEF1);
//	data = m_env->m_sram->read32(8);
//	fprintf(stdout, "8 direct read-back: 0x%08x\n", data); fflush(stdout);

	data = m_env->m_m0->read32(8);
	fprintf(stdout, "8 readback: 0x%08x\n", data); fflush(stdout);

	data = m_env->m_m0->read32(4);
	fprintf(stdout, "4 readback: 0x%08x\n", data); fflush(stdout);

	// read-back to ensure the correct data is read
	data = m_env->m_m0->read32(0);
	fprintf(stdout, "cache data=0x%08x\n", data); fflush(stdout);

	drop_objection();
	return;

	for (uint32_t j=0; j<16; j++) {
		for (uint32_t i=0; i<4; i++) {
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
			uint32_t data = m_env->m_m0->read32(16+4*i);

			fprintf(stdout, "m0 0x%08x: 0x%08x\n", 16+4*i, data);
//			m_env->m_m0->wait_clks(1);

			if (data != (0x55000000+i+4)) {
				fprintf(stdout, "Error: m0 - expected 0x%08x; received 0x%08x\n",
						(0x55000000+i+4), data);
			}
		}
	}

	drop_objection();
	fprintf(stdout, "<-- main\n");
	fflush(stdout);
}

void axi4_l1_interconnect_2_cacheable_smoke::main_m1() {
	raise_objection();

	for (uint32_t j=0; j<16; j++) {
		for (uint32_t i=0; i<4; i++) {
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
			m_env->m_m1->set_cache(axi4_master_bfm::CACHE_CACHEABLE);
			uint32_t data = m_env->m_m1->read32(16+4*i);

			fprintf(stdout, "m1 0x%08x: 0x%08x\n", 16+4*i, data);
//			m_env->m_m1->wait_clks(1);

			if (data != (0x55000000+i+4)) {
				fprintf(stdout, "Error: m1 - expected 0x%08x; received 0x%08x\n",
						(0x55000000+i+4), data);
			}
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

