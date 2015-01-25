/*
 * net_packet.cpp
 *
 *  Created on: Jan 24, 2015
 *      Author: ballance
 */

#include "net_packet.h"
#include <string.h>

net_packet::net_packet() {
	m_next = 0;
	m_data = 0;
	m_data_len = 0;
	m_data_max = 0;
}

net_packet::~net_packet() {
	// TODO Auto-generated destructor stub
}

void net_packet::init() {
	m_data_len = 0;
}

int32_t net_packet::write(void *data, uint32_t sz) {

	if (m_data_len+sz >= m_data_max) {
		// Need to realloc
		uint8_t *tmp = m_data;
		uint32_t new_sz = (m_data_max)?(((m_data_max+sz-1)/1024)+1)*1024:1024;
		m_data = new uint8_t[new_sz];

		if (tmp) {
			memcpy(m_data, tmp, m_data_len);
			delete [] tmp;
		}

		m_data_max = new_sz;
	}

	memcpy(&m_data[m_data_len], data, sz);

	m_data_len += sz;

	return sz;
}

int32_t net_packet::read(void *data, uint32_t sz) {
	return 0;
}
