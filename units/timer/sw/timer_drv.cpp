/*
 * timer_drv.cpp
 *
 *  Created on: Apr 4, 2014
 *      Author: ballance
 */

#include "timer_drv.h"

timer_drv::timer_drv() {
	// TODO Auto-generated constructor stub

}

void timer_drv::init(void *base)
{
	m_timers = (timer *)base;
	m_base = base;
}

timer_drv::~timer_drv() {
	// TODO Auto-generated destructor stub
}

void timer_drv::set_load(uint32_t t, uint16_t load)
{
	if (t > 2) {
		return;
	}
	(&m_timers[t])->load = load;
}

void timer_drv::set_enable(uint32_t t, bool en)
{
	if (t > 2) {
		return;
	}
	if (en) {
		(&m_timers[t])->ctrl |= 0x80;
	} else {
		(&m_timers[t])->ctrl &= ~0x80;
	}
}

void timer_drv::set_periodic(uint32_t t, bool en)
{
	if (t > 2) {
		return;
	}
	if (en) {
		(&m_timers[t])->ctrl |= 0x40;
	} else {
		(&m_timers[t])->ctrl &= ~0x40;
	}
}

void timer_drv::set_scaling(uint32_t t, uint8_t scale)
{
	volatile timer *tt;
	if (t > 2) {
		return;
	}

	tt = &m_timers[t];

	tt->ctrl = (tt->ctrl & ~0x0c) | ((scale & 3) << 2);
}

void timer_drv::clr(uint32_t t)
{
	if (t > 2) {
		return;
	}

	m_timers[t].clr = 1;
}

