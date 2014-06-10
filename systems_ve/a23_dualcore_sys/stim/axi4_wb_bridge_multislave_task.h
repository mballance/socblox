/*
 * axi4_wb_bridge_multislave_task.h
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#ifndef AXI4_WB_BRIDGE_MULTISLAVE_TASK_H_
#define AXI4_WB_BRIDGE_MULTISLAVE_TASK_H_
#include "svf.h"
#include "svf_mem_if.h"
#include <vector>

class axi4_wb_bridge_multislave_task : public svf_task<svf_mem_if> {
	public:
		axi4_wb_bridge_multislave_task();

		virtual ~axi4_wb_bridge_multislave_task();

		virtual void body();

	public:
		vector<uint64_t>			addr_bases;
		uint32_t					addr_offset;
		bool						pass;
		bool						debug;
};

#endif /* AXI4_WB_BRIDGE_MULTISLAVE_TASK_H_ */
