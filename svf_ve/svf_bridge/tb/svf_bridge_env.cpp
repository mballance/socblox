/*
 * svf_bridge_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "svf_bridge_env.h"

svf_bridge_env::svf_bridge_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

svf_bridge_env::~svf_bridge_env() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_env::build() {
	// TODO: instantiate BFMs
	m_bridge0 = new svf_bridge("m_bridge0", this);
	m_bridge1 = new svf_bridge("m_bridge1", this);

	m_loopback = new svf_bridge_loopback("m_loopback", this);
}

void svf_bridge_env::connect() {
	// TODO: connect BFMs

	m_bridge0->link_port.connect(m_loopback->bridge0_port);
	m_bridge1->link_port.connect(m_loopback->bridge1_port);
}

svf_component_ctor_def(svf_bridge_env)
