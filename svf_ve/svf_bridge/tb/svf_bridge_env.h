/*
 * svf_bridge_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef svf_bridge_ENV_H_
#define svf_bridge_ENV_H_
#include "svf.h"
#include "svf_bridge_loopback.h"

// TODO: Include BFM header files

class svf_bridge_env : public svf_component {
	svf_component_ctor_decl(svf_bridge_env)

	public:
		svf_bridge_env(const char *name, svf_component *parent);

		virtual ~svf_bridge_env();

		virtual void build();

		virtual void connect();

	public:

		svf_bridge					*m_bridge0;
		svf_bridge					*m_bridge1;

		svf_bridge_loopback			*m_loopback;

};

#endif /* svf_bridge_ENV_H_ */
