/*
 * uart_bfm_line_listener.h
 *
 *  Created on: Jan 31, 2015
 *      Author: ballance
 */

#ifndef UART_BFM_LINE_LISTENER_H_
#define UART_BFM_LINE_LISTENER_H_

#include "uart_bfm_if.h"
#include <stdio.h>
#include <stdint.h>

class uart_bfm_line_listener: public uart_bfm_listener_if {
	public:
		svf_api_export<uart_bfm_listener_if>			port;

	public:
		uart_bfm_line_listener(FILE *fd);

		virtual ~uart_bfm_line_listener();

		virtual void getc(int ch);

		void flush();

	private:

		FILE					*m_fd;
		char					m_buffer[1024];
		uint32_t				m_idx;
};

#endif /* UART_BFM_LINE_LISTENER_H_ */
