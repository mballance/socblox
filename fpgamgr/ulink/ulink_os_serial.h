/*
 * ulink_os_serial.h
 *
 *  Created on: Jan 4, 2015
 *      Author: ballance
 */

#ifndef ULINK_OS_SERIAL_H_
#define ULINK_OS_SERIAL_H_

#include "ulink.h"
#include <stdint.h>
#include <string>

using namespace std;

class ulink_os_serial: public ulink {

	public:

		ulink_os_serial(
				const char	*dev,
				uint32_t	baud);

		virtual ~ulink_os_serial();

		virtual bool connect();

		virtual bool wait_connection();

		// Client API
	public:

		virtual int32_t configure_fpga(uint8_t *data, uint32_t sz);


	protected:
		virtual int32_t read(uint8_t *buf, uint32_t sz, int32_t timeout=-1);

		virtual int32_t write(uint8_t *buf, uint32_t sz);

	public:
		virtual void debug(const char *msg);

	private:
		string				m_dev;
		uint32_t			m_baud;
		int32_t				m_fd;

};

#endif /* ULINK_OS_SERIAL_H_ */
