#ifndef INCLUDED_GENERIC_ROM_IF_H
#define INCLUDED_GENERIC_ROM_IF_H
#include <stdint.h>

class generic_rom_target_if {
	public:

		virtual ~generic_rom_target_if() {}

		virtual void write8(uint64_t addr, uint8_t data) = 0;
		virtual void write16(uint64_t addr, uint16_t data) = 0;
		virtual void write32(uint64_t addr, uint32_t data) = 0;

		virtual void read8(uint64_t addr, uint8_t *data) = 0;
		virtual void read16(uint64_t addr, uint16_t *data) = 0;
		virtual void read32(uint64_t addr, uint32_t *data) = 0;
};

class generic_rom_host_if {
	public:

		virtual ~generic_rom_host_if() {}
};

#endif /* INCLUDED_GENERIC_ROM_IF_H */
