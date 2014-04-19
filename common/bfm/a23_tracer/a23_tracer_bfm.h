/*
 * a23_tracer.h
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_A23_TRACER_BFM_H
#define INCLUDED_A23_TRACER_BFM_H
#include "svf.h"
#include "a23_tracer_if.h"
#include "a23_tracer_bfm_if.h"
#include "a23_tracer_bfm_dpi_mgr.h"

class a23_tracer_bfm: public svf_component, public virtual a23_tracer_bfm_host_if {

	svf_component_ctor_decl(a23_tracer_bfm)

	public:
		svf_api_publisher_port<a23_tracer_if>									port;
		svf_bidi_api_port<a23_tracer_bfm_host_if, a23_tracer_bfm_target_if>		bfm_port;

	public:
		a23_tracer_bfm(const char *name, svf_component *parent);

		virtual ~a23_tracer_bfm();

		virtual void mem_access(
				uint32_t			addr,
				bool				is_write,
				uint32_t			data);

		virtual void execute(
				uint32_t			addr,
				uint32_t			op
				);

		virtual void regchange(
				uint32_t			reg,
				uint32_t			val
				);

	private:

};

#endif /* INCLUDED_A23_TRACER_BFM_H */
