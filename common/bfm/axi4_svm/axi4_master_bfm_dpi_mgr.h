/*
 * axi4_master_bfm_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_DPI_MGR_H_
#define AXI4_MASTER_BFM_DPI_MGR_H_
#include "svm.h"
#include "svm_dpi.h"
#include "axi4_master_bfm_if.h"

class axi4_master_bfm_dpi_mgr;

class axi4_master_bfm_dpi_closure : public svm_dpi_closure<axi4_master_bfm_host_if, axi4_master_bfm_target_if> {

	public:

		axi4_master_bfm_dpi_closure(const string &target);

		virtual ~axi4_master_bfm_dpi_closure() {}

		void aw_valid(
				uint64_t			AWADDR,
				uint32_t			AWID,
				uint8_t				AWLEN,
				uint8_t				AWSIZE,
				uint8_t				AWBURST,
				uint8_t				AWCACHE,
				uint8_t				AWPROT,
				uint8_t				AWQOS,
				uint8_t				AWREGION);

		void get_parameters(
				uint32_t			*ADDRESS_WIDTH,
				uint32_t			*DATA_WIDTH,
				uint32_t			*ID_WIDTH);

		void set_data(
				uint32_t			idx,
				uint32_t			data);
};

class axi4_master_bfm_dpi_mgr : public svm_dpi_mgr<axi4_master_bfm_dpi_closure> {

	public:

		axi4_master_bfm_dpi_mgr();

	private:

};



#endif /* AXI4_MASTER_BFM_DPI_MGR_H_ */
