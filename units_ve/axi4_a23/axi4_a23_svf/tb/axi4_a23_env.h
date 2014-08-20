/*
 * axi4_a23_env.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef AXI4_A23_ENV_H_
#define AXI4_A23_ENV_H_

#include "svf.h"
#include "a23_tracer_bfm.h"
#include "generic_sram_byte_en_bfm.h"


class axi4_a23_env: public svf_component {
	svf_component_ctor_decl(axi4_a23_env)

	public:

		axi4_a23_env(const char *name, svf_component *parent);

		virtual ~axi4_a23_env();

		virtual void build();

		virtual void connect();

	public:

		generic_sram_byte_en_bfm		*m_s0_bfm;
		a23_tracer_bfm					*m_tracer;

};

#endif /* AXI4_A23_ENV_H_ */
