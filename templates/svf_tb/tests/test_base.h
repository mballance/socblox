/*
 * ${name}_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef ${name}_TEST_BASE_H_
#define ${name}_TEST_BASE_H_
#include "svf.h"
#include "${name}_env.h"

class ${name}_test_base : public svf_test {
	svf_test_ctor_decl(${name}_test_base)

	public:
		${name}_test_base(const char *name);

		virtual ~${name}_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		${name}_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* ${name}_TEST_BASE_H_ */
