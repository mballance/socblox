/*
 * ulink.h
 *
 *  Created on: Jan 4, 2015
 *      Author: ballance
 */

#ifndef ULINK_H_
#define ULINK_H_
#include "ulink_msg.h"
#include <stdint.h>

typedef enum {
	ULINK_MSG_CONN_REQ = 1,
	ULINK_MSG_CONN_ACK,
	ULINK_MSG_CFG_FPGA_REQ,
	ULINK_MSG_CFG_FPGA_ACK
} ulink_msg_t;

class ulink {

	public:

		ulink();

		virtual ~ulink();

		virtual bool connect() = 0;

		virtual bool wait_connection() = 0;

		virtual bool process_message(ulink_msg *msg);

		// Client API methods
	public:
		virtual int32_t configure_fpga(uint8_t *data, uint32_t sz);

	public:

		ulink_msg *recv_msg(int32_t timeout=-1);

		void send_msg(ulink_msg *msg);

		ulink_msg *alloc_msg();

		void release_msg(ulink_msg *msg);


	public:

		virtual int32_t read(uint8_t *buf, uint32_t sz, int32_t timeout=-1) = 0;

		virtual int32_t write(uint8_t *buf, uint32_t sz) = 0;

		int32_t read_exact(uint8_t *buf, uint32_t sz, int32_t timeout=-1);

		virtual void debug(const char *str) = 0;
};

#endif /* ULINK_H_ */
