/*
 * timebase.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_timebase_H
#define INCLUDED_timebase_H
#include "svf.h"
#include "timebase_dpi_mgr.h"

class timebase : public svf_component {

	svf_component_ctor_decl(timebase)

	public:
		svf_bidi_api_port<timebase_host_if, timebase_target_if>	bfm_port;

	public:

		timebase(const char *name, svf_component *parent);

		virtual ~timebase();

		// TODO: Virtual methods implementing the target interface
		virtual uint64_t gettime();

		// TODO: Virtual methods implementing the host interface


};

#endif /* INCLUDED_timebase_H */
