/*
 * svf_stdio_msg_renderer.cpp
 *
 *  Created on: Feb 15, 2015
 *      Author: ballance
 */

#include "svf_stdio_msg_renderer.h"
#include "svf_log_msg_if.h"
#include "svf_log_msg.h"

svf_stdio_msg_renderer::svf_stdio_msg_renderer() {
	m_fd = 0;
	m_svr = 0;
}

svf_stdio_msg_renderer::~svf_stdio_msg_renderer() {
	// TODO Auto-generated destructor stub
}

void svf_stdio_msg_renderer::init(FILE *fd, svf_log_server *svr) {
	m_fd = fd;
	m_svr = svr;
}

svf_log_msg_if *svf_stdio_msg_renderer::alloc_msg() {
	svf_log_msg *ret = new svf_log_msg();
	return ret;
}

void svf_stdio_msg_renderer::msg(svf_log_msg_if *msg_if) {
	svf_string str;
	svf_log_msg *msg = static_cast<svf_log_msg *>(msg_if);
	svf_log_msg_it it = msg->iterator();
	const char *fmt = msg->fmt();
	svf_log_msg_if::param_t pt;
	svf_log_msg_if::param_u pv;

	for (; *fmt; fmt++) {
		if (*fmt == '%') {
			fmt++;
			uint32_t width = 0, pad = 0;

			if (*fmt == '\0') {
				break;
			}
			if (*fmt == '%') {
				str.append('%');
				continue;
			}
			if (*fmt == '-') {
				++fmt;
				pad = PAD_RIGHT;
			}
			while (*fmt == '0') {
				++fmt;
				pad |= PAD_ZERO;
			}

			while (*fmt >= '0' && *fmt <= '9') {
				width *= 10;
				width += *fmt - '0';
				fmt++;
			}

			it.next(pt, pv);
			switch (*fmt) {
				case 's': {
					if (pt != svf_log_msg_if::cchar) {
						// Error;
					}
					prints(str, pv.cchar, width, pad);
					} break;
				case 'd': printi(str, pv.u32, true, 10, width, pad, 'a'); break;
				case 'x': printi(str, pv.u32, true, 16, width, pad, 'a'); break;
				case 'X': printi(str, pv.u32, true, 16, width, pad, 'A'); break;
				case 'u': printi(str, pv.u32, true, 10, width, pad, 'a'); break;
				case 'c': str.append(pv.u32); break;
				default: break;
			}
		} else {
			str.append(*fmt);
		}
	}

	str.append('\n');
	fputs(str.c_str(), m_fd);
	fflush(m_fd);

	delete msg;
}
#undef ensure_space

void svf_stdio_msg_renderer::prints(svf_string &str, const char *string, int32_t width, int32_t pad) {
	int padchar=' ';

	if (width > 0) {
		int32_t len = 0;
		for (const char *ptr=string; *ptr; ptr++) {
			len++;
		}
		if (len >= width) {
			width = 0;
		} else {
			width -= len;
		}
		if (pad & PAD_ZERO) {
			padchar = '0';
		}
	}
	if (!(pad & PAD_RIGHT)) {
		for (; width>0; width--) {
			str.append(padchar);
		}
	}
	while (*string) {
		str.append(*string);
		string++;
	}
	while (width > 0) {
		str.append(padchar);
		width--;
	}
}

void svf_stdio_msg_renderer::printi(svf_string &str, int32_t val, bool sv, uint32_t base, int32_t width, int32_t pad, char hexbase) {
	char buf[64];
    char *s = buf + sizeof(buf)-1;
    int t, pc = 0;
    bool neg = false;
    uint32_t u = val;

    if (val == 0) {
    	buf[0] = '0';
    	buf[1] = 0;
    	prints (str, buf, width, pad);
    	return;
    }

    if (sv && base == 10 && val < 0) {
    	neg = 1;
    	u = (uint32_t)val;
    }

    *s = 0;

    while (u) {
       if (base == 16 ) {
    	   t = u & 0xf;                  /* hex modulous */
       } else {
    	   t = u % base; // - ( _div (u, base) * base );  /* Modulous */
       }
//       else              t = u - ( _div (u, base) * base );  /* Modulous */

       if( t >= 10 ) {
    	   t += hexbase - '0' - 10;
       }
       *--s = t + '0';

       if (base == 16) {
    	   u = u >> 4;    /* divide by 16 */
       } else {
    	   u = (u / base);
       }
    }

    if (neg) {
       if( width && (pad & PAD_ZERO) ) {
          /* _outbyte('-'); */
          str.append('-');
          --width;
       }
       else {
          *--s = '-';
       }
    }

    prints(str, s, width, pad);
}
