/*
 * wb_uart_bringup_test.cpp
 *
 *  Created on: Jan 19, 2014
 *      Author: ballance
 */

#include "wb_uart_bringup_test.h"

wb_uart_bringup_test::wb_uart_bringup_test(const char *name) : wb_uart_test_base(name) {
	// TODO Auto-generated constructor stub

}

wb_uart_bringup_test::~wb_uart_bringup_test() {
	// TODO Auto-generated destructor stub
}

void wb_uart_bringup_test::start() {
	m_run_thread.init(this, &wb_uart_bringup_test::run);
	m_run_thread.start();
}

void wb_uart_bringup_test::run() {
	int ch;

	raise_objection();

	m_env->m_m0->write32(8, (1 << 4)); // enable fifo

	for (uint32_t i=0; i<64; i++) {
		m_env->m_m0->write32(0, (i+1));

		ch = m_env->m_uart->getc();
		fprintf(stdout, "ch=%d\n", ch);
	}

	drop_objection();
}

svf_test_ctor_def(wb_uart_bringup_test)

