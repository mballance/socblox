/*
 * svf_log_msg_if.h
 *
 *  Created on: May 4, 2014
 *      Author: ballance
 */

#ifndef SVF_LOG_MSG_IF_H_
#define SVF_LOG_MSG_IF_H_

class svf_log_msg_if {

	public:

		virtual ~svf_log_msg_if() {}

		virtual void init(svf_msg_def_base *msg, uint32_t n_params);

		virtual int param(uint32_t p) = 0;

		virtual int param(int32_t p) = 0;

};


#endif /* SVF_LOG_MSG_IF_H_ */
