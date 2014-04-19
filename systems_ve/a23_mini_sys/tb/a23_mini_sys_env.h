/*
 * a23_mini_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef a23_mini_sys_ENV_H_
#define a23_mini_sys_ENV_H_
#include "svf.h"
#include "svf_mem_mgr.h"
#include "svf_elf_loader.h"
#include "generic_rom_bfm.h"
#include "generic_sram_byte_en_bfm.h"
#include "a23_tracer_bfm.h"

// TODO: Include BFM header files

class a23_mini_sys_env : public svf_component {
	svf_component_ctor_decl(a23_mini_sys_env)

	public:
		a23_mini_sys_env(const char *name, svf_component *parent);

		virtual ~a23_mini_sys_env();

		virtual void build();

		virtual void connect();

	public:
		generic_rom_bfm				*m_rom_bfm;
		generic_sram_byte_en_bfm	*m_sram_bfm;
		svf_mem_mgr					*m_mem_mgr;

		a23_tracer_bfm				*m_a23_tracer;

};

#endif /* a23_mini_sys_ENV_H_ */
