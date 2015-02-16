/*
 * svf_msg_renderer_if.h
 *
 *  Created on: Feb 15, 2015
 *      Author: ballance
 */

#ifndef SVF_MSG_RENDERER_IF_H_
#define SVF_MSG_RENDERER_IF_H_

class svf_log_msg_if;
class svf_msg_renderer_if {

	public:

		virtual ~svf_msg_renderer_if() {}

		virtual svf_log_msg_if *alloc_msg() = 0;

		virtual void msg(svf_log_msg_if *msg) = 0;
};


#endif /* SVF_MSG_RENDERER_IF_H_ */
