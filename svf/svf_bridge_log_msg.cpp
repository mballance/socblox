/*
 * svf_bridge_log_msg.cpp
 *
 *  Created on: Feb 19, 2015
 *      Author: ballance
 */

#include "svf_bridge_log_msg.h"
#include "svf_msg_def.h"
#include "svf_bridge_log_renderer.h"
#include <stdio.h>

svf_bridge_log_msg::svf_bridge_log_msg(svf_bridge_log_renderer *renderer) {
	m_renderer = renderer;
	m_next = 0;
	m_msg = 0;
}

svf_bridge_log_msg::~svf_bridge_log_msg() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_log_msg::init(svf_bridge_msg *msg) {
	m_msg = msg;
}

void svf_bridge_log_msg::init(svf_msg_def_base *msg, uint32_t n_params) {
	// Ignore n_params
	uint32_t id = msg->id();
	m_renderer->register_msg_format(msg);
	m_msg->write32(svf_bridge_log_renderer::MSG_LOG_MSG);
	m_msg->write32(id); // ID
	m_msg->write32(n_params);
}


int svf_bridge_log_msg::param(uint32_t p) {
	m_msg->write32(svf_log_msg_if::u32);
	m_msg->write32(p);
	return 0;
}

int svf_bridge_log_msg::param(int32_t p) {
	m_msg->write32(svf_log_msg_if::u32);
	m_msg->write32(p);
	return 0;
}

int svf_bridge_log_msg::param(const char *p) {
	m_msg->write32(svf_log_msg_if::cchar);
	m_msg->write_str(p);
	return 0;
}

int svf_bridge_log_msg::param(const void *p) {
	uint64_t l = reinterpret_cast<uint64_t>(p);
	m_msg->write32(svf_log_msg_if::cvoid);
	m_msg->write32(l);
	m_msg->write32(l >> 32);
	return 0;
}

