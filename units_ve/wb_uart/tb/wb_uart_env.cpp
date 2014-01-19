/*
 * wb_uart_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_uart_env.h"

wb_uart_env::wb_uart_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

wb_uart_env::~wb_uart_env() {
	// TODO Auto-generated destructor stub
}

void wb_uart_env::build() {
	m_m0 = wb_master_bfm::type_id.create("m_m0", this);
	m_uart = uart_bfm::type_id.create("m_uart", this);

}

void wb_uart_env::connect() {

}

svf_component_ctor_def(wb_uart_env)
