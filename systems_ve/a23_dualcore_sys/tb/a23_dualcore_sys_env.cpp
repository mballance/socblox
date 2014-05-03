/*
 * a23_dualcore_sys_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_env.h"

a23_dualcore_sys_env::a23_dualcore_sys_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

a23_dualcore_sys_env::~a23_dualcore_sys_env() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_env::build() {
	m_bootrom = generic_rom_bfm::type_id.create("m_bootrom", this);
	m_sram = generic_sram_byte_en_bfm::type_id.create("m_sram", this);

//	m_uart = uart_bfm::type_id.create("m_uart", this);

	m_core1_tracer = a23_tracer_bfm::type_id.create("m_core1_tracer", this);
	m_core2_tracer = a23_tracer_bfm::type_id.create("m_core2_tracer", this);

	m_trace_file = fopen("trace.dis", "w");
	m_core1_disasm = new a23_disasm_tracer(m_trace_file, "core0");
	m_core2_disasm = new a23_disasm_tracer(m_trace_file, "core1");

	m_mem_mgr = new svf_mem_mgr();
	m_mem_mgr->add_region(m_bootrom, 0x00000000, 0x0000FFFF);
	m_mem_mgr->add_region(m_sram, 0x20000000, 0x2000FFFF);
}

void a23_dualcore_sys_env::connect() {
	/*
	m_m0_mgr->connect(m_m0);
	m_m1_mgr->connect(m_m1);
	m_m2_mgr->connect(m_m2);
	 */

	m_core1_tracer->port.connect(m_core1_disasm->port);
	m_core2_tracer->port.connect(m_core2_disasm->port);


}

svf_component_ctor_def(a23_dualcore_sys_env)
