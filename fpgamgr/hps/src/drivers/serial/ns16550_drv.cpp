/*
 * ns16550_drv.cpp
 *
 *  Created on: Jan 21, 2015
 *      Author: ballance
 */

#include "ns16550_drv.h"

#define UART_LSR_DR     0x01            /* Data ready */
#define UART_LSR_OE     0x02            /* Overrun */
#define UART_LSR_PE     0x04            /* Parity error */
#define UART_LSR_FE     0x08            /* Framing error */
#define UART_LSR_BI     0x10            /* Break */
#define UART_LSR_THRE   0x20            /* Xmit holding register empty */
#define UART_LSR_TEMT   0x40            /* Xmitter empty */
#define UART_LSR_ERR    0x80            /* Error */

ns16550_drv::ns16550_drv(void *base_addr) {
	// TODO Auto-generated constructor stub

	m_uart = (uart_t *)base_addr;
}

ns16550_drv::~ns16550_drv() {
	// TODO Auto-generated destructor stub
}

int32_t ns16550_drv::write(const void *data, uint32_t sz) {
	for (uint32_t j=0; j<sz; j++) {
		while (!(m_uart->lsr & (UART_LSR_THRE|UART_LSR_TEMT))) { ; }

		if (data[j] == '\n') {
			m_uart->rbr = '\r';
			while (!(m_uart->lsr & (UART_LSR_THRE|UART_LSR_TEMT))) { ; }
		}

		m_uart->rbr = data[j];
	}

	return sz;
}

int32_t ns16550_drv::read(const void *data, uint32_t sz) {
	return 0;
}

