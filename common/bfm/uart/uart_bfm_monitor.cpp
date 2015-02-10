/*
 * uart_bfm_monitor.cpp
 *
 *  Created on: Mar 2, 2014
 *      Author: ballance
 */

#include "uart_bfm_monitor.h"

uart_bfm_monitor::uart_bfm_monitor(const char *prefix) :
	port(this), m_prefix(prefix) {
	// TODO Auto-generated constructor stub

	m_buf_idx = 0;
}

uart_bfm_monitor::~uart_bfm_monitor() {
	// TODO Auto-generated destructor stub
}

void uart_bfm_monitor::getc(int ch) {
	if (m_buf_idx >= 1023) {
		fprintf(stdout, "Error: UART buffer overflow\n");
		fflush(stdout);
		m_buf[m_buf_idx] = 0;
		fprintf(stdout, "Buffer: %s\n", m_buf);
		fflush(stdout);
		m_buf_idx = 0;
	}
	m_buf[m_buf_idx++] = ch;

	if (ch == '\n') {
		m_buf[m_buf_idx] = 0;
		fputs(m_prefix, stdout);
		fputs(m_buf, stdout);
		fflush(stdout);
		m_buf_idx = 0;
	}
}

