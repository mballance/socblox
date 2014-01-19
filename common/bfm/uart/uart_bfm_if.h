/*
 * uart_bfm_if.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef UART_BFM_IF_H_
#define UART_BFM_IF_H_
#include "svf.h"

class uart_bfm_target_if {

	public:

		virtual ~uart_bfm_target_if() {}

		virtual void tx_start(uint8_t ch) = 0;

};

class uart_bfm_host_if {

	public:

		virtual ~uart_bfm_host_if() {}

		virtual void tx_done() = 0;

		virtual void rx_done(uint8_t ch) = 0;

};



#endif /* UART_BFM_IF_H_ */
