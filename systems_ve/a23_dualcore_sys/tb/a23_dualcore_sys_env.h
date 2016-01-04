/*
 * a23_dualcore_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef A23_DUALCORE_SYS_ENV_H_
#define A23_DUALCORE_SYS_ENV_H_
#include "svf.h"
#include "generic_sram_byte_en_bfm.h"
#include "svf_mem_mgr.h"
#include "uart_bfm.h"
#include "uart_bfm_monitor.h"
#include "a23_tracer_bfm.h"
#include "a23_disasm_tracer.h"
#include "timebase.h"
#include "axi4_monitor_bfm.h"
#include "bidi_message_queue_direct_bfm.h"
//#include "wb_master_bfm.h"
//#include "axi4_master_bfm.h"

class a23_dualcore_sys_env : public svf_component {
	svf_component_ctor_decl(a23_dualcore_sys_env)

	public:
		a23_dualcore_sys_env(const char *name, svf_component *parent);

		virtual ~a23_dualcore_sys_env();

		virtual void build();

		virtual void connect();

	public:

		generic_sram_byte_en_bfm	*m_sram;
		generic_sram_byte_en_bfm	*m_ddr;
		svf_mem_mgr					*m_mem_mgr;
		uart_bfm					*m_uart;
		a23_tracer_bfm				*m_core1_tracer;
		a23_tracer_bfm				*m_core2_tracer;

		FILE						*m_trace_file;
		timebase					*m_timebase;

		bidi_message_queue_direct_bfm		*m_msg_queue_0;
		bidi_message_queue_direct_bfm		*m_msg_queue_1;
		svf_bridge							*m_bridge;
		uart_bfm_monitor					*m_uart_monitor;

		axi4_monitor_bfm					*m_core12ic_monitor;
		axi4_monitor_bfm					*m_core02ic_monitor;
		axi4_monitor_bfm					*m_ic2ram_monitor;
		axi4_monitor_bfm					*m_core2ic_monitor;


		/*
		axi4_master_bfm				*m_m0;
		axi4_master_bfm				*m_m1;
		wb_master_bfm				*m_m2;

		svf_task_mgr<svf_mem_if>	*m_m0_mgr;
		svf_task_mgr<svf_mem_if>	*m_m1_mgr;
		svf_task_mgr<svf_mem_if>	*m_m2_mgr;
		 */

};

#endif /* A23_DUALCORE_SYS_ENV_H_ */
