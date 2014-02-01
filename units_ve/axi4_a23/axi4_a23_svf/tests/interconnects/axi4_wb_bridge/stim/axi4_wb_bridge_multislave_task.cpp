/*
 * axi4_wb_bridge_multislave_task.cpp
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_multislave_task.h"

axi4_wb_bridge_multislave_task::axi4_wb_bridge_multislave_task() {
	// TODO Auto-generated constructor stub
	addr_offset = 0x0;
	pass = false;
}

axi4_wb_bridge_multislave_task::~axi4_wb_bridge_multislave_task() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_multislave_task::body()
{
	fprintf(stdout, "--> body()\n");

	for (uint32_t i=0; i<addr_bases.size(); i++) {
		uint64_t addr_base = addr_bases.at(i);
		for (uint32_t j=0; j<64; j++) {
			uint64_t addr = addr_base + addr_offset + 4*j;
			fprintf(stdout, "master 0x%08x: Access 0x%08x\n", addr_offset, (uint32_t)addr);
			api()->write32(addr, addr_offset+j+1);
			uint32_t data = api()->read32(addr);
			if (data != addr_offset+j+1) {
				fprintf(stdout, "ERROR[1]: master 0x%08x: Expect 0x%08x @ 0x%08x ; receive 0x%08x\n",
						addr_offset, addr_offset+j+1, (uint32_t)addr, data);
				return;
			}
		}
	}

	for (uint32_t i=0; i<addr_bases.size(); i++) {
		uint64_t addr_base = addr_bases.at(i);
		for (uint32_t j=0; j<64; j++) {
			uint64_t addr = addr_base + addr_offset + 4*j;
			api()->write32(addr, addr_offset+j+2);
			uint32_t data = api()->read32(addr);
			if (data != addr_offset+j+2) {
				fprintf(stdout, "ERROR[2]: master 0x%08x: Expect 0x%08x @ 0x%08x ; receive 0x%08x\n",
						addr_offset, addr_offset+j+1, (uint32_t)addr, data);
				return;
			}
		}
	}

	for (uint32_t i=0; i<addr_bases.size(); i++) {
		uint64_t addr_base = addr_bases.at(i);
		for (uint32_t j=0; j<64; j++) {
			uint64_t addr = addr_base + addr_offset + 4*j;
			uint32_t data = api()->read32(addr);
			if (data != addr_offset+j+2) {
				fprintf(stdout, "ERROR[3]: master 0x%08x: Expect 0x%08x @ 0x%08x ; receive 0x%08x\n",
						addr_offset, addr_offset+j+1, (uint32_t)addr, data);
				return;
			}
		}
	}

	fprintf(stdout, "<-- body()\n");
	pass = true;
}

