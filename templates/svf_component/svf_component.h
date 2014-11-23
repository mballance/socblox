/*
 * ${name}.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_${name}_H
#define INCLUDED_${name}_H
#include "svf.h"
#include "${baseclass}.h"

class ${name} : public ${baseclass} {
	svf_component_ctor_decl(${name})

	public:

		${name}(const char *name, svf_component *parent);

		virtual ~${name}();

		virtual void build();

		virtual void connect();

		virtual void start();

	private:

};

#endif /* INCLUDED_${name}_H */
