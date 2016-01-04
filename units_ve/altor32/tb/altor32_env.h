/*
 * altor32_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef altor32_ENV_H_
#define altor32_ENV_H_
#include "svf.h"
// TODO: Include BFM header files

class altor32_env : public svf_component {
	svf_component_ctor_decl(altor32_env)

	public:
		altor32_env(const char *name, svf_component *parent);

		virtual ~altor32_env();

		virtual void build();

		virtual void connect();

	public:

};

#endif /* altor32_ENV_H_ */
