/*
 * a23_tracer_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "a23_tracer_bfm_dpi_mgr.h"
#include <stdint.h>
#include <stdio.h>

a23_tracer_bfm_dpi_mgr::a23_tracer_bfm_dpi_mgr() {

}

a23_tracer_bfm_dpi_closure::a23_tracer_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target) {

}

SVF_DPI_CLOSURE_REGISTER_TASK(a23_tracer_bfm)
SVF_DPI_CLOSURE_IMPORT_TASK(a23_tracer_bfm, mem_access,
		(uint32_t addr, bool is_write, uint32_t data),
		(addr, is_write, data))
SVF_DPI_CLOSURE_IMPORT_TASK(a23_tracer_bfm, execute,
		(uint32_t addr, uint32_t op), (addr, op))
SVF_DPI_CLOSURE_IMPORT_TASK(a23_tracer_bfm, regchange,
		(uint32_t reg, uint32_t val), (reg, val))


