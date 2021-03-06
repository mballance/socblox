/*
 * svf_ptr_vector.cpp
 *
 *  Created on: Jul 24, 2014
 *      Author: ballance
 */

#include "svf_ptr_vector.h"

svf_ptr_vector_base::svf_ptr_vector_base() {
	// TODO Auto-generated constructor stub
	m_size = 0;
	m_limit = 0;
	m_incr = 4;
	m_store = 0;
}

svf_ptr_vector_base::~svf_ptr_vector_base() {
	// TODO Auto-generated destructor stub
}

void svf_ptr_vector_base::set_size(uint32_t sz) {
	if (sz >= m_limit) {
		// resize the vector
		void **old = m_store;
		m_limit = sz;
		m_store = new void *[m_limit];

		if (old) {
			for (uint32_t i=0; i<m_size; i++) {
				m_store[i] = old[i];
			}
		}
	}
	for (uint32_t i=m_size; i<sz; i++) {
		m_store[i] = 0;
	}
	m_size = sz;
}

void svf_ptr_vector_base::append_int(void *it)
{
	if (m_size >= m_limit) {
		void **tmp = m_store;

		m_limit += m_incr;
		m_store = new void *[m_limit];

		for (uint32_t i=0; i<m_size; i++) {
			m_store[i] = tmp[i];
		}

		if (tmp) {
			delete [] tmp;
		}
	}

	m_store[m_size++] = it;
}

void svf_ptr_vector_base::remove_int(uint32_t idx) {
	if (idx == (m_size-1)) {
		// Can just reduce the size
		m_size--;
	} else {
		for (uint32_t i=idx; i<(m_size-1); i++) {
			m_store[i] = m_store[i+1];
		}
		m_size--;
	}
}

void svf_ptr_vector_base::remove_int(void *it) {
	for (uint32_t i=0; i<m_size; i++) {
		if (m_store[i] == it) {
			remove_int(i);
			break;
		}
	}
}
