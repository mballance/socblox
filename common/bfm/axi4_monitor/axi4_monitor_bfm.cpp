/*
 * axi4_monitor_bfm.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "axi4_monitor_bfm.h"

axi4_monitor_bfm::axi4_monitor_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(this) {
	// TODO Auto-generated constructor stub

}

axi4_monitor_bfm::~axi4_monitor_bfm() {
	// TODO Auto-generated destructor stub
}

void axi4_monitor_bfm::ar(
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
//	fprintf(stdout, "BFM AR: 0x%08x\n", araddr);
//	fflush(stdout);
	ap(&axi4_monitor_bfm_host_if::ar, araddr, arid, arlen, arsize, arburst,
			arlock, arcache, arprot, arqos, arregion);
}

void axi4_monitor_bfm::rdata(
		uint64_t			rdata,
		uint32_t			rid,
		uint32_t			rresp,
		uint32_t			rlast) {
	ap(&axi4_monitor_bfm_host_if::rdata, rdata, rid, rresp, rlast);
}

void axi4_monitor_bfm::aw(
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
//	fprintf(stdout, "BFM AW: 0x%08x\n", awaddr);
//	fflush(stdout);
	ap(&axi4_monitor_bfm_host_if::aw, awaddr, awid, awlen, awsize, awburst,
			awlock, awcache, awprot, awqos, awregion);
}

void axi4_monitor_bfm::wdata(
		uint64_t			wdata,
		uint64_t			wstrb,
		uint32_t			wlast) {
	ap(&axi4_monitor_bfm_host_if::wdata, wdata, wstrb, wlast);
}

void axi4_monitor_bfm::wresp(
		uint32_t			bid,
		uint32_t			bresp) {
	ap(&axi4_monitor_bfm_host_if::wresp, bid, bresp);
}

svf_component_ctor_def(axi4_monitor_bfm)
