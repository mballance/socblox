/*
 * ${name}_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef ${name}_ENV_H_
#define ${name}_ENV_H_
#include "svf.h"
// TODO: Include BFM header files

class ${name}_env : public svf_component {
	svf_component_ctor_decl(${name}_env)

	public:
		${name}_env(const char *name, svf_component *parent);

		virtual ~${name}_env();

		virtual void build();

		virtual void connect();

	public:

};

#endif /* ${name}_ENV_H_ */
