/*
 * svf_bridge_loopback.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_svf_bridge_loopback_H
#define INCLUDED_svf_bridge_loopback_H
#include "svf.h"
#include "svf_component.h"
#include "svf_bridge_link_impl.h"
#include "svf_bridge_loopback_msg.h"

class svf_bridge_loopback : public svf_component {
	svf_component_ctor_decl(svf_bridge_loopback)

	public:
		svf_api_export<svf_bridge_link_if>				bridge0_port;
		svf_api_export<svf_bridge_link_if>				bridge1_port;

	public:

		svf_bridge_loopback(const char *name, svf_component *parent);

		virtual ~svf_bridge_loopback();

		virtual void build();

		virtual void connect();

		virtual void start();

		svf_bridge_loopback_msg *alloc_msg();

		void free_msg(svf_bridge_loopback_msg *msg);

	private:
		svf_bridge_link_impl							m_impl0;
		svf_bridge_link_impl							m_impl1;

		svf_bridge_loopback_msg							*m_msg_alloc;

};

#endif /* INCLUDED_svf_bridge_loopback_H */
