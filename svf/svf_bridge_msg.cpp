/*
 * svf_bridge_msg.cpp
 *
 *  Created on: Jan 2, 2015
 *      Author: ballance
 */
#include "svf_bridge_msg.h"
#include <string.h>
#include <stdio.h>

svf_bridge_msg::svf_bridge_msg() {
	m_data = 0;
	m_size = 0;
	m_max = 0;
	m_read_idx = 0;

	m_next = 0;
}

svf_bridge_msg::~svf_bridge_msg() {
	if (m_data) {
		delete [] m_data;
	}
}

void svf_bridge_msg::init() {
	m_size = 0;
	m_read_idx = 0;
	m_next = 0;
}

void svf_bridge_msg::write32(uint32_t data) {
	if (m_size+1 >= m_max) {
		ensure_space(1);
	}
	m_data[m_size++] = data;
}

void svf_bridge_msg::write_str(const char *str) {
	uint32_t len = strlen(str);
	uint32_t n_words = (len/4)+2;

	if (m_size+n_words > m_max) {
		ensure_space(n_words);
	}

	m_data[m_size++] = len;
	for (uint32_t i=0; i<len; i+=4) {
		uint32_t w =
				(str[i] << 0) |
				(str[i+1] << 8) |
				(str[i+2] << 16) |
				(str[i+3] << 24);
		m_data[m_size++] = w;
	}
}

uint32_t svf_bridge_msg::read32() {
	if (m_read_idx < m_size) {
		return m_data[m_read_idx++];
	} else {
		return 0;
	}
}

void svf_bridge_msg::read_str(svf_string &str) {
	str.clear();

	if (m_read_idx < m_size) {
		uint32_t sz = m_data[m_read_idx++];

		for (uint32_t i=0; i<sz && m_read_idx < m_size; ) {
			uint32_t data = m_data[m_read_idx++];
			for (uint32_t j=0; j<4 && i<sz; j++, i++) {
				str.append(data);
				data >>= 8;
			}
		}
	}
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

void svf_bridge_msg::set_size(uint32_t sz) {
	m_size = sz;
}



