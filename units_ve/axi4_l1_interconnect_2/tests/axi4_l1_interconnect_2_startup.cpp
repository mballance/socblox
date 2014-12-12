/*
 * axi4_l1_interconnect_2_startup.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "axi4_l1_interconnect_2_startup.h"

axi4_l1_interconnect_2_startup::axi4_l1_interconnect_2_startup(const char *name) : axi4_l1_interconnect_2_test_base(name) {
	// TODO Auto-generated constructor stub

}

axi4_l1_interconnect_2_startup::~axi4_l1_interconnect_2_startup() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_interconnect_2_startup::build() {
	axi4_l1_interconnect_2_test_base::build();
}

void axi4_l1_interconnect_2_startup::connect() {
	axi4_l1_interconnect_2_test_base::connect();
}

void axi4_l1_interconnect_2_startup::start() {
	axi4_l1_interconnect_2_test_base::start();
	m_thread.init(this, &axi4_l1_interconnect_2_startup::main);
	m_thread.start();
}

void axi4_l1_interconnect_2_startup::main() {
	uint32_t addr[] = {
			0x00000000,
			0x00000004,
			0x00000008,
			0x00000060,
			0x00000064,
			0x00000068,
			0x00000188,
			0x00000068,
			0x0000006c,
			0x00000070,
			0x0000018c,
			0x00000070,
			0x00000074,
			0x00000190,
			0x00000074,
			0x00000078,
			0x0000007c,
			0x000002b4,
			0x000002b8,
			0x000002bc,
			0x2000a900,
			0x000002bc,
			0x000002c0,
			0x000002c4,
			0x000002c8,
			0x000002c8,
			0x000002cc,
			0x000002d0,
			0x000002d0,
			0x000002d4,
			0x000002d8,
			0x2000a900,
			0x000002d8,
			0x000002dc,
			0x00000078,
			0x0000007c,
			0x00000080,
			0x00000194,
			0x00000080,
			0x00000084,
			0xf1000004,
			0x00000084,
			0x00000088,
			0x0000008c,
			0x0000008c,
			0x00000090,
			0x00000094,
			0x00000198,
			0x00000094,
			0x00000098,
			0x0000019c,
			0x00000098,
			0x0000009c,
			0x000001a0,
			0x0000009c,
			0x000000a0,
			0x000000a4,
			0x00002390,
			0x000000a4,
			0x000000a8,
			0x20000040,
			0x000000a8,
			0x000000ac,
			0x00000098,
			0x0000009c,
			0x000000a0,
			0x000000a4,
			0x00002394,
			0x000000a4,
			0x000000a8,
			0x20000044,
			0x000000a8,
			0x000000ac,
			0x00000098,
			0x0000009c
	};
	uint32_t rw[] = {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			1,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			1,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			1,
			0,
			0,
			0,
			0
	};
	uint32_t cache[] = {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			0,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE,
			axi4_master_bfm::CACHE_CACHEABLE
	};


	raise_objection();

	for (uint32_t i=0; i<sizeof(addr)/sizeof(uint32_t); i++) {
		uint32_t addr_i = addr[i];
		uint32_t rw_i = rw[i];
		uint32_t cache_i = cache[i];

		fprintf(stdout, "Total Items: %d\n", sizeof(addr)/sizeof(uint32_t));

		fprintf(stdout, "--> %d %s 0x%08x cache=%d\n",
				i, (rw_i)?"WRITE":"READ", addr_i, (cache_i)?1:0);
		fflush(stdout);

		m_env->m_m0->set_cache(cache_i);

		if (rw_i) {
			m_env->m_m0->write32(addr_i, 0);
		} else {
			m_env->m_m0->read32(addr_i);
		}
		fprintf(stdout, "<-- %d %s 0x%08x cache=%d\n",
				i, (rw_i)?"WRITE":"READ", addr_i, (cache_i)?1:0);
		fflush(stdout);
	}

	fprintf(stdout, "--> drop_objection()\n");
	fflush(stdout);
	drop_objection();
	fprintf(stdout, "<-- drop_objection()\n");
	fflush(stdout);
}

svf_test_ctor_def(axi4_l1_interconnect_2_startup)

