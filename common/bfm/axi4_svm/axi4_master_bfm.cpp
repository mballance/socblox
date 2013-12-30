/*
 * axi4_master_bfm.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "axi4_master_bfm.h"

axi4_master_bfm::axi4_master_bfm(const char *name, svm_component *parent) :
		svm_component(name, parent),
		master_export(this),
		bfm_port(this) {
	m_ar_id = 0;
	m_aw_id = 0;

}

axi4_master_bfm::~axi4_master_bfm() {
	// TODO Auto-generated destructor stub
}

void axi4_master_bfm::start()
{
	// Retrieve the parameters
	bfm_port.consumes()->get_parameters(ADDRESS_WIDTH, DATA_WIDTH, ID_WIDTH);
}

void axi4_master_bfm::write(
		uint64_t				addr,
		axi4_burst_size_t		burst_size,
		uint32_t				burst_len,
		uint32_t				*data,
		uint8_t					&resp,
		axi4_burst_type_t		burst_type)
{
	uint32_t id;

	m_write_mutex.lock();
	id = m_aw_id;

	m_aw_mutex.lock();

	// Pack the data

	bfm_port()->aw_valid(
			addr,
			m_aw_id, // AWID
			0, // AWLEN
			0, // AWSIZE
			0, // AWBURST
			0, // AWCACHE
			0, // AWPROT
			0, // AWQOS
			0  // AWREGION
			);

	m_aw_id = ((m_aw_id + 1) % (1 << ID_WIDTH));

	m_aw_sem.get(); // Wait for acknowledge of the AW phase

	// TODO: data phase, etc

	m_aw_mutex.unlock();


	m_write_mutex.unlock();

}

void axi4_master_bfm::read(
		uint64_t				addr,
		axi4_burst_size_t		burst_size,
		uint32_t				burst_len,
		uint32_t				*data,
		uint8_t					&resp,
		axi4_burst_type_t		burst_type)
{

}

uint8_t axi4_master_bfm::read8(uint64_t addr)
{
	return 0;
}

uint16_t axi4_master_bfm::read16(uint64_t addr)
{
	return 0;
}

uint32_t axi4_master_bfm::read32(uint64_t addr)
{
	return 0;
}

uint64_t axi4_master_bfm::read64(uint64_t addr)
{
	return 0;
}

void axi4_master_bfm::write8(uint64_t addr, uint8_t data)
{

}

void axi4_master_bfm::write16(uint64_t addr, uint16_t data)
{

}

void axi4_master_bfm::write32(uint64_t addr, uint32_t data)
{

}

void axi4_master_bfm::write64(uint64_t addr, uint64_t data)
{

}

void axi4_master_bfm::bresp(uint32_t resp)
{

}

void axi4_master_bfm::aw_ready()
{
	m_aw_sem.put();
}

svm_component_ctor_def(axi4_master_bfm)


