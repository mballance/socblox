/*
 * svf_log_msg.cpp
 *
 *  Created on: Feb 11, 2015
 *      Author: ballance
 */

#include "svf_log_msg.h"
#include <string.h>
#include <stdio.h>

svf_log_msg_it::svf_log_msg_it(const svf_log_msg *msg) {
	m_msg = msg;
	m_idx = msg->m_n_params-1;
}

svf_log_msg::svf_log_msg() {
	m_n_params = 0;
	m_params_t = 0;
	m_params_u = 0;
	m_max_params = 0;
}

svf_log_msg::~svf_log_msg() {
	// TODO Auto-generated destructor stub
}

void svf_log_msg::init(svf_msg_def_base *msg, uint32_t n_params) {
	m_msg_def = msg;
	m_n_params = n_params;
	m_params_idx = 0;

	if (m_n_params > m_max_params) {
		if (m_params_t) {
			delete [] m_params_t;
		}
		m_params_t = new param_t[m_n_params];

		if (m_params_u) {
			delete [] m_params_u;
		}
		m_params_u = new param_u[m_n_params];

		m_max_params = m_n_params;
	}
}

int svf_log_msg::param(uint32_t p) {
	m_params_t[m_params_idx] = u32;
	m_params_u[m_params_idx].u32 = p;
	m_params_idx++;

	return 0;
}

int svf_log_msg::param(int32_t p) {
	m_params_t[m_params_idx] = u32;
	m_params_u[m_params_idx].u32 = p;
	m_params_idx++;

	return 0;
}

int svf_log_msg::param(const char *p) {
	m_params_t[m_params_idx] = cchar;
	m_params_u[m_params_idx].cchar = p;
	m_params_idx++;

	return 0;
}

int svf_log_msg::param(const void *p) {
	m_params_t[m_params_idx] = cvoid;
	m_params_u[m_params_idx].cvoid = p;
	m_params_idx++;

	return 0;
}
