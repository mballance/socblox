/*
 * svf_bridge_msg.cpp
 *
 *  Created on: Jan 2, 2015
 *      Author: ballance
 */
#include "svf_bridge_msg.h"
#include <string.h>

svf_bridge_msg::svf_bridge_msg() {
	m_data = 0;
	m_size = 0;
	m_max = 0;

	m_next = 0;
}

svf_bridge_msg::~svf_bridge_msg() {
	if (m_data) {
		delete [] m_data;
	}
}

void svf_bridge_msg::write32(uint32_t data) {
	if (m_size+1 >= m_max) {
		ensure_space(1);
	}
	m_data[m_size++] = data;
}

void svf_bridge_msg::set_data(uint32_t off, uint32_t data) {
	m_data[off] = data;
}

void svf_bridge_msg::ensure_space(uint32_t sz) {
	if (m_size+sz >= m_max) {
		uint32_t *tmp = m_data;
		uint32_t new_sz = (((m_size+sz-1)/16)+1)*16;

		m_data = new uint32_t[new_sz];

		if (tmp) {
			memcpy(m_data, tmp, sizeof(uint32_t)*m_max);
		}
		m_max = new_sz;
	}
}



