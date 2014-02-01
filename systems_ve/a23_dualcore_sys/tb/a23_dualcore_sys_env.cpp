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
	bfm = axi4_svf_sram_bfm::type_id.create("bfm", this);

	m_bootrom = axi4_svf_rom_bfm::type_id.create("m_bootrom", this);

	m_uart = uart_bfm::type_id.create("m_uart", this);

}

void a23_dualcore_sys_env::connect() {
	/*
	m_m0_mgr->connect(m_m0);
	m_m1_mgr->connect(m_m1);
	m_m2_mgr->connect(m_m2);
	 */

}

svf_component_ctor_def(a23_dualcore_sys_env)
