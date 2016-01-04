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
	m_sram = generic_sram_byte_en_bfm::type_id.create("m_sram", this);
	m_ddr = generic_sram_byte_en_bfm::type_id.create("m_ddr", this);

	m_uart = uart_bfm::type_id.create("m_uart", this);

	m_core1_tracer = a23_tracer_bfm::type_id.create("m_core1_tracer", this);
	m_core2_tracer = a23_tracer_bfm::type_id.create("m_core2_tracer", this);

//	m_trace_file = fopen("trace.dis", "w");

	m_uart_monitor = new uart_bfm_monitor("# ");

	m_timebase = new timebase("m_timebase", this);

	m_mem_mgr = new svf_mem_mgr();
	m_mem_mgr->add_region(m_sram, 0x02000000, 0x020FFFFF);
	m_mem_mgr->add_region(m_ddr, 0x03000000, 0x0303FFFF);

	m_msg_queue_0 = bidi_message_queue_direct_bfm::type_id.create("m_msg_queue_0", this);
	m_msg_queue_1 = bidi_message_queue_direct_bfm::type_id.create("m_msg_queue_1", this);

	m_bridge = new svf_bridge("m_bridge", this);

	m_core12ic_monitor = axi4_monitor_bfm::type_id.create("m_core12ic_monitor", this);
	m_core02ic_monitor = axi4_monitor_bfm::type_id.create("m_core02ic_monitor", this);
	m_ic2ram_monitor = axi4_monitor_bfm::type_id.create("m_ic2ram_monitor", this);
	m_core2ic_monitor = axi4_monitor_bfm::type_id.create("m_core2ic_monitor", this);
}

void a23_dualcore_sys_env::connect() {
	/*
	m_m0_mgr->connect(m_m0);
	m_m1_mgr->connect(m_m1);
	m_m2_mgr->connect(m_m2);
	 */


	m_uart->ap.connect(m_uart_monitor->port);
}

svf_component_ctor_def(a23_dualcore_sys_env)
