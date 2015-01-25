/*
 * net_stack.cpp
 *
 *  Created on: Jan 24, 2015
 *      Author: ballance
 */

#include "net_stack.h"

#define PROT_IP		0x0800		/* IP protocol			*/
#define PROT_ARP	0x0806		/* IP ARP protocol		*/
#define PROT_RARP	0x8035		/* IP ARP protocol		*/
#define PROT_VLAN	0x8100		/* IEEE 802.1q protocol		*/

net_stack::net_stack(ul_netdrv_if *netdrv) {
	m_netdrv = netdrv;
	m_pkt_alloc = 0;
}

net_stack::~net_stack() {
	// TODO Auto-generated destructor stub
}

net_packet *net_stack::recv() {
	net_packet *ret = 0;

	do {
		ul_netdrv_frame_t *frm = m_netdrv->recv();

		// Check to see if this is a packet we should process internally
		// or pass back
		// TODO: ntohs
		uint16_t eth_proto = (frm->data[6+6+0] << 8) | frm->data[6+6+1];

		printf("eth_proto=0x%04x sz=%d\n", (uint32_t)eth_proto, frm->sz);

		switch (eth_proto) {
			case PROT_IP:
				break;

			case PROT_ARP:
				break;

			case PROT_RARP:
				break;

			case PROT_VLAN:
				break;

			default:
				printf("Unknown protocol 0x%04x\n", (uint32_t)eth_proto);
				break;
		}

		ret = alloc_pkt();
		ret->write(&frm->data[6+6+2], frm->sz-6-6-2);

		m_netdrv->release_frame(frm);

	} while (!ret);

	return ret;
}

void net_stack::send(net_packet *pkt) {

}

net_packet *net_stack::alloc_pkt() {
	net_packet *pkt;

	if (m_pkt_alloc) {
		pkt = m_pkt_alloc;
		m_pkt_alloc = pkt->next();
		pkt->init();
	} else {
		pkt = new net_packet();
	}

	return pkt;
}

void net_stack::release_pkt(net_packet *pkt) {
	pkt->set_next(m_pkt_alloc);
	m_pkt_alloc = pkt;
}



