/*
 * a23_unicore_sys_smoke_test.h
 *
 *  Created on: Jan 28, 2014
 *      Author: ballance
 */

#ifndef A23_UNICORE_SYS_SMOKE_TEST_H_
#define A23_UNICORE_SYS_SMOKE_TEST_H_
#include "a23_unicore_sys_test_base.h"
#include "a23_disasm_tracer.h"

class a23_unicore_sys_smoke_test : public a23_unicore_sys_test_base,
	public a23_tracer_if {

	svf_test_ctor_decl(a23_unicore_sys_smoke_test)

	svf_api_export<a23_tracer_if>			tracer_port;

	public:
		a23_unicore_sys_smoke_test(const char *name);

		virtual ~a23_unicore_sys_smoke_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void shutdown();

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
		a23_disasm_tracer			*m_tracer;
		FILE						*m_trace_file;


};

#endif /* A23_UNICORE_SYS_SMOKE_TEST_H_ */
