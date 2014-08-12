/*
 * svf_string.cpp
 *
 *  Created on: Jul 24, 2014
 *      Author: ballance
 */

#include "svf_string.h"
#include <string.h>

svf_string::svf_string() {
	m_size = 0;
	m_store = 0;
	m_max = 0;
}

svf_string::svf_string(const char *str) {
	m_size = strlen(str);
	m_max = m_size;

	m_store = new char[m_size+1];
	strcpy(m_store, str);
}

void svf_string::operator =(const char *str)
{
	uint32_t sz = strlen(str);
	if (sz >= m_max) {
		char *tmp = m_store;
		m_store = new char[sz+1];
		m_max = sz;
		m_size = sz;

		strcpy(m_store, str);

		if (tmp) {
			delete [] tmp;
		}
	}
}

bool svf_string::equals(const svf_string &other) const
{
	if (m_size == other.m_size) {
		for (uint32_t i=0; i<m_size; i++) {
			if (m_store[i] != other.m_store[i]) {
				return false;
			}
		}

		return true;
	} else {
		return false;
	}
}

bool svf_string::equals(const char *other) const
{
	uint32_t idx=0;

	while (m_store[idx] && other[idx]) {
		if (m_store[idx] != other[idx]) {
			return false;
		}
		idx++;
	}

	return (!m_store[idx] && !other[idx]);
}

svf_string::~svf_string() {
	// TODO Auto-generated destructor stub
}

