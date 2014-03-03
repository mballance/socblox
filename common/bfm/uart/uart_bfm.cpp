/*
 * uart_bfm.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include "uart_bfm.h"

uart_bfm::uart_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(this)  {
	// TODO Auto-generated constructor stub
	m_ch = -1;
}

uart_bfm::~uart_bfm() {
	// TODO Auto-generated destructor stub
}

void uart_bfm::putc(char ch)
{
	bfm_port->tx_start(ch);

	m_tx_sem.get();
}

int uart_bfm::getc()
{
	char ret;
	m_rx_mutex.lock();
	while (m_ch == -1) {
		m_rx_cond.wait(m_rx_mutex);
	}
	ret = m_ch;
	m_ch = -1;
	m_rx_mutex.unlock();

	return ret;
}

void uart_bfm::tx_done()
{
	m_tx_sem.put();
}

void uart_bfm::rx_done(uint8_t ch)
{
	m_rx_mutex.lock();
	m_ch = ch;
	ap(&uart_bfm_listener_if::getc, (int)ch);
	m_rx_cond.notify();
	m_rx_mutex.unlock();
}

svf_component_ctor_def(uart_bfm)
