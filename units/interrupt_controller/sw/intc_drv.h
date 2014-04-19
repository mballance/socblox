/*
 * intc_drv.h
 *
 *  Created on: Apr 19, 2014
 *      Author: ballance
 */

#ifndef INTC_DRV_H_
#define INTC_DRV_H_
#include <stdint.h>

class intc_drv {
	struct irq_src_regs {
		uint32_t		enableset;
		uint32_t		enableclr;
		uint32_t		rawstat;
		uint32_t		status;
	};

	struct irq_regs {
		irq_src_regs	irq0;
		irq_src_regs	firq0;
		irq_src_regs	irq1;
		irq_src_regs	firq1;
		uint32_t		softset;
		uint32_t		softclr;
	};

	public:

		intc_drv();

		virtual ~intc_drv();

		void init(void *base);

	private:

		volatile irq_regs			*m_regs;
};

#endif /* INTC_DRV_H_ */
