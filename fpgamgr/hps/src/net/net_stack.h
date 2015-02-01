/*
 * net_stack.h
 *
 *  Created on: Jan 24, 2015
 *      Author: ballance
 */

#ifndef NET_STACK_H_
#define NET_STACK_H_
#include "ul_netdrv_if.h"
#include "net_packet.h"
#include "net_hdr.h"

class net_stack {

	public:

		net_stack(ul_netdrv_if *netdrv);

		virtual ~net_stack();

		virtual net_packet *recv();

		virtual void send(net_packet *pkt);

		virtual net_packet *alloc_pkt();

		virtual void release_pkt(net_packet *pkt);

	protected:

		virtual void arp_pkt(ul_netdrv_frame_t *pkt);

	private:

		ul_netdrv_if				*m_netdrv;

		net_packet					*m_pkt_alloc;

};

#endif /* NET_STACK_H_ */
