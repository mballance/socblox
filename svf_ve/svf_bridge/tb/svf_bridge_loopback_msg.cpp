/*
 * svf_bridge_loopback_msg.cpp
 *
 *  Created on: Feb 17, 2015
 *      Author: ballance
 */

#include "svf_bridge_loopback_msg.h"
#include <stdio.h>
#include <string.h>

svf_bridge_loopback_msg::svf_bridge_loopback_msg() {
	m_data = 0;
	m_msg_max = 0;
	m_msg_sz = 0;
	m_next = 0;
}

svf_bridge_loopback_msg::~svf_bridge_loopback_msg() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_loopback_msg::init(uint32_t sz, uint32_t *data) {
	if (sz > m_msg_max) {
		uint32_t *tmp = m_data;
		uint32_t new_sz = (((sz-1)/16)+1)*16;
		m_data = new uint32_t[new_sz];
		m_msg_max = new_sz;
	}
	memcpy(m_data, data, sizeof(uint32_t)*sz);
	m_msg_sz = sz;
}

void svf_bridge_loopback_msg::read(uint32_t *data) {
	memcpy(data, m_data, sizeof(uint32_t)*m_msg_sz);
}

