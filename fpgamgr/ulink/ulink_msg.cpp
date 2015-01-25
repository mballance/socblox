/*
 * ulink_msg.cpp
 *
 *  Created on: Jan 5, 2015
 *      Author: ballance
 */

#include "ulink_msg.h"
#include <string.h>

ulink_msg::ulink_msg() {
	m_checksum_err = false;
	m_data = 0;
	m_max_size = 0;
	m_size = 0;
	m_next = 0;
	m_read_idx = 0;
}

ulink_msg::~ulink_msg() {
	if (m_data) {
		delete [] m_data;
	}
}

void ulink_msg::ensure_avail(uint32_t sz) {
	if (sz > (m_max_size-m_size)) {
		uint8_t *tmp = m_data;

		// Always allocate at least 1k
		sz = ((sz/1024)+1)*1024;

		m_data = new uint8_t[m_size+sz];

		if (tmp) {
			memcpy(m_data, tmp, m_size);
			delete [] tmp;
		}

		m_max_size += sz;
	}
}

void ulink_msg::append(uint8_t *buf, uint32_t sz) {
	if (sz > (m_max_size-m_size)) {
		ensure_avail(sz);
	}

	memcpy(&m_data[m_size], buf, sz);
	m_size += sz;
}

void ulink_msg::write8(uint8_t b) {
	if (1 > (m_max_size-m_size)) {
		ensure_avail(1);
	}
	m_data[m_size++] = b;
}

void ulink_msg::write32(uint32_t v) {
	if (4 > (m_max_size-m_size)) {
		ensure_avail(4);
	}
	m_data[m_size++] = (v);
	m_data[m_size++] = (v >> 8);
	m_data[m_size++] = (v >> 16);
	m_data[m_size++] = (v >> 24);
}

uint8_t ulink_msg::read8() {
	if (m_read_idx < m_size) {
		return m_data[m_read_idx++];
	}
	return 0;
}

uint32_t ulink_msg::read32() {
	if (m_read_idx+4 <= m_size) {
		uint32_t ret = m_data[m_read_idx++];
		ret |= (m_data[m_read_idx++] << 8);
		ret |= (m_data[m_read_idx++] << 16);
		ret |= (m_data[m_read_idx++] << 24);
		return ret;
	} else {
		m_read_idx = m_size; // just ensure we consume the data
		return 0;
	}
}
