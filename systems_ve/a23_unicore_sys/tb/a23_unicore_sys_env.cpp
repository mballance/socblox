/*
 * a23_unicore_sys_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_unicore_sys_env.h"

a23_unicore_sys_env::a23_unicore_sys_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

a23_unicore_sys_env::~a23_unicore_sys_env() {
	// TODO Auto-generated destructor stub
}

void a23_unicore_sys_env::build() {
	m_ram = axi4_svf_sram_bfm::type_id.create("m_ram", this);
	m_bootrom = axi4_svf_rom_bfm::type_id.create("m_bootrom", this);

	m_mem_mgr = new svf_mem_mgr();

	m_uart = uart_bfm::type_id.create("m_uart", this);

	m_core1_tracer = a23_tracer::type_id.create("m_core1_tracer", this);
	m_core2_tracer = a23_tracer::type_id.create("m_core2_tracer", this);
}

void a23_unicore_sys_env::connect() {
	/*
	m_m0_mgr->connect(m_m0);
	m_m1_mgr->connect(m_m1);
	m_m2_mgr->connect(m_m2);
	 */

	m_mem_mgr->add_region(m_bootrom, 0x00000000, 0x00000FFF);
	m_mem_mgr->add_region(m_ram, 0x20000000, 0x20003FFF);
}

svf_component_ctor_def(a23_unicore_sys_env)
