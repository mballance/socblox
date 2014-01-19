/*
 * wb_uart_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_UART_ENV_H_
#define WB_UART_ENV_H_
#include "svf.h"
#include "wb_master_bfm.h"
#include "uart_bfm.h"

class wb_uart_env : public svf_component {
	svf_component_ctor_decl(wb_uart_env)

	public:
		wb_uart_env(const char *name, svf_component *parent);

		virtual ~wb_uart_env();

		virtual void build();

		virtual void connect();

	public:

		wb_master_bfm				*m_m0;
		uart_bfm					*m_uart;

};

#endif /* WB_UART_ENV_H_ */
