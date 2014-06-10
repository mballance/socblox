/*
 * ${name}_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "${name}_dpi_mgr.h"

${name}_dpi_mgr::${name}_dpi_mgr() {
}

${name}_dpi_closure::${name}_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(${name})

// TODO: SVF_DPI_CLOSURE_EXPORT_TASK for tasks implemented in SystemVerilog
// SVF_DPI_CLOSURE_EXPORT_TASK(${name}, write8, (uint64_t addr, uint8_t data), (addr, data))

// TODO: SVF_DPI_CLOSURE_IMPORT_TASK for tasks implemented in C++
// SVF_DPI_CLOSURE_EXPORT_TASK(${name}, write16, (uint64_t addr, uint16_t data), (addr, data))


