/*
 * axi4_master_bfm_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "axi4_master_bfm_dpi_mgr.h"

axi4_master_bfm_dpi_mgr::axi4_master_bfm_dpi_mgr()
{

}

axi4_master_bfm_dpi_closure::axi4_master_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target)
{
}

SVF_DPI_CLOSURE_REGISTER_TASK(axi4_master_bfm)
SVF_DPI_CLOSURE_EXPORT_TASK(axi4_master_bfm, get_parameters,
		(uint32_t *ADDRESS_WIDTH, uint32_t *DATA_WIDTH, uint32_t *ID_WIDTH),
		(ADDRESS_WIDTH, DATA_WIDTH, ID_WIDTH));
SVF_DPI_CLOSURE_IMPORT_TASK(axi4_master_bfm, aw_ready, (), ());
SVF_DPI_CLOSURE_IMPORT_TASK(axi4_master_bfm, reset, (), ());

SVF_DPI_CLOSURE_EXPORT_TASK(axi4_master_bfm, aw_valid, (
				uint64_t			AWADDR,
				uint32_t			AWID,
				uint8_t				AWLEN,
				uint8_t				AWSIZE,
				uint8_t				AWBURST,
				uint8_t				AWCACHE,
				uint8_t				AWPROT,
				uint8_t				AWQOS,
				uint8_t				AWREGION),
		(AWADDR, AWID, AWLEN, AWSIZE, AWBURST, AWCACHE, AWPROT, AWQOS, AWREGION));
SVF_DPI_CLOSURE_IMPORT_TASK(axi4_master_bfm, bresp, (uint32_t resp), (resp));

SVF_DPI_CLOSURE_EXPORT_TASK(axi4_master_bfm, ar_valid, (
				uint64_t			ARADDR,
				uint32_t			ARID,
				uint8_t				ARLEN,
				uint8_t				ARSIZE,
				uint8_t				ARBURST,
				uint8_t				ARCACHE,
				uint8_t				ARPROT,
				uint8_t				ARREGION),
		(ARADDR, ARID, ARLEN, ARSIZE, ARBURST, ARCACHE, ARPROT, ARREGION));
SVF_DPI_CLOSURE_IMPORT_TASK(axi4_master_bfm, rresp, (uint32_t resp), (resp));


SVF_DPI_CLOSURE_EXPORT_TASK(axi4_master_bfm, has_been_reset, (uint32_t *reset), (reset));

SVF_DPI_CLOSURE_EXPORT_TASK(axi4_master_bfm, set_data, (uint32_t idx, uint32_t data), (idx, data));
SVF_DPI_CLOSURE_EXPORT_TASK(axi4_master_bfm, get_data, (uint32_t idx, uint32_t *data), (idx, data));




