/*
 * ${name}.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_${name}_H
#define INCLUDED_${name}_H
#include "svf.h"
#include "${name}_dpi_mgr.h"

class ${name} : public svf_component, public virtual ${name}_host_if {

	svf_component_ctor_decl(${name})

	public:
		svf_bidi_api_port<${name}_host_if, ${name}_target_if>	bfm_port;

	public:

		${name}(const char *name, svf_component *parent);

		virtual ~${name}();

		// TODO: Virtual methods implementing the target interface

		// TODO: Virtual methods implementing the host interface


};

#endif /* INCLUDED_${name}_H */
