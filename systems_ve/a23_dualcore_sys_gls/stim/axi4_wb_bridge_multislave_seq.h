/*
 * axi4_wb_bridge_multislave_seq.h
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#ifndef AXI4_WB_BRIDGE_MULTISLAVE_SEQ_H_
#define AXI4_WB_BRIDGE_MULTISLAVE_SEQ_H_
#include "svf.h"
#include "svf_mem_if.h"
#include <vector>

using std::vector;

class axi4_wb_bridge_multislave_seq : public svf_closure_base {

	public:
		axi4_wb_bridge_multislave_seq(svf_mem_if *master_if);

		virtual ~axi4_wb_bridge_multislave_seq();

		virtual void run();

	private:
		uint32_t						m_count;
		svf_mem_if						*m_mem_if;
		vector<uint64_t>				m_base_addrs;
		uint32_t						m_master_offset;
		bool							m_pass;

};

#endif /* AXI4_WB_BRIDGE_MULTISLAVE_SEQ_H_ */
