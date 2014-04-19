/*
 * generic_sram_byte_en_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "generic_sram_byte_en_dpi_mgr.h"

generic_sram_byte_en_dpi_mgr::generic_sram_byte_en_dpi_mgr() {
}

generic_sram_byte_en_dpi_closure::generic_sram_byte_en_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(generic_sram_byte_en)

SVF_DPI_CLOSURE_EXPORT_TASK(generic_sram_byte_en, write8, (uint64_t addr, uint8_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_sram_byte_en, write16, (uint64_t addr, uint16_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_sram_byte_en, write32, (uint64_t addr, uint32_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_sram_byte_en, read8, (uint64_t addr, uint8_t *data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_sram_byte_en, read16, (uint64_t addr, uint16_t *data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_sram_byte_en, read32, (uint64_t addr, uint32_t *data), (addr, data))


