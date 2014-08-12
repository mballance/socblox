
#ifndef INCLUDED_SVF_BRIDGE_IF_H
#define INCLUDED_SVF_BRIDGE_IF_H
#include "svf_bridge_msg.h"

class svf_bridge_socket;

class svf_bridge_if {

	public:
		virtual ~svf_bridge_if() {}

		/**
		 * endpoint registration API
		virtual void connect(svf_bridge_endpoint_if *endpoint) = 0;

		virtual void disconnect(svf_bridge_endpoint_if *endpoint) = 0;
		 */

		/**
		 * Allocates a message for use by the caller
		 */
		virtual svf_bridge_msg *alloc_msg() = 0;

		/**
		 * Frees a message that the caller no longer needs
		 */
		virtual void free_msg(svf_bridge_msg *msg) = 0;

		/**
		 * Sends a message via the bridge
		 */
		virtual void send_msg(svf_bridge_socket *sock, svf_bridge_msg *msg) = 0;

};

#endif /* INCLUDED_SVF_BRIDGE_IF_H */
