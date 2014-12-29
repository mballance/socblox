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

	m_uart = uart_bfm::type_id.create("m_uart", this);
	m_uart_monitor = new uart_bfm_monitor("# ");

	m_timebase = new timebase("m_timebase", this);

	m_c0mon = axi4_monitor_bfm::type_id.create("m_c0mon", this);

}

void a23_dualcore_sys_env::connect() {


	m_uart->ap.connect(m_uart_monitor->port);
}

svf_component_ctor_def(a23_dualcore_sys_env)
