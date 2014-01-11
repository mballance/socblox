/*
 * wb_master_bfm_if.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef WB_MASTER_BFM_IF_H_
#define WB_MASTER_BFM_IF_H_
#include "svf.h"

class wb_master_bfm_target_if {

	public:

		virtual ~wb_master_bfm_target_if() {}

		virtual void get_parameters(
				uint32_t			*ADDRESS_WIDTH,
				uint32_t			*DATA_WIDTH) = 0;

		virtual void request(
				uint64_t			ADR,
				uint8_t				CTI,
				uint8_t				BTE,
				uint32_t			SEL,
				uint8_t				WE) = 0;

		virtual void set_data(
				uint32_t			idx,
				uint32_t			data) = 0;

		virtual void get_data(
				uint32_t			idx,
				uint32_t			*data) = 0;

};

class wb_master_bfm_host_if {

	public:

		virtual ~wb_master_bfm_host_if() {}

		virtual void acknowledge(
				uint8_t				ERR) = 0;

		virtual void reset() = 0;
};



#endif /* WB_MASTER_BFM_IF_H_ */
