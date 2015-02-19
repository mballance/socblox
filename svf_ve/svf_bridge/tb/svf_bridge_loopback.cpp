/*
 * svf_bridge_loopback.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "svf_bridge_loopback.h"

svf_bridge_loopback::svf_bridge_loopback(const char *name, svf_component *parent) :
	svf_component(name, parent), bridge0_port(&m_impl0), bridge1_port(&m_impl1) {

	m_impl0.init(this, &m_impl1);
	m_impl1.init(this, &m_impl0);
}

svf_bridge_loopback::~svf_bridge_loopback() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_loopback::build() {
	svf_component::build();
}

void svf_bridge_loopback::connect() {
	svf_component::connect();
}

void svf_bridge_loopback::start() {
	svf_component::start();
}

svf_bridge_loopback_msg *svf_bridge_loopback::alloc_msg() {
	svf_bridge_loopback_msg *ret;

	if (m_msg_alloc) {
		ret = m_msg_alloc;
		m_msg_alloc = m_msg_alloc->next();
		ret->set_next(0);
	} else {
		ret = new svf_bridge_loopback_msg();
	}

	return ret;
}

void svf_bridge_loopback::free_msg(svf_bridge_loopback_msg *msg) {
	msg->set_next(m_msg_alloc);
	m_msg_alloc = msg;
}

svf_component_ctor_def(svf_bridge_loopback)

