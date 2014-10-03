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

		enum param_t {
			u8,
			u16,
			u32,
			u64,
			cvoid,
			cchar
		};

		union param_u {
			uint8_t			u8;
			uint16_t		u16;
			uint32_t		u32;
			uint64_t		u64;
			const void		*cvoid;
			const char		*cchar;
		};

		virtual ~svf_log_msg_if() {}

		virtual void init(svf_msg_def_base *msg, uint32_t n_params) = 0;

		virtual int param(uint32_t p) = 0;

		virtual int param(int32_t p) = 0;

		virtual int param(const char *p) = 0;

		virtual int param(const void *p) = 0;

};


#endif /* SVF_LOG_MSG_IF_H_ */
