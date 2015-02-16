/*
 * svf_stdio_msg_renderer.h
 *
 *  Created on: Feb 15, 2015
 *      Author: ballance
 */

#ifndef SVF_STDIO_MSG_RENDERER_H_
#define SVF_STDIO_MSG_RENDERER_H_

#include "svf_msg_renderer_if.h"
#include "svf_string.h"
#include "svf_log_server.h"
#include <stdio.h>

class svf_stdio_msg_renderer: public svf_msg_renderer_if {

	public:
		svf_stdio_msg_renderer();

		void init(FILE *fd, svf_log_server *svr);

		virtual ~svf_stdio_msg_renderer();

		virtual svf_log_msg_if *alloc_msg();

		virtual void msg(svf_log_msg_if *msg);

	private:

		static const uint32_t		PAD_ZERO  = (1 << 0);
		static const uint32_t		PAD_RIGHT = (1 << 1);

		void prints(svf_string &str, const char *string, int32_t width, int32_t pad);
		void printi(svf_string &str, int32_t val, bool sv, uint32_t base, int32_t width, int32_t pad, char hexbase);


	private:
		FILE						*m_fd;
		svf_log_server				*m_svr;
};

#endif /* SVF_STDIO_MSG_RENDERER_H_ */
