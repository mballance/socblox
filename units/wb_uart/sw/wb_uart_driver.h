/*
 * wb_uart_driver.h
 *
 *  Created on: Mar 1, 2014
 *      Author: ballance
 */

#ifndef WB_UART_DRIVER_H_
#define WB_UART_DRIVER_H_
#include <stdint.h>

class wb_uart_driver {

	public:
		wb_uart_driver();

		virtual ~wb_uart_driver();

		int32_t init(void *addr);

		int32_t write(const void *buf, uint32_t count);

	private:

		struct uart_regs {
			volatile uint32_t			DR;
			volatile uint32_t			RSR;
			volatile uint32_t			LCRH;
			volatile uint32_t			LCRM;
			volatile uint32_t			LCRL;
			volatile uint32_t			CR;
			volatile uint32_t			FR;
			volatile uint32_t			IIR;
			volatile uint32_t			ICR;
		};

		uart_regs				*m_regs;
};

#endif /* WB_UART_DRIVER_H_ */
