/*
 * uart_bfm_line_listener.cpp
 *
 *  Created on: Jan 31, 2015
 *      Author: ballance
 */

#include "uart_bfm_line_listener.h"

uart_bfm_line_listener::uart_bfm_line_listener(FILE *fd) : port(this) {
	m_fd = fd;
	m_idx = 0;
}

uart_bfm_line_listener::~uart_bfm_line_listener() {
	// TODO Auto-generated destructor stub
}

void uart_bfm_line_listener::getc(int ch) {
	m_buffer[m_idx++] = ch;

	if (ch == '\n' || m_idx >= (sizeof(m_buffer)-1)) {
		m_buffer[m_idx] = 0;
		fprintf(m_fd, "# %s", m_buffer);
		m_idx = 0;
	}
}

void uart_bfm_line_listener::flush() {
	if (m_idx > 0) {
		m_buffer[m_idx] = 0;
		fprintf(m_fd, "# %s", m_buffer);
		m_idx = 0;
	}
}

