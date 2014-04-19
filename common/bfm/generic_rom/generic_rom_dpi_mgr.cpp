/*
 * generic_rom_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "generic_rom_dpi_mgr.h"

generic_rom_dpi_mgr::generic_rom_dpi_mgr() {
}

generic_rom_dpi_closure::generic_rom_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(generic_rom)

SVF_DPI_CLOSURE_EXPORT_TASK(generic_rom, write8, (uint64_t addr, uint8_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_rom, write16, (uint64_t addr, uint16_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_rom, write32, (uint64_t addr, uint32_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_rom, read8, (uint64_t addr, uint8_t *data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_rom, read16, (uint64_t addr, uint16_t *data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(generic_rom, read32, (uint64_t addr, uint32_t *data), (addr, data))


