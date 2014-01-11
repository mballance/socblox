/*
 * a23_tracer.h
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 */

#ifndef A23_TRACER_H_
#define A23_TRACER_H_
#include "svf.h"
#include "a23_tracer_if.h"

class a23_tracer: public svf_component {

	svf_component_ctor_decl(a23_tracer)

	public:
		svf_api_publisher_port<a23_tracer_if>			port;

	public:
		a23_tracer(const char *name, svf_component *parent);

		virtual ~a23_tracer();

};

#endif /* A23_TRACER_H_ */
