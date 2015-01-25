/*
 * ulink_hps_uart.h
 *
 *  Created on: Jan 7, 2015
 *      Author: ballance
 */

#ifndef ULINK_HPS_UART_H_
#define ULINK_HPS_UART_H_
#include <stdint.h>
#include "ulink.h"
#include "hwlib.h"
#include "alt_16550_uart.h"
#include "alt_interrupt.h"
#include "ulink_buffer.h"

class ulink_hps_uart : public ulink {

	public:
		ulink_hps_uart();

		bool init(ALT_16550_DEVICE_e dev, uint32_t baud);

		virtual ~ulink_hps_uart();

		virtual bool connect() { return false; }

		virtual bool wait_connection();

		// Client API methods
	public:
		virtual int32_t configure_fpga(uint8_t *data, uint32_t sz);

	public:
		virtual int32_t read(uint8_t *data, uint32_t sz, int32_t timeout=-1);

		virtual int32_t write(uint8_t *data, uint32_t sz);

		virtual void debug(const char *msg);

	private:

		static void interrupt_cb(uint32_t icciar, void *handle_v);

		void interrupt_cb(uint32_t icciar);

	private:

		ALT_16550_HANDLE_t			m_handle;
		ulink_buffer				m_tx_buffer;
		ulink_buffer				m_rx_buffer;
		bool						m_tx_int_enabled;
		uint8_t						m_tmp[256];

};

#endif /* ULINK_HPS_UART_H_ */
