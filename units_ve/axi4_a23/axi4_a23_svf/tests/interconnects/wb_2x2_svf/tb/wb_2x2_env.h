/*
 * wb_2x2_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_ENV_H_
#define WB_2X2_ENV_H_
#include "svf.h"
#include "wb_master_bfm.h"

class wb_2x2_env : public svf_component {
	svf_component_ctor_decl(wb_2x2_env)

	public:
		wb_2x2_env(const char *name, svf_component *parent);

		virtual ~wb_2x2_env();

		virtual void build();

		virtual void connect();

	public:

		wb_master_bfm				*m_m0;
		wb_master_bfm				*m_m1;

};

#endif /* WB_2X2_ENV_H_ */
