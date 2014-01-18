/*
 * wb_master_bfm.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include "wb_master_bfm.h"

wb_master_bfm::wb_master_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(this)  {
	// TODO Auto-generated constructor stub
	m_reset_received = false;

}

wb_master_bfm::~wb_master_bfm() {
	// TODO Auto-generated destructor stub
}

void wb_master_bfm::write32(uint64_t addr, uint32_t data)
{
	m_access_mutex.lock();

	if (!m_reset_received) {
		wait_for_reset();
	}

	bfm_port->set_data(0, data);
	bfm_port->request(addr, 0, 0, 0xF, 1);

	m_access_sem.get();

	m_access_mutex.unlock();
}

void wb_master_bfm::write16(uint64_t addr, uint16_t data)
{

}

void wb_master_bfm::write8(uint64_t addr, uint8_t data)
{

}

uint32_t wb_master_bfm::read32(uint64_t addr)
{
	uint32_t data;
	m_access_mutex.lock();

	if (!m_reset_received) {
		wait_for_reset();
	}

	bfm_port->request(addr, 0, 0, 0xF, 0);

	m_access_sem.get();

	bfm_port->get_data(0, &data);

	m_access_mutex.unlock();
	return data;
}

uint16_t wb_master_bfm::read16(uint64_t addr)
{
	return 0;
}

uint8_t wb_master_bfm::read8(uint64_t addr)
{
	return 0;
}

void wb_master_bfm::wait_for_reset()
{
	m_reset_sem.get();
}

void wb_master_bfm::reset()
{
	m_reset_received = true;
	m_reset_sem.put();
}

void wb_master_bfm::acknowledge(uint8_t ERR)
{
	m_access_sem.put();
}

svf_component_ctor_def(wb_master_bfm)
