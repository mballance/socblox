/*
 * axi4_l1_interconnect_2_traffic.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "axi4_l1_interconnect_2_traffic.h"

axi4_l1_interconnect_2_traffic::axi4_l1_interconnect_2_traffic(const char *name) : axi4_l1_interconnect_2_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_l1_interconnect_2_traffic::~axi4_l1_interconnect_2_traffic() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_interconnect_2_traffic::build() {
	axi4_l1_interconnect_2_test_base::build();
}

void axi4_l1_interconnect_2_traffic::connect() {
	axi4_l1_interconnect_2_test_base::connect();
}

void axi4_l1_interconnect_2_traffic::start() {
	axi4_l1_interconnect_2_test_base::start();

	m_main_thread.init(this, &axi4_l1_interconnect_2_traffic::main);
	m_main_thread.start();
}

void axi4_l1_interconnect_2_traffic::main() {
	uint32_t data;
	raise_objection();

	m_env->m_m0->wait_for_reset();

	// First, initialize the memory
//	for (uint32_t i=0; i<128; i++) {
//		m_env->m_sram->write32(4*i, 0x55000000+i+1);
//	}

	m_env->m_m0->set_cache(axi4_master_bfm::CACHE_CACHEABLE);
	m_env->m_m1->set_cache(axi4_master_bfm::CACHE_CACHEABLE);

	// Read lines 0-15 in from master0
	// Use a different hit address each time
	fprintf(stdout, "==> m0 read\n");
	for (uint32_t i=0; i<16; i++) {
		uint32_t exp_data = 0x55000000 + 1 + 4*i + i;
		uint32_t word = i + 4*i;

		data = m_env->m_m0->read32(4*word);

		if (exp_data != data) {
			fprintf(stdout, "Error: 0x%08x - expect 0x%08x receive 0x%08x\n", 4*word, exp_data, data);
		}
	}
	fprintf(stdout, "<== m0 read\n");

	// Now, check write-through operation
	fprintf(stdout, "==> Write-through\n");
	for (uint32_t i=0; i<4; i++) {
		uint32_t exp_data = ~(0x55000000 + 1 + 4*i + i);
		uint32_t word = (3-i) + 4*i;

		m_env->m_m0->write32(4*word, exp_data);

		// Double-check that the data made it to the ram
//		data = m_env->m_sram->read32(4*word);
		if (exp_data != data) {
			fprintf(stdout, "Error: 0x%08x - expect ram data 0x%08x receive 0x%08x\n", 4*word, exp_data, data);
		}

		data = m_env->m_m0->read32(4*word);

		if (exp_data != data) {
			fprintf(stdout, "Error: 0x%08x - expect m0 data 0x%08x receive 0x%08x\n", 4*word, exp_data, data);
		}
	}
	fprintf(stdout, "<== Write-through\n");

	// Now, check write-invalidate operation
	fprintf(stdout, "==> Write-invalidate\n");
	for (uint32_t i=3; i<8; i++) {
		uint32_t exp_data = ~(0x55000000 + 2 + 4*i + i);
		uint32_t word = ((3-i)%4) + 4*i;

		m_env->m_m1->write32(4*word, exp_data);

		// Double-check that the data made it to the ram
//		data = m_env->m_sram->read32(4*word);
		if (exp_data != data) {
			fprintf(stdout, "Error: 0x%08x - expect ram data 0x%08x receive 0x%08x\n", 4*word, exp_data, data);
		}

		data = m_env->m_m0->read32(4*word);

		if (exp_data != data) {
			fprintf(stdout, "Error: 0x%08x - expect 0x%08x receive 0x%08x\n", 4*word, exp_data, data);
		}

		// Try to produce an in-flight invalidate
		m_env->m_m1->write32(4*word, ~exp_data);
	}
	fprintf(stdout, "<== Write-invalidate\n");
	drop_objection();
}

svf_test_ctor_def(axi4_l1_interconnect_2_traffic)

