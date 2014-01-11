/*
 * wb_master_if.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef WB_MASTER_IF_H_
#define WB_MASTER_IF_H_
#include "svf_mem_if.h"

class wb_master_if : public virtual svf_mem_if {

	public:

		virtual ~wb_master_if() { }
};


#endif /* WB_MASTER_IF_H_ */
