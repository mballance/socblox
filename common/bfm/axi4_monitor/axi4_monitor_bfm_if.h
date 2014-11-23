#ifndef INCLUDED_axi4_monitor_bfm_IF_H
#define INCLUDED_axi4_monitor_bfm_IF_H
#include <stdint.h>

class axi4_monitor_bfm_target_if {
	public:

		virtual ~axi4_monitor_bfm_target_if() {}

		// TODO: Virtual methods to be implemented by the SystemVerilog side of the BFM

};

class axi4_monitor_bfm_host_if {
	public:

		virtual ~axi4_monitor_bfm_host_if() {}

		// TODO: Virtual methods to be implemented by the SVF side of the BFM

		virtual void ar(
				uint32_t			araddr,
				uint32_t			arid,
				uint32_t			arlen,
				uint32_t			arsize,
				uint32_t			arburst,
				uint32_t			arlock,
				uint32_t			arcache,
				uint32_t			arprot,
				uint32_t			arqos,
				uint32_t			arregion) = 0;

		virtual void rdata(
				uint64_t			rdata,
				uint32_t			rid,
				uint32_t			rresp,
				uint32_t			rlast) = 0;

		virtual void aw(
				uint32_t			awaddr,
				uint32_t			awid,
				uint32_t			awlen,
				uint32_t			awsize,
				uint32_t			awburst,
				uint32_t			awlock,
				uint32_t			awcache,
				uint32_t			awprot,
				uint32_t			awqos,
				uint32_t			awregion) = 0;

		virtual void wdata(
				uint64_t			wdata,
				uint64_t			wstrb,
				uint32_t			wlast) = 0;

		virtual void wresp(
				uint32_t			bid,
				uint32_t			bresp) = 0;

};

#endif /* INCLUDED_axi4_monitor_bfm_IF_H */
