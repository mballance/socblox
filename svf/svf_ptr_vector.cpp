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

