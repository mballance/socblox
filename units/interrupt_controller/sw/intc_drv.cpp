/*
 * intc_drv.cpp
 *
 *  Created on: Apr 19, 2014
 *      Author: ballance
 */

#include "intc_drv.h"

intc_drv::intc_drv() {
	// TODO Auto-generated constructor stub

}

intc_drv::~intc_drv() {
	// TODO Auto-generated destructor stub
}

void intc_drv::init(void *base)
{
	m_regs = (irq_regs *)base;

	m_regs->irq0.enableset = 0xFFFF0000;
}

