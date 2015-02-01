/*
 * a23_dualcore_sys_env.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_a23_dualcore_sys_env_H
#define INCLUDED_a23_dualcore_sys_env_H
#include "svf.h"
#include "svf_component.h"

class a23_dualcore_sys_env : public svf_component {
	svf_component_ctor_decl(a23_dualcore_sys_env)

	public:

		a23_dualcore_sys_env(const char *name, svf_component *parent);

		virtual ~a23_dualcore_sys_env();

		virtual void build();

		virtual void connect();

		virtual void start();

	private:

};

#endif /* INCLUDED_a23_dualcore_sys_env_H */
