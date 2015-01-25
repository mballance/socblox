/*
 * ulink.cpp
 *
 *  Created on: Jan 4, 2015
 *      Author: ballance
 */

#include "ulink.h"
#include "crc32.h"
#ifdef HOST
#include <stdio.h>
#endif

ulink::ulink() {
	// TODO Auto-generated constructor stub

}

ulink::~ulink() {
	// TODO Auto-generated destructor stub
}

bool ulink::process_message(ulink_msg *msg) {
	uint32_t id = msg->read8();
	ulink_msg *rsp = 0;

	switch (id) {
//		case ULINK_MSG_CONN_REQ: {
//			rsp = alloc_msg();
//			rsp->write8(ULINK_MSG_CONN_ACK);
//			} break;

		case ULINK_MSG_CFG_FPGA_REQ: {
			int32_t result = configure_fpga(&msg->data()[1], msg->size()-1);
			rsp = alloc_msg();
			rsp->write8(ULINK_MSG_CFG_FPGA_ACK);
			rsp->write32(result);
		}
	}

	release_msg(msg);

	if (rsp) {
		send_msg(rsp);
	}

	return true;
}

int32_t ulink::configure_fpga(uint8_t *data, uint32_t sz) {
	return 0;
}

ulink_msg *ulink::recv_msg(int32_t timeout)
{
	bool have_preamble = false;
	uint8_t ch;
	uint8_t preamble[] = {0x55, 0xAA, 0xEA, 0xAE};
	uint8_t header[12];
	uint8_t tmp[4096];
	ulink_msg *msg;
	int32_t ret;

	do {
		have_preamble = true;

		for (int i=0; i<4; i++) {
			if ((ret = read(&ch, 1, timeout)) == -1 || ret == 0) {
				return 0;
			}
#ifdef HOST
			fprintf(stdout, "Header %0d: %c 0x%08x\n", i,
					((ch >= 'a' && ch <= 'z')||(ch >= 'A' && ch <= 'Z'))?ch:'$', ch);
#else
			debug("wait header");
#endif
			if (ch != preamble[i]) {
				have_preamble = false;
				break;
			} else {
				header[i] = ch;
			}
		}
	} while (!have_preamble);

	debug("Have Header");
#ifdef HOST
	fprintf(stdout, "Have Header\n");
#endif

	// Found the preamble. Now read the header
	if (read_exact(&header[4], 8, timeout) < 4) {
		// Timeout
		debug("Failed to read header");
		return 0;
	}

	// Once we know we have a packet, go ahead and complete

#ifdef HOST
	fprintf(stdout, "header: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
			header[0], header[1], header[2], header[3],
			header[4], header[5], header[6], header[7],
			header[8], header[9], header[10], header[11]);
#endif

	uint32_t crc = crc32(0, header, 8); // Calculate checksum over preamble and size
	uint32_t crc_e =
			header[8] |
			(header[9] << 8) |
			(header[10] << 16) |
			(header[11] << 24)
			;
	uint32_t payload_sz =
			header[4] |
			(header[5] << 8) |
			(header[6] << 16) |
			(header[7] << 24)
			;

#ifdef HOST
	fprintf(stdout, "recv: crc=0x%08x payload_sz=%d\n", crc, payload_sz);
#endif
	debug("Receiving payload");

	msg = alloc_msg();

	if (crc == crc_e) {
		// Proceed to receive data
		uint32_t payload_remaining = payload_sz + 4;
		while (payload_remaining > 0) {
			uint32_t rd_sz = (payload_remaining > sizeof(tmp))?sizeof(tmp):payload_remaining;
			int32_t ret;

			if ((ret = read(tmp, rd_sz)) != -1) {
				msg->append(tmp, ret);
				payload_remaining -= ret;
			} else {
				// Error
				return 0;
			}
		}

		uint8_t *data = msg->data();
		uint32_t dsize = msg->size();
		uint32_t p_crc = crc32(0, data, dsize-4);
		uint32_t p_crc_e =
				data[dsize-4] |
				(data[dsize-3] << 8) |
				(data[dsize-2] << 16) |
				(data[dsize-1] << 24)
				;
#ifdef HOST
		fprintf(stdout, "RECV: payload CRC=0x%08x\n", p_crc);
#endif

		if (p_crc != p_crc_e) {
			// Error
#ifdef HOST
			fprintf(stdout, "recv: data checksum error 0x%08x 0x%08x\n", p_crc, p_crc_e);
#endif
			msg->set_checksum_err(true);
		} else {
			// Truncate size to remove header
			msg->set_size(msg->size()-4);
		}
	} else {
		// Error
		msg->set_checksum_err(true);
#ifdef HOST
		fprintf(stdout, "recv: header checksum error 0x%08x 0x%08x\n", crc, crc_e);
#endif
	}

	return msg;
}

void ulink::send_msg(ulink_msg *msg)
{
	uint8_t header[12] = {0x55, 0xAA, 0xEA, 0xAE};

	header[4] = msg->size();
	header[5] = (msg->size() >> 8);
	header[6] = (msg->size() >> 16);
	header[7] = (msg->size() >> 24);

	uint32_t crc = crc32(0, header, 8);
	header[8] = crc;
	header[9] = (crc >> 8);
	header[10] = (crc >> 16);
	header[11] = (crc >> 24);

#ifdef HOST
	fprintf(stdout, "SEND: header CRC=0x%08x\n", crc);
#endif

	write(header, 12);

	write(msg->data(), msg->size());

	crc = crc32(0, msg->data(), msg->size());
#ifdef HOST
	fprintf(stdout, "SEND: payload CRC=0x%08x\n", crc);
#endif
	header[0] = crc;
	header[1] = (crc >> 8);
	header[2] = (crc >> 16);
	header[3] = (crc >> 24);

	write(header, 4); // checksum
}

ulink_msg *ulink::alloc_msg()
{
	return new ulink_msg();
}

void ulink::release_msg(ulink_msg *msg)
{
	delete msg;
}

int32_t ulink::read_exact(uint8_t *buf, uint32_t sz, int32_t timeout)
{
	uint32_t idx = 0;
	uint32_t tmp_sz = sz;
	int32_t ret;

	while (idx < sz && (ret = read(&buf[idx], tmp_sz, timeout)) != -1) {
		tmp_sz -= ret;
		idx += ret;

		if (ret == 0) {
			return 0;
		}
	}

	return sz;
}

