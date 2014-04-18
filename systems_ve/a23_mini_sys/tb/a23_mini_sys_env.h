/*
 * a23_mini_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef a23_mini_sys_ENV_H_
#define a23_mini_sys_ENV_H_
#include "svf.h"
// TODO: Include BFM header files

class a23_mini_sys_env : public svf_component {
	svf_component_ctor_decl(a23_mini_sys_env)

	public:
		a23_mini_sys_env(const char *name, svf_component *parent);

		virtual ~a23_mini_sys_env();

		virtual void build();

		virtual void connect();

	public:

};

#endif /* a23_mini_sys_ENV_H_ */
