/*
 * wb_master_bfm_dpi_mgr.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include "wb_master_bfm_dpi_mgr.h"

wb_master_bfm_dpi_mgr::wb_master_bfm_dpi_mgr() {
}

wb_master_bfm_dpi_closure::wb_master_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target) {

}

SVF_DPI_CLOSURE_REGISTER_TASK(wb_master_bfm)

SVF_DPI_CLOSURE_EXPORT_TASK(wb_master_bfm, get_parameters,
		(uint32_t *ADDR_WIDTH, uint32_t *DATA_WIDTH),
		(ADDR_WIDTH, DATA_WIDTH))

SVF_DPI_CLOSURE_EXPORT_TASK(wb_master_bfm, request,
		(uint64_t ADR, uint8_t CTI, uint8_t BTE, uint32_t SEL, uint8_t WE),
		(ADR, CTI, BTE, SEL, WE))
SVF_DPI_CLOSURE_EXPORT_TASK(wb_master_bfm, set_data,
		(uint32_t idx, uint32_t data), (idx, data))

SVF_DPI_CLOSURE_EXPORT_TASK(wb_master_bfm, get_data,
		(uint32_t idx, uint32_t *data), (idx, data))

SVF_DPI_CLOSURE_IMPORT_TASK(wb_master_bfm, acknowledge, (uint8_t ERR), (ERR));

SVF_DPI_CLOSURE_IMPORT_TASK(wb_master_bfm, reset, (), ())




