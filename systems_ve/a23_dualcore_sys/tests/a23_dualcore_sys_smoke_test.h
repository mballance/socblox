/*
 * a23_dualcore_sys_smoke_test.h
 *
 *  Created on: Jan 28, 2014
 *      Author: ballance
 */

#ifndef A23_DUALCORE_SYS_SMOKE_TEST_H_
#define A23_DUALCORE_SYS_SMOKE_TEST_H_
#include "a23_dualcore_sys_test_base.h"

class a23_dualcore_sys_smoke_test : public a23_dualcore_sys_test_base {
	svf_test_ctor_decl(a23_dualcore_sys_smoke_test)

	public:
		a23_dualcore_sys_smoke_test(const char *name);

		virtual ~a23_dualcore_sys_smoke_test();

		virtual void connect();

		virtual void start();
};

#endif /* A23_DUALCORE_SYS_SMOKE_TEST_H_ */
