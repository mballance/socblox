/*
 * timer_drv.h
 *
 *  Created on: Apr 4, 2014
 *      Author: ballance
 */

#ifndef TIMER_DRV_H_
#define TIMER_DRV_H_

class timer_drv {

	public:
		timer_drv();

		virtual ~timer_drv();

		void init(void *base);

	private:

		void				*m_base;
};

#endif /* TIMER_DRV_H_ */
