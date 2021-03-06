/*
 * generic_rom_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef GENERIC_ROM_DPI_MGR_H_
#define GENERIC_ROM_DPI_MGR_H_
#include "svf.h"
#include "svf_dpi.h"
#include "generic_rom_if.h"
#include <map>
#include <string>

using namespace std;

class generic_rom_dpi_mgr;

class generic_rom_dpi_closure : public svf_dpi_closure<generic_rom_host_if, generic_rom_target_if> {

	public:

		generic_rom_dpi_closure(const string &target);

		virtual ~generic_rom_dpi_closure() {}

		virtual void write8(uint64_t addr, uint8_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write32(uint64_t addr, uint32_t data);
		virtual void read8(uint64_t addr, uint8_t *data);
		virtual void read16(uint64_t addr, uint16_t *data);
		virtual void read32(uint64_t addr, uint32_t *data);

};

class generic_rom_dpi_mgr : public svf_dpi_mgr<generic_rom_dpi_closure> {

	public:

		generic_rom_dpi_mgr();

};



#endif /* GENERIC_ROM_DPI_MGR_H_ */
