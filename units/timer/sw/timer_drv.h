/*
 * timer_drv.h
 *
 *  Created on: Apr 4, 2014
 *      Author: ballance
 */

#ifndef TIMER_DRV_H_
#define TIMER_DRV_H_
#include <stdint.h>

class timer_drv {

	public:
	struct timer {
		uint32_t			load;
		uint32_t			value;
		uint32_t			ctrl;
		uint32_t			clr;
	};

	public:
		timer_drv();

		virtual ~timer_drv();

		void init(void *base);

		void set_load(uint32_t t, uint16_t load);
		void set_enable(uint32_t t, bool en);
		void set_periodic(uint32_t t, bool en);
		void set_scaling(uint32_t t, uint8_t scale);
		void clr(uint32_t t);

	private:
		void				*m_base;
		volatile timer		*m_timers;
};

#endif /* TIMER_DRV_H_ */
