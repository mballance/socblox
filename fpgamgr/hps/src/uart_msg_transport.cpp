/*
 * uart_msg_transport.cpp
 *
 *  Created on: Jan 2, 2015
 *      Author: ballance
 */

#include "uart_msg_transport.h"

uart_msg_transport::uart_msg_transport() {
	// TODO Auto-generated constructor stub

}

uart_msg_transport::~uart_msg_transport() {
	// TODO Auto-generated destructor stub
}

void uart_msg_transport::queue_msg(svf_bridge_msg *msg)
{
	bool idle = (m_tx_queue == 0);

	msg->set_next(0);

	if (idle) {
		m_tx_queue = msg;

		// TODO: kick off transmit activity
	} else {
		svf_bridge_msg *p = m_tx_queue;

		while (p->get_next()) {
			p = p->get_next();
		}

		p->set_next(msg);
	}
}
