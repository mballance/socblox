/*
 * uart_msg_transport.h
 *
 *  Created on: Jan 2, 2015
 *      Author: ballance
 */

#ifndef UART_MSG_TRANSPORT_H_
#define UART_MSG_TRANSPORT_H_
#include "svf_bridge_msg.h"

class uart_msg_transport {

	public:

		uart_msg_transport();

		virtual ~uart_msg_transport();

		void queue_msg(svf_bridge_msg *msg);

	private:



	private:

		svf_bridge_msg					*m_tx_queue;

};

#endif /* UART_MSG_TRANSPORT_H_ */
