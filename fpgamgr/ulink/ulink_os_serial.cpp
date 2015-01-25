/*
 * ulink_os_serial.cpp
 *
 *  Created on: Jan 4, 2015
 *      Author: ballance
 */

#include "ulink_os_serial.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <sys/select.h>


ulink_os_serial::ulink_os_serial(const char *dev, uint32_t baud) {
	m_dev = dev;
	m_baud = baud;
}

ulink_os_serial::~ulink_os_serial() {
	// TODO Auto-generated destructor stub
}

bool ulink_os_serial::connect()
{
	bool ret=false;

	// First, open the device
	if ((m_fd = open(m_dev.c_str(), O_RDWR|O_NOCTTY|O_NDELAY)) == -1) {
		fprintf(stdout, "Failed to open %s\n", m_dev.c_str());
		perror("open");
		return false;
	}

	struct termios options;

	tcgetattr(m_fd, &options);

	int spd = B921600;
	switch (m_baud) {
		case 115200: spd = B115200; break;
		case 921600: spd = B921600; break;
		default: fprintf(stdout, "Error: unknown baud rate\n");
	}

	cfsetispeed(&options, spd);
	cfsetospeed(&options, spd);

	options.c_cflag |= (CLOCAL | CREAD);
	options.c_cflag &= ~CSIZE;
	options.c_cflag |= CS8;
//	options.c_cflag |=
	tcsetattr(m_fd, TCSANOW, &options);
	fcntl(m_fd, F_SETFL, FNDELAY);

	char data[4096];
	uint32_t accum = 0;
	uint32_t st_t, end_t;

	while (true) {
		// TODO: send out message
		ulink_msg *msg = alloc_msg();
		msg->write8(ULINK_MSG_CONN_REQ);
		fprintf(stdout, "Send Data: ");
		for (uint32_t i=0; i<msg->size(); i++) {
			fprintf(stdout, "%02x ", msg->data()[i]);
		}
		fprintf(stdout, "\n");
		send_msg(msg);

		ulink_msg *rmsg = recv_msg(1000);

		if (rmsg) {
			fprintf(stdout, "Received message %d\n", rmsg->size());
			fprintf(stdout, "Data: ");
			for (uint32_t i=0; i<rmsg->size(); i++) {
				fprintf(stdout, "%02x ", rmsg->data()[i]);
			}
			fprintf(stdout, "\n");
			uint32_t ack = rmsg->read8();
			rmsg->seek(0);

			fprintf(stdout, "ack=%d\n", ack);
			if (ack == ULINK_MSG_CONN_ACK) {
				fprintf(stdout, "Received ACK\n");
				release_msg(rmsg);
				break;
			} else {
				process_message(rmsg);
			}
		} else {
			fprintf(stdout, "Timeout\n");
		}
	}

	fprintf(stdout, "Connected\n");

//	while (true) {
//		recv_msg(1000);
//	}
//
//	uint8_t data_tmp[] = {1, 2, 3, 4, 5, 6};
//	ulink_msg *msg = alloc_msg();
//	msg->append(data_tmp, sizeof(data_tmp));
//
//	for (uint32_t i=0; i<100; i++) {
////		send_msg(msg);
//		ulink_msg *tmp2 = recv_msg();
//		fprintf(stdout, "Receive %d\n", tmp2->size());
//		release_msg(tmp2);
//	}
//	while (true) {
//		int sz;
//		if ((sz = ::read(m_fd, data, sizeof(data))) == -1) {
//			if (errno == EAGAIN) {
//				continue;
//			}
//
//			fprintf(stdout, "Error: read %d\n", errno);
//			perror("read");
//			break;
//		} else {
//			fprintf(stdout, "sz=%d\n", sz);
//			for (int32_t i=0; i<sz; i++) {
//				fprintf(stdout, "%c", data[i]);
//			}
//			int ret = ::write(m_fd, data, sz);
//			fprintf(stdout, "ret=%d\n", ret);
//			if (ret == -1) {
//				perror("write");
//			}
////			fprintf(stdout, "CH=%c\n", ch);
//		}
//	}
//
//	close(m_fd);


	return ret;
}

bool ulink_os_serial::wait_connection()
{
	return false;
}

int32_t ulink_os_serial::configure_fpga(uint8_t *data, uint32_t sz) {
	ulink_msg *msg = alloc_msg();

	msg->write8(ULINK_MSG_CFG_FPGA_REQ);
	msg->append(data, sz);

	ulink_msg *rsp;

	while ((rsp = recv_msg()) != 0) {
		uint8_t code = rsp->read8();
		rsp->seek(0);

		if (code == ULINK_MSG_CFG_FPGA_ACK) {
			break;
		} else {
			process_message(rsp);
		}
	}

	if (rsp) {
		rsp->read8(); // code
		int32_t ret = (int32_t)rsp->read32();
		release_msg(rsp);
		return ret;
	} else {
		// How to respond?
		return -1;
	}
}

int32_t ulink_os_serial::read(uint8_t *buf, uint32_t sz, int32_t timeout)
{
	int32_t ret;

	if (timeout != -1) {
		fd_set rs;
		FD_ZERO(&rs);
		FD_SET(m_fd, &rs);

		timeval ts;
		ts.tv_sec = (timeout/1000);
		ts.tv_usec = (timeout%1000)*1000;

		ret = ::select(m_fd+1, &rs, 0, 0, &ts);

		fprintf(stdout, "select ret=%d\n", ret);

		if (ret <= 0) {
			return 0;
		}
	}

	while ((ret = ::read(m_fd, buf, sz)) == -1 &&
			errno == EAGAIN) {
		;
	}

	return ret;
}

int32_t ulink_os_serial::write(uint8_t *buf, uint32_t sz)
{
	int32_t ret;

	while ((ret = ::write(m_fd, buf, sz)) == -1 &&
			errno == EAGAIN) {
		;
	}

	if (ret == -1) {
		fprintf(stdout, "Error: errno=%d\n", errno);
		perror("write");
	}

#ifdef HOST
	if (ret != sz) {
		fprintf(stdout, "ERROR: write %d bytes instead of %d\n", ret, sz);
	}
#endif

	return ret;
}

void ulink_os_serial::debug(const char *msg) {
	fprintf(stdout, msg);
	fprintf(stdout, "\n");
}

