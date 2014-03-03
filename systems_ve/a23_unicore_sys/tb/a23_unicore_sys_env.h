/*
 * a23_unicore_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef A23_UNICORE_SYS_ENV_H_
#define A23_UNICORE_SYS_ENV_H_
#include "svf.h"
#include "axi4_svf_sram_bfm.h"
#include "axi4_svf_rom_bfm.h"
#include "svf_mem_mgr.h"
#include "uart_bfm.h"
#include "a23_tracer.h"
#include "uart_bfm_monitor.h"
//#include "wb_master_bfm.h"
//#include "axi4_master_bfm.h"

class a23_unicore_sys_env : public svf_component {
	svf_component_ctor_decl(a23_unicore_sys_env)

	public:
		a23_unicore_sys_env(const char *name, svf_component *parent);

		virtual ~a23_unicore_sys_env();

		virtual void build();

		virtual void connect();

	public:

		svf_mem_mgr					*m_mem_mgr;

		axi4_svf_rom_bfm			*m_bootrom;
		axi4_svf_sram_bfm			*m_ram;

		uart_bfm					*m_uart;
		a23_tracer					*m_core1_tracer;
		a23_tracer					*m_core2_tracer;
		uart_bfm_monitor			*m_uart_bfm_monitor;


		/*
		axi4_master_bfm				*m_m0;
		axi4_master_bfm				*m_m1;
		wb_master_bfm				*m_m2;

		svf_task_mgr<svf_mem_if>	*m_m0_mgr;
		svf_task_mgr<svf_mem_if>	*m_m1_mgr;
		svf_task_mgr<svf_mem_if>	*m_m2_mgr;
		 */


};

#endif /* A23_UNICORE_SYS_ENV_H_ */
