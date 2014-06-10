/*
 * uth_coop_scheduler_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef uth_coop_scheduler_ENV_H_
#define uth_coop_scheduler_ENV_H_
#include "svf.h"
// TODO: Include BFM header files

class uth_coop_scheduler_env : public svf_component {
	svf_component_ctor_decl(uth_coop_scheduler_env)

	public:
		uth_coop_scheduler_env(const char *name, svf_component *parent);

		virtual ~uth_coop_scheduler_env();

		virtual void build();

		virtual void connect();

	public:

};

#endif /* uth_coop_scheduler_ENV_H_ */
