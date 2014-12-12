/*
 * axi4_monitor_stream_logger.cpp
 *
 *  Created on: Oct 27, 2014
 *      Author: ballance
 */

#include "axi4_monitor_stream_logger.h"

axi4_monitor_stream_logger::axi4_monitor_stream_logger(
		const char 			*name,
		FILE 				*fp,
		timebase_target_if	*tb) :
	api_export(this), m_name(name), m_fp(fp), m_timebase(tb) {

	m_write_idx = 0;
	m_read_idx = 0;
}

axi4_monitor_stream_logger::~axi4_monitor_stream_logger() {
	// TODO Auto-generated destructor stub
}

void axi4_monitor_stream_logger::ar(
		uint32_t			araddr,
		uint32_t			arid,
		uint32_t			arlen,
		uint32_t			arsize,
		uint32_t			arburst,
		uint32_t			arlock,
		uint32_t			arcache,
		uint32_t			arprot,
		uint32_t			arqos,
		uint32_t			arregion) {
	m_araddr = araddr;
	m_arid = arid;
	m_arsize = arsize;
	m_ar_time = get_time();
	m_read_idx = 0;
//	fprintf(m_fp, "%s: AR 0x%08x ID=%02x\n", m_name.c_str(), araddr, arid);
//	fprintf(stdout, "LOGGER AR: 0x%08x\n", araddr);
}

void axi4_monitor_stream_logger::rdata(
		uint64_t			rdata,
		uint32_t			rid,
		uint32_t			rresp,
		uint32_t			rlast) {
//	fprintf(m_fp, "%s: RD 0x%08x\n", m_name.c_str(), rdata);
	m_read_data[m_read_idx++] = rdata;

	if (rlast) {
		fprintf(m_fp, "%s: READ  %lld-%lld ID=%d ADDR=0x%08x ",
				m_name.c_str(), m_ar_time, get_time(), rid, m_araddr);
		for (uint32_t i=0; i<m_read_idx; i++) {
			fprintf(m_fp, "RD=0x%08x ", m_read_data[i]);
		}
		fprintf(m_fp, " RESP=%02x\n", rresp);
	}
}

void axi4_monitor_stream_logger::aw(
		uint32_t			awaddr,
		uint32_t			awid,
		uint32_t			awlen,
		uint32_t			awsize,
		uint32_t			awburst,
		uint32_t			awlock,
		uint32_t			awcache,
		uint32_t			awprot,
		uint32_t			awqos,
		uint32_t			awregion) {
	m_awaddr = awaddr;
	m_awid = awid;
	m_awsize = awsize;
	m_aw_time = get_time();
	m_write_idx = 0;
//	fprintf(m_fp, "%s: AW 0x%08x ID=%02x\n", m_name.c_str(), awaddr, awid);
//	fprintf(stdout, "LOGGER AW: 0x%08x\n", awaddr);
//	*((uint32_t *)0) = 0;
}

void axi4_monitor_stream_logger::wdata(
		uint64_t			wdata,
		uint64_t			wstrb,
		uint32_t			wlast) {
	m_write_data[m_write_idx++] = wdata;
//	fprintf(m_fp, "%s: WD 0x%08x\n", m_name.c_str(), wdata);
}

void axi4_monitor_stream_logger::wresp(
		uint32_t			bid,
		uint32_t			bresp) {
	uint64_t end_time = get_time();

	fprintf(m_fp, "%s: WRITE %lld-%lld ID=%d ADDR=0x%08x ",
			m_name.c_str(), m_aw_time, end_time, bid, m_awaddr);
	for (uint32_t i=0; i<m_write_idx; i++) {
		fprintf(m_fp, "WD=0x%08x ", m_write_data[i]);
	}
	fprintf(m_fp, " RESP=%02x\n", bresp);

//	fprintf(m_fp, "%s: WR bid=%d\n", m_name.c_str(), bid);
}

uint64_t axi4_monitor_stream_logger::get_time()
{
	if (m_timebase) {
		uint64_t t;
		m_timebase->gettime(&t);
		return t;
	} else {
		return 0;
	}
}

