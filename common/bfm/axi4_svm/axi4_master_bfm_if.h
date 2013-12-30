/*
 * axi4_master_bfm_if.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_IF_H_
#define AXI4_MASTER_BFM_IF_H_
#include "svm.h"

class axi4_master_bfm_target_if {

	public:

		virtual ~axi4_master_bfm_target_if() {}

		virtual void get_parameters(
				uint32_t				*AXI4_ADDRESS_WIDTH,
				uint32_t				*AXI4_DATA_WIDTH,
				uint32_t				*AXI4_ID_WIDTH) = 0;

		virtual void aw_valid(
				uint64_t				AWADDR,
				uint32_t				AWID,
				uint8_t					AWLEN,
				uint8_t					AWSIZE,
				uint8_t					AWBURST,
				uint8_t					AWCACHE,
				uint8_t					AWPROT,
				uint8_t					AWQOS,
				uint8_t					AWREGION) = 0;

		virtual void set_data(
				uint32_t				idx,
				uint32_t				data) = 0;

};

class axi4_master_bfm_host_if {

	public:

		virtual ~axi4_master_bfm_host_if() {}

		virtual void aw_ready() = 0;

		virtual void bresp(uint32_t resp) = 0;

};



#endif /* AXI4_MASTER_BFM_IF_H_ */
