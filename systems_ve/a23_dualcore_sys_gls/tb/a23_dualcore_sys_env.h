/*
 * a23_dualcore_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef A23_DUALCORE_SYS_ENV_H_
#define A23_DUALCORE_SYS_ENV_H_
#include "svf.h"
#include "uart_bfm.h"
#include "uart_bfm_monitor.h"
#include "timebase.h"

class a23_dualcore_sys_env : public svf_component {
	svf_component_ctor_decl(a23_dualcore_sys_env)

	public:
		a23_dualcore_sys_env(const char *name, svf_component *parent);

		virtual ~a23_dualcore_sys_env();

		virtual void build();

		virtual void connect();

	public:

		uart_bfm					*m_uart;

		uart_bfm_monitor					*m_uart_monitor;

		timebase					*m_timebase;

};

#endif /* A23_DUALCORE_SYS_ENV_H_ */
