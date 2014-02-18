/*
 * a23_dualcore_sys_smoke_test.h
 *
 *  Created on: Jan 28, 2014
 *      Author: ballance
 */

#ifndef A23_DUALCORE_SYS_SMOKE_TEST_H_
#define A23_DUALCORE_SYS_SMOKE_TEST_H_
#include "a23_dualcore_sys_test_base.h"

class a23_dualcore_sys_smoke_test : public a23_dualcore_sys_test_base,
	public a23_tracer_if {

	svf_test_ctor_decl(a23_dualcore_sys_smoke_test)

	svf_api_export<a23_tracer_if>			tracer_port;

	public:
		a23_dualcore_sys_smoke_test(const char *name);

		virtual ~a23_dualcore_sys_smoke_test();

		virtual void connect();

		virtual void start();

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

};

#endif /* A23_DUALCORE_SYS_SMOKE_TEST_H_ */
