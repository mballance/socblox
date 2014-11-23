/*
 * axi4_monitor_bfm_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "axi4_monitor_bfm_dpi_mgr.h"

axi4_monitor_bfm_dpi_mgr::axi4_monitor_bfm_dpi_mgr() {
}

axi4_monitor_bfm_dpi_closure::axi4_monitor_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(axi4_monitor_bfm)

// TODO: SVF_DPI_CLOSURE_EXPORT_TASK for tasks implemented in SystemVerilog
// SVF_DPI_CLOSURE_EXPORT_TASK(axi4_monitor_bfm, write8, (uint64_t addr, uint8_t data), (addr, data))

// TODO: SVF_DPI_CLOSURE_IMPORT_TASK for tasks implemented in C++
// SVF_DPI_CLOSURE_EXPORT_TASK(axi4_monitor_bfm, write16, (uint64_t addr, uint16_t data), (addr, data))

SVF_DPI_CLOSURE_IMPORT_TASK(axi4_monitor_bfm, ar, (
		uint32_t			araddr,
		uint32_t			arid,
		uint32_t			arlen,
		uint32_t			arsize,
		uint32_t			arburst,
		uint32_t			arlock,
		uint32_t			arcache,
		uint32_t			arprot,
		uint32_t			arqos,
		uint32_t			arregion), (
			araddr, arid, arlen, arsize, arburst, arlock,
			arcache, arprot, arqos, arregion
		))

SVF_DPI_CLOSURE_IMPORT_TASK(axi4_monitor_bfm, rdata, (
		uint64_t			rdata,
		uint32_t			rid,
		uint32_t			rresp,
		uint32_t			rlast), (
			rdata, rid, rresp, rlast
		))

SVF_DPI_CLOSURE_IMPORT_TASK(axi4_monitor_bfm, aw, (
		uint32_t			awaddr,
		uint32_t			awid,
		uint32_t			awlen,
		uint32_t			awsize,
		uint32_t			awburst,
		uint32_t			awlock,
		uint32_t			awcache,
		uint32_t			awprot,
		uint32_t			awqos,
		uint32_t			awregion), (
			awaddr, awid, awlen, awsize, awburst, awlock,
			awcache, awprot, awqos, awregion
		))

SVF_DPI_CLOSURE_IMPORT_TASK(axi4_monitor_bfm, wdata, (
		uint64_t			wdata,
		uint32_t			wstrb,
		uint32_t			wlast), (
			wdata, wstrb, wlast
		))

SVF_DPI_CLOSURE_IMPORT_TASK(axi4_monitor_bfm, wresp, (
		uint32_t			bid,
		uint32_t			bresp), (
			bid, bresp
		))

