/*
 * generic_sram_byte_en_bfm.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef GENERIC_SRAM_BYTE_EN_BFM_H_
#define GENERIC_SRAM_BYTE_EN_BFM_H_
#include "svf.h"
#include "svf_mem_if.h"
#include "generic_sram_byte_en_dpi_mgr.h"

class generic_sram_byte_en_bfm : public svf_component, public virtual svf_mem_if {

	svf_component_ctor_decl(generic_sram_byte_en_bfm)

	public:
		svf_bidi_api_port<generic_sram_byte_en_host_if, generic_sram_byte_en_target_if>	bfm_port;

	public:

		generic_sram_byte_en_bfm(const char *name, svf_component *parent);

		virtual ~generic_sram_byte_en_bfm();

		virtual void write32(uint64_t addr, uint32_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write8(uint64_t addr, uint8_t data);

		virtual uint32_t read32(uint64_t addr);
		virtual uint16_t read16(uint64_t addr);
		virtual uint8_t read8(uint64_t addr);

};

#endif /* GENERIC_SRAM_BYTE_EN_BFM_H_ */
