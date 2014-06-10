/*
 * svf_log_if.h
 *
 *  Created on: May 4, 2014
 *      Author: ballance
 */

#ifndef SVF_LOG_IF_H_
#define SVF_LOG_IF_H_
#include "svf_log_msg_if.h"

class svf_log_if {

	public:

		virtual ~svf_log_if() {}

		virtual svf_log_msg_if *alloc_msg() = 0;

		virtual void msg(svf_log_msg_if *msg) = 0;

};


#endif /* SVF_LOG_IF_H_ */
