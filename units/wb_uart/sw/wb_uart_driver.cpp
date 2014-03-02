/*
 * wb_uart_driver.cpp
 *
 *  Created on: Mar 1, 2014
 *      Author: ballance
 */

#include "wb_uart_driver.h"

wb_uart_driver::wb_uart_driver() {
	// TODO Auto-generated constructor stub

}

wb_uart_driver::~wb_uart_driver() {
	// TODO Auto-generated destructor stub
}

int32_t wb_uart_driver::init(void *addr)
{
	m_regs = static_cast<uart_regs *>(addr);

	return 0;
}

int32_t wb_uart_driver::write(const void *buf, uint32_t count)
{
	const uint8_t *buf_c = static_cast<const uint8_t *>(buf);

	for (uint32_t i=0; i<count; i++) {
		// Spin, waiting for the Tx fifo to have space
		while ((m_regs->FR & 0x20) != 0) {
			;
		}

		m_regs->DR = buf_c[i];
	}

	return 0;
}

