/*
 * axi4_l1_mem_subsys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef axi4_l1_mem_subsys_ENV_H_
#define axi4_l1_mem_subsys_ENV_H_
#include "svf.h"
// TODO: Include BFM header files
#include "axi4_master_bfm.h"
#include "timebase.h"

class axi4_l1_mem_subsys_env : public svf_component {
	svf_component_ctor_decl(axi4_l1_mem_subsys_env)

	public:
		axi4_l1_mem_subsys_env(const char *name, svf_component *parent);

		virtual ~axi4_l1_mem_subsys_env();

		virtual void build();

		virtual void connect();

	public:
		axi4_master_bfm					*m_m0;
		axi4_master_bfm					*m_m1;
		timebase						*m_timebase;

};

#endif /* axi4_l1_mem_subsys_ENV_H_ */
