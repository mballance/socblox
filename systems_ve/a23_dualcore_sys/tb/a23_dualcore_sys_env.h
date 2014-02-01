/*
 * a23_dualcore_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef A23_DUALCORE_SYS_ENV_H_
#define A23_DUALCORE_SYS_ENV_H_
#include "svf.h"
#include "axi4_svf_sram_bfm.h"
#include "axi4_svf_rom_bfm.h"
#include "uart_bfm.h"
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

		axi4_svf_rom_bfm			*m_bootrom;
		uart_bfm					*m_uart;


		/*
		axi4_master_bfm				*m_m0;
		axi4_master_bfm				*m_m1;
		wb_master_bfm				*m_m2;

		svf_task_mgr<svf_mem_if>	*m_m0_mgr;
		svf_task_mgr<svf_mem_if>	*m_m1_mgr;
		svf_task_mgr<svf_mem_if>	*m_m2_mgr;
		 */

		axi4_svf_sram_bfm			*bfm;

};

#endif /* A23_DUALCORE_SYS_ENV_H_ */
