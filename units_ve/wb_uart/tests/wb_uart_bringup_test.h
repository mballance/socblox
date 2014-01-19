/*
 * wb_uart_bringup_test.h
 *
 *  Created on: Jan 19, 2014
 *      Author: ballance
 */

#ifndef WB_UART_BRINGUP_TEST_H_
#define WB_UART_BRINGUP_TEST_H_
#include "wb_uart_test_base.h"

class wb_uart_bringup_test : public wb_uart_test_base {
	svf_test_ctor_decl(wb_uart_bringup_test)

	public:
		wb_uart_bringup_test(const char *name);

		virtual ~wb_uart_bringup_test();

		virtual void start();

		void run();

	private:
		svf_thread					m_run_thread;
};

#endif /* WB_UART_BRINGUP_TEST_H_ */
