/*
 * a23_mini_sys_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_mini_sys_env.h"

a23_mini_sys_env::a23_mini_sys_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

a23_mini_sys_env::~a23_mini_sys_env() {
	// TODO Auto-generated destructor stub
}

void a23_mini_sys_env::build() {
	// TODO: instantiate BFMs
	m_rom_bfm = generic_rom_bfm::type_id.create("m_rom_bfm", this);
	m_sram_bfm = generic_sram_byte_en_bfm::type_id.create("m_sram_bfm", this);

	m_mem_mgr = new svf_mem_mgr();
	m_mem_mgr->add_region(m_rom_bfm, 0x00000000, 0x0000FFFF);
	m_mem_mgr->add_region(m_sram_bfm, 0x20000000, 0x2000FFFF);

	m_a23_tracer = a23_tracer_bfm::type_id.create("m_a23_tracer", this);
}

void a23_mini_sys_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(a23_mini_sys_env)
