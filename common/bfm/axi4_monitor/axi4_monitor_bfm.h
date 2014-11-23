/*
 * axi4_monitor_bfm.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_axi4_monitor_bfm_H
#define INCLUDED_axi4_monitor_bfm_H
#include "svf.h"
#include "axi4_monitor_bfm_dpi_mgr.h"

class axi4_monitor_bfm : public svf_component, public virtual axi4_monitor_bfm_host_if {

	svf_component_ctor_decl(axi4_monitor_bfm)

	public:
		svf_bidi_api_port<axi4_monitor_bfm_host_if, axi4_monitor_bfm_target_if>	bfm_port;

		svf_api_publisher_port<axi4_monitor_bfm_host_if>						ap;

	public:

		axi4_monitor_bfm(const char *name, svf_component *parent);

		virtual ~axi4_monitor_bfm();

		// TODO: Virtual methods implementing the target interface

		// TODO: Virtual methods implementing the host interface

		virtual void ar(
				uint32_t			araddr,
				uint32_t			arid,
				uint32_t			arlen,
				uint32_t			arsize,
				uint32_t			arburst,
				uint32_t			arlock,
				uint32_t			arcache,
				uint32_t			arprot,
				uint32_t			arqos,
				uint32_t			arregion);

		virtual void rdata(
				uint64_t			rdata,
				uint32_t			rid,
				uint32_t			rresp,
				uint32_t			rlast);

		virtual void aw(
				uint32_t			awaddr,
				uint32_t			awid,
				uint32_t			awlen,
				uint32_t			awsize,
				uint32_t			awburst,
				uint32_t			awlock,
				uint32_t			awcache,
				uint32_t			awprot,
				uint32_t			awqos,
				uint32_t			awregion);

		virtual void wdata(
				uint64_t			wdata,
				uint64_t			wstrb,
				uint32_t			wlast);

		virtual void wresp(
				uint32_t			bid,
				uint32_t			bresp);
};

#endif /* INCLUDED_axi4_monitor_bfm_H */
