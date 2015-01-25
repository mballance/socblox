/*
 * net_packet.h
 *
 *  Created on: Jan 24, 2015
 *      Author: ballance
 */

#ifndef NET_PACKET_H_
#define NET_PACKET_H_
#include <stdio.h>
#include <stdint.h>

class net_packet {
	public:
		net_packet();

		virtual ~net_packet();

		void init();

		inline void set_next(net_packet *pkt) { m_next = pkt; }

		inline net_packet *next() const { return m_next; }

		int32_t write(void *data, uint32_t sz);

		int32_t read(void *data, uint32_t sz);

	private:

		net_packet				*m_next;
		uint8_t					*m_data;
		uint32_t				m_data_len;
		uint32_t				m_data_max;
};

#endif /* NET_PACKET_H_ */
