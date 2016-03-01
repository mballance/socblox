/*
 * wb_interconnect_1x2_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef wb_interconnect_1x2_ENV_H_
#define wb_interconnect_1x2_ENV_H_
#include "svf.h"
// TODO: Include BFM header files
#include "wb_master_bfm.h"

class wb_interconnect_1x2_env : public svf_component {
	svf_component_ctor_decl(wb_interconnect_1x2_env)

	public:
		wb_interconnect_1x2_env(const char *name, svf_component *parent);

		virtual ~wb_interconnect_1x2_env();

		virtual void build();

		virtual void connect();

	public:

		wb_master_bfm						*bfm0;

};

#endif /* wb_interconnect_1x2_ENV_H_ */
