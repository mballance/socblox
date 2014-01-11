/*
 * wb_master_bfm_dpi_mgr.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef WB_MASTER_BFM_DPI_MGR_H_
#define WB_MASTER_BFM_DPI_MGR_H_
#include "svf.h"
#include "svf_dpi.h"
#include "wb_master_bfm_if.h"

class wb_master_bfm_dpi_closure : public svf_dpi_closure<wb_master_bfm_host_if, wb_master_bfm_target_if> {
	public:

		wb_master_bfm_dpi_closure(const string &target);

		virtual ~wb_master_bfm_dpi_closure() {}

		virtual void get_parameters(
				uint32_t			*ADDRESS_WIDTH,
				uint32_t			*DATA_WIDTH);

		virtual void request(
				uint64_t			ADR,
				uint8_t				CTI,
				uint8_t				BTE,
				uint32_t			SEL,
				uint8_t				WE);

		virtual void set_data(
				uint32_t			idx,
				uint32_t			data);

		virtual void get_data(
				uint32_t			idx,
				uint32_t			*data);
};

class wb_master_bfm_dpi_mgr : public svf_dpi_mgr<wb_master_bfm_dpi_closure> {
	public:
		wb_master_bfm_dpi_mgr();

};

#endif /* WB_MASTER_BFM_DPI_MGR_H_ */
