/*
 * timebase_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "timebase_dpi_mgr.h"

timebase_dpi_mgr::timebase_dpi_mgr() {
}

timebase_dpi_closure::timebase_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(timebase)

// TODO: SVF_DPI_CLOSURE_EXPORT_TASK for tasks implemented in SystemVerilog
// SVF_DPI_CLOSURE_EXPORT_TASK(timebase, write8, (uint64_t addr, uint8_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(timebase, gettime, (uint64_t *curr_time), (curr_time))

// TODO: SVF_DPI_CLOSURE_IMPORT_TASK for tasks implemented in C++
// SVF_DPI_CLOSURE_EXPORT_TASK(timebase, write16, (uint64_t addr, uint16_t data), (addr, data))


