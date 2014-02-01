/*
 * axi4_wb_bridge_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_ENV_H_
#define WB_2X2_ENV_H_
#include "svf.h"
#include "wb_master_bfm.h"
#include "axi4_master_bfm.h"

class axi4_wb_bridge_env : public svf_component {
	svf_component_ctor_decl(axi4_wb_bridge_env)

	public:
		axi4_wb_bridge_env(const char *name, svf_component *parent);

		virtual ~axi4_wb_bridge_env();

		virtual void build();

		virtual void connect();

	public:

		axi4_master_bfm				*m_m0;
		axi4_master_bfm				*m_m1;
		wb_master_bfm				*m_m2;

		svf_task_mgr<svf_mem_if>	*m_m0_mgr;
		svf_task_mgr<svf_mem_if>	*m_m1_mgr;
		svf_task_mgr<svf_mem_if>	*m_m2_mgr;

};

#endif /* WB_2X2_ENV_H_ */
