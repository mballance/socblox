/*
 * ulink_hps_uart.cpp
 *
 *  Created on: Jan 7, 2015
 *      Author: ballance
 */

#include "ulink_hps_uart.h"
#include "alt_fpga_manager.h"
#include <string.h>

ulink_hps_uart::ulink_hps_uart() {
	m_tx_int_enabled = false;
}

bool ulink_hps_uart::init(ALT_16550_DEVICE_e dev, uint32_t baud)
{
	ALT_STATUS_CODE status;
	ALT_INT_INTERRUPT_t uart_int_id = ALT_INT_INTERRUPT_UART0;
	uint32_t int_target = 0;

    alt_int_global_init();
    alt_int_cpu_init();
    alt_int_cpu_enable();
    alt_int_global_enable();

	m_handle.device = dev;
	m_handle.location = 0;
	m_handle.clock_freq = 0;

    status = alt_16550_init(
    		m_handle.device,
    		m_handle.location,
    		m_handle.clock_freq,
    		&m_handle);

    status = alt_16550_line_config_set(&m_handle, ALT_16550_DATABITS_8,
                                               ALT_16550_PARITY_DISABLE,
                                               ALT_16550_STOPBITS_1);

    status = alt_16550_baudrate_set(&m_handle, baud);

    alt_16550_fifo_enable(&m_handle);
    alt_16550_fifo_trigger_set_rx(&m_handle, ALT_16550_FIFO_TRIGGER_RX_HALF_FULL);
    alt_16550_fifo_trigger_set_tx(&m_handle, ALT_16550_FIFO_TRIGGER_TX_QUARTER_FULL);

    alt_16550_int_enable_rx(&m_handle);
//    alt_16550_int_enable_line(&handle);

    alt_int_isr_register(uart_int_id, &ulink_hps_uart::interrupt_cb, this);

    if (uart_int_id >= 32) {
    	if (int_target == 0) {
    		int_target = (1 << alt_int_util_cpu_count())-1;
    	}
    	alt_int_dist_target_set(uart_int_id, int_target);
    }

    alt_int_dist_enable(uart_int_id);

    status = alt_16550_enable(&m_handle);

//	alt_16550_fifo_write(&handle, &msg[idx++], 1);
//	alt_16550_int_enable_tx(&handle);
}

ulink_hps_uart::~ulink_hps_uart() {
	// TODO Auto-generated destructor stub
}

bool ulink_hps_uart::wait_connection() {

	ulink_msg *msg;

	while ((msg = recv_msg())) {
		uint8_t req_id = msg->read8();
		msg->seek(0);

		process_message(msg);

		if (req_id == ULINK_MSG_CONN_REQ) {
			return true;
		}
	}

	return false;
}

int32_t ulink_hps_uart::configure_fpga(uint8_t *data, uint32_t sz) {
	ALT_STATUS_CODE ret = alt_fpga_configure(data, sz);
	return ret;
}

int32_t ulink_hps_uart::write(uint8_t *data, uint32_t sz) {
	uint8_t tmp[16];
	int32_t ret = m_tx_buffer.write(data, sz);

	if (!m_tx_int_enabled) {
		// First, write something to the buffer
		uint32_t fifo_level_tx;
		uint32_t fifo_size_tx;

		alt_16550_fifo_size_get_tx(&m_handle, &fifo_size_tx);
		alt_16550_fifo_level_get_tx(&m_handle, &fifo_level_tx);

		uint32_t read_sz = ((fifo_size_tx-fifo_level_tx) < 16)?
				(fifo_size_tx-fifo_level_tx):16;

		read_sz = m_tx_buffer.read(tmp, read_sz);
		alt_16550_fifo_write(&m_handle, (char *)tmp, read_sz);

		// Now, enable the TX interrupt to handle the rest
		m_tx_int_enabled = true;
		alt_16550_int_enable_tx(&m_handle);
	}

	return ret;
}

int32_t ulink_hps_uart::read(uint8_t *data, uint32_t sz, int32_t timeout) {
	int32_t ret;

	while ((ret = m_rx_buffer.read(data, sz)) == 0) {
		;
	}

	return ret;
}

void ulink_hps_uart::interrupt_cb(uint32_t icciar, void *handle_v)
{
	static_cast<ulink_hps_uart *>(handle_v)->interrupt_cb(icciar);
}

void ulink_hps_uart::interrupt_cb(uint32_t icciar)
{
	ALT_16550_INT_STATUS_t int_status;
	alt_16550_int_status_get(&m_handle, &int_status);

	switch (int_status) {
		case ALT_16550_INT_STATUS_RX_DATA:
		case ALT_16550_INT_STATUS_RX_TIMEOUT: {
			uint32_t fifo_level_rx;
			while (true) {
				alt_16550_fifo_level_get_rx(&m_handle, &fifo_level_rx);
				if (fifo_level_rx > 0) {
					if (fifo_level_rx > sizeof(m_tmp)) {
						fifo_level_rx = sizeof(m_tmp);
					}
					alt_16550_fifo_read(&m_handle, (char *)m_tmp, fifo_level_rx);
					m_rx_buffer.write(m_tmp, fifo_level_rx);
				} else {
					break;
				}
			}
			} break;

		case ALT_16550_INT_STATUS_TX_IDLE: {
			uint32_t fifo_level_tx;
			uint32_t fifo_size_tx;
			uint32_t sz_written = 0;

			while (true) {
				alt_16550_fifo_size_get_tx(&m_handle, &fifo_size_tx);
				alt_16550_fifo_level_get_tx(&m_handle, &fifo_level_tx);

				uint32_t read_sz = ((fifo_size_tx-fifo_level_tx) < sizeof(m_tmp))?
						(fifo_size_tx-fifo_level_tx):sizeof(m_tmp);

				read_sz = m_tx_buffer.read(m_tmp, read_sz);
				sz_written += read_sz;

				if (read_sz > 0) {
					alt_16550_fifo_write(&m_handle, (char *)m_tmp, read_sz);
				} else {
					break;
				}
			}

			// If we have nothing left to write, then disable the
			// interrupt
			if (!sz_written) {
				alt_16550_int_disable_tx(&m_handle);
				m_tx_int_enabled = false;
			}
			} break;

		case ALT_16550_INT_STATUS_LINE:
			break;

	}
}

void ulink_hps_uart::debug(const char *msg) {
	m_tx_buffer.write((uint8_t *)msg, strlen(msg));
}
