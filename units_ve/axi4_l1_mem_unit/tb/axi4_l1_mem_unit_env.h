/*
 * axi4_l1_mem_unit_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef axi4_l1_mem_unit_ENV_H_
#define axi4_l1_mem_unit_ENV_H_
#include "svf.h"
// TODO: Include BFM header files
#include "axi4_master_bfm.h"

class axi4_l1_mem_unit_env : public svf_component {
	svf_component_ctor_decl(axi4_l1_mem_unit_env)

	public:
		axi4_l1_mem_unit_env(const char *name, svf_component *parent);

		virtual ~axi4_l1_mem_unit_env();

		virtual void build();

		virtual void connect();

	public:

		axi4_master_bfm					*m_m0;

};

#endif /* axi4_l1_mem_unit_ENV_H_ */
