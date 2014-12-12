/*
 * a23_dualcore_sys_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef A23_DUALCORE_TEST_BASE_H_
#define A23_DUALCORE_TEST_BASE_H_
#include "svf.h"
#include "a23_dualcore_sys_env.h"
#include "a23_disasm_tracer.h"
#include "uart_bfm_monitor.h"
#include "axi4_monitor_stream_logger.h"

class a23_dualcore_sys_test_base : public svf_test {
	svf_test_ctor_decl(a23_dualcore_sys_test_base)

	public:
		a23_dualcore_sys_test_base(const char *name);

		virtual ~a23_dualcore_sys_test_base();

		virtual void build();

		virtual void connect();

		virtual void shutdown();

	protected:

		a23_dualcore_sys_env		*m_env;
		a23_disasm_tracer			*m_core1_disasm_tracer;
		a23_disasm_tracer			*m_core2_disasm_tracer;

		FILE							*m_axi4_trace_fp;
		axi4_monitor_stream_logger		*m_core12ic_logger;
		axi4_monitor_stream_logger		*m_core02ic_logger;
		axi4_monitor_stream_logger		*m_ic2ram_logger;
		axi4_monitor_stream_logger		*m_core2ic_logger;

		a23_disasm_tracer			*m_core1_disasm;
		a23_disasm_tracer			*m_core2_disasm;

};

#endif /* A23_DUALCORE_TEST_BASE_H_ */
