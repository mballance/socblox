/*
 * axi4_master_bfm.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "axi4_master_bfm.h"

axi4_master_bfm::axi4_master_bfm(const char *name, svf_component *parent) :
		svf_component(name, parent),
		master_export(this),
		bfm_port(this),
		m_init_reset(false) {
	m_ar_id = 0;
	m_aw_id = 0;
	m_cache = 0;

}

axi4_master_bfm::~axi4_master_bfm() {
	// TODO Auto-generated destructor stub
}

void axi4_master_bfm::start()
{
	if (!bfm_port.consumes()) {
		fprintf(stdout, "Error: axi4_master_bfm %s is not connected\n", m_name.c_str());
	}
	// Retrieve the parameters
	bfm_port.consumes()->get_parameters(&ADDRESS_WIDTH, &DATA_WIDTH, &ID_WIDTH);
	fprintf(stdout, "ADDRESS_WIDTH=%d\n", ADDRESS_WIDTH);
}

void axi4_master_bfm::wait_for_reset()
{
	fprintf(stdout, "--> wait_for_reset %p\n", this);
	while (!m_init_reset) {
		m_reset_cond_mutex.lock();
		m_reset_cond.wait(m_reset_cond_mutex);
		m_reset_cond_mutex.unlock();
	}
	fprintf(stdout, "<-- wait_for_reset %p\n", this);
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

	if (!m_init_reset) {
		wait_for_reset();
	}

	m_write_mutex.lock();
	id = m_aw_id;

	m_aw_mutex.lock();

	// Pack the data
	for (uint32_t i=0; i<=burst_len; i++) {
		// TODO: must deal with complexities
		bfm_port()->set_data(i, data[i]);
	}

	bfm_port()->aw_valid(
			addr,
			m_aw_id, 		// AWID
			burst_len, 		// AWLEN
			burst_size, 	// AWSIZE
			burst_type, 	// AWBURST
			m_cache, 		// AWCACHE
			0, 				// AWPROT
			0, 				// AWQOS
			0  				// AWREGION
			);

	m_aw_id = ((m_aw_id + 1) % (1 << ID_WIDTH));

	m_bresp_sem.get(); // Wait for acknowledge of the AW phase

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
	uint32_t id;

	if (!m_init_reset) {
		wait_for_reset();
	}

	m_read_mutex.lock();

	id = m_ar_id;

	bfm_port->ar_valid(
			addr,
			m_ar_id,
			burst_len,
			burst_size,
			burst_type,
			m_cache,			// cache
			0,					// prot
			0					// region
			);

	m_ar_id = ((m_ar_id + 1) % (1 << ID_WIDTH));

	m_rresp_sem.get();

	for (uint32_t i=0; i<=burst_len; i++) {
		// TODO: must be more complex
		bfm_port()->get_data(i, &data[i]);
	}

	m_read_mutex.unlock();
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
	uint8_t resp;
	uint32_t data;
	read(addr, AXI4_BURST_SIZE_32, 0, &data, resp, AXI4_BURST_TYPE_FIXED);
	return data;
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
	uint8_t resp;
	write(addr, AXI4_BURST_SIZE_32, 0, &data, resp, AXI4_BURST_TYPE_FIXED);
}

void axi4_master_bfm::write64(uint64_t addr, uint64_t data)
{

}

void axi4_master_bfm::wait_clks(uint32_t clks)
{
	m_mutex.lock();

	for (uint32_t i=0; i<clks; i++) {
		bfm_port->clk_req();
		m_clk_sem.get();
	}

	m_mutex.unlock();
}

void axi4_master_bfm::bresp(uint32_t resp)
{
	m_bresp_sem.put();
}

void axi4_master_bfm::aw_ready()
{
	m_aw_sem.put();
}

void axi4_master_bfm::rresp(uint32_t resp)
{
	m_rresp_sem.put();
}

void axi4_master_bfm::reset()
{
	fprintf(stdout, "reset %p\n", this);
	m_reset_cond_mutex.lock();
	m_init_reset = true;
	m_reset_cond.notify_all();
	m_reset_cond_mutex.unlock();
}

void axi4_master_bfm::clk_ack()
{
	m_clk_sem.put();
}

void axi4_master_bfm::set_cache(uint32_t cache)
{
	m_cache = cache;
}

svf_component_ctor_def(axi4_master_bfm)


