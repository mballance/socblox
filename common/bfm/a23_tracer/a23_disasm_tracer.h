/*
 * a23_disasm_tracer.h
 *
 *  Created on: Mar 2, 2014
 *      Author: ballance
 */

#ifndef A23_DISASM_TRACER_H_
#define A23_DISASM_TRACER_H_
#include "a23_tracer_if.h"
#include "svf.h"
#include <stdio.h>

class a23_disasm_tracer : public virtual a23_tracer_if {

	public:
		svf_api_export<a23_tracer_if>			port;

	public:

		a23_disasm_tracer(FILE *fp);

		virtual ~a23_disasm_tracer();

		virtual void mem_access(
				uint32_t			addr,
				bool				is_write,
				uint32_t			data);

		virtual void execute(
				uint32_t			addr,
				uint32_t			op
				);

		virtual void regchange(
				uint32_t			reg,
				uint32_t			val
				);

	private:
		const char *warmreg(uint32_t regnum);

	private:
		uint32_t					m_regs[32];
		FILE						*m_fp;
};

#endif /* A23_DISASM_TRACER_H_ */
