/*
 * uart_bfm_dpi_mgr.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef UART_BFM_DPI_MGR_H_
#define UART_BFM_DPI_MGR_H_
#include "svf.h"
#include "svf_dpi.h"
#include "uart_bfm_if.h"

class uart_bfm_dpi_closure : public svf_dpi_closure<uart_bfm_host_if, uart_bfm_target_if> {
	public:

		uart_bfm_dpi_closure(const string &target);

		virtual ~uart_bfm_dpi_closure() {}

		virtual void tx_start(uint8_t ch);

};

class uart_bfm_dpi_mgr : public svf_dpi_mgr<uart_bfm_dpi_closure> {
	public:
		uart_bfm_dpi_mgr();

};

#endif /* UART_BFM_DPI_MGR_H_ */
