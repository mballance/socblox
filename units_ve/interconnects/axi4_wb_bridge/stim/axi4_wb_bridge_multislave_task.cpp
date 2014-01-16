/*
 * axi4_wb_bridge_multislave_task.cpp
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_multislave_task.h"

axi4_wb_bridge_multislave_task::axi4_wb_bridge_multislave_task() {
	// TODO Auto-generated constructor stub

}

axi4_wb_bridge_multislave_task::~axi4_wb_bridge_multislave_task() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_multislave_task::body()
{
	fprintf(stdout, "--> body()\n");
	for (uint32_t i=0; i<64; i++) {
		api()->write32(0x2000 + 4*i, i+1);
	}
	fprintf(stdout, "<-- body()\n");
}

