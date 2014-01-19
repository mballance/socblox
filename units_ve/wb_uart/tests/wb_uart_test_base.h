/*
 * wb_uart_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_TEST_BASE_H_
#define WB_2X2_TEST_BASE_H_
#include "svf.h"
#include "wb_uart_env.h"

class wb_uart_test_base : public svf_test {
	svf_test_ctor_decl(wb_uart_test_base)

	public:
		wb_uart_test_base(const char *name);

		virtual ~wb_uart_test_base();

		virtual void build();

		virtual void connect();

		virtual void shutdown();

	protected:

		wb_uart_env				*m_env;
};

#endif /* WB_2X2_TEST_BASE_H_ */
