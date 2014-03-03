/*
 * uart_bfm.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef UART_BFM_H_
#define UART_BFM_H_
#include "svf.h"
#include "uart_bfm_dpi_mgr.h"
#include "svf_mem_if.h"

class uart_bfm :
		public svf_component,
		public virtual uart_bfm_host_if {

	svf_component_ctor_decl(uart_bfm)

	public:
		svf_api_publisher_port<uart_bfm_listener_if>			ap;
		svf_bidi_api_port<uart_bfm_host_if, uart_bfm_target_if>	bfm_port;


	public:
		uart_bfm(const char *name, svf_component *parent);

		virtual ~uart_bfm();

		void putc(char ch);

		int getc();

		virtual void rx_done(uint8_t ch);

		virtual void tx_done();

	private:
		char							m_ch;
		svf_thread_mutex				m_rx_mutex;
		svf_thread_cond					m_rx_cond;

		svf_semaphore					m_tx_sem;

};

#endif /* UART_BFM_H_ */
