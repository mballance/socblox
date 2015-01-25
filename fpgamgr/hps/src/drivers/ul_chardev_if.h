/*
 * ul_chardev_if.h
 *
 *  Created on: Jan 21, 2015
 *      Author: ballance
 */

#ifndef UL_CHARDEV_IF_H_
#define UL_CHARDEV_IF_H_
#include <stdint.h>

class ul_chardev_if {

	public:
		virtual ~ul_chardev_if() {}

		virtual int32_t write(const void *data, uint32_t sz) = 0;

		virtual int32_t read(const void *data, uint32_t sz) = 0;

};



#endif /* UL_CHARDEV_IF_H_ */
