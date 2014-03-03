/*
 * uart_bfm_monitor.h
 *
 *  Created on: Mar 2, 2014
 *      Author: ballance
 */

#ifndef UART_BFM_MONITOR_H_
#define UART_BFM_MONITOR_H_
#include "svf.h"
#include "uart_bfm_if.h"

class uart_bfm_monitor : public virtual uart_bfm_listener_if {

	public:
		svf_api_export<uart_bfm_listener_if>		port;

	public:
		uart_bfm_monitor(const char *prefix="");

		virtual ~uart_bfm_monitor();

		void getc(int ch);

	private:
		const char			*m_prefix;
		char				m_buf[1024];
		uint32_t			m_buf_idx;

};

#endif /* UART_BFM_MONITOR_H_ */
