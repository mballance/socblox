/*
 * ns16550_drv.h
 *
 *  Created on: Jan 21, 2015
 *      Author: ballance
 */

#ifndef NS16550_DRV_H_
#define NS16550_DRV_H_
#include "ul_chardev_if.h"

class ns16550_drv : public virtual ul_chardev_if {

	public:
		ns16550_drv(void *base_addr);

		virtual ~ns16550_drv();

		virtual int32_t write(const void *data, uint32_t sz);

		virtual int32_t read(const void *data, uint32_t sz);

	private:

		typedef struct uart_s {
			uint32_t	rbr;
			uint32_t	ier;
			uint32_t	iir;
		//	uint32_t	fcr;
			uint32_t	lcr;
			uint32_t	mcr;
			uint32_t	lsr;
			uint32_t	msr;
			uint32_t	spr;
		} uart_t;

		volatile uart_t				*m_uart;
};

#endif /* NS16550_DRV_H_ */
