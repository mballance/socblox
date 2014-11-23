/*
 * axi4_monitor_stream_logger.h
 *
 *  Created on: Oct 27, 2014
 *      Author: ballance
 */

#ifndef AXI4_MONITOR_STREAM_LOGGER_H_
#define AXI4_MONITOR_STREAM_LOGGER_H_
#include "svf.h"
#include "axi4_monitor_bfm_if.h"
#include "timebase.h"
#include <stdio.h>

class axi4_monitor_stream_logger : public virtual axi4_monitor_bfm_host_if {

	public:

		svf_api_export<axi4_monitor_bfm_host_if>		api_export;

	public:
		axi4_monitor_stream_logger(
				const char 			*name,
				FILE 				*fp,
				timebase 			*tb=0);

		virtual ~axi4_monitor_stream_logger();

		void set_timebase(timebase *tb) { m_timebase = tb; }

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
				uint32_t			arregion);

		virtual void rdata(
				uint64_t			rdata,
				uint32_t			rid,
				uint32_t			rresp,
				uint32_t			rlast);

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
				uint32_t			awregion);

		virtual void wdata(
				uint64_t			wdata,
				uint64_t			wstrb,
				uint32_t			wlast);

		virtual void wresp(
				uint32_t			bid,
				uint32_t			bresp);

		virtual uint64_t get_time();

	private:
		svf_string						m_name;
		FILE							*m_fp;
		timebase						*m_timebase;

		uint32_t						m_awaddr;
		uint32_t						m_awid;
		uint32_t						m_awsize;
		uint64_t						m_aw_time;
		uint32_t						m_write_data[64];
		uint32_t						m_write_idx;

		uint32_t						m_araddr;
		uint32_t						m_arid;
		uint32_t						m_arsize;
		uint64_t						m_ar_time;
		uint32_t						m_read_data[64];
		uint32_t						m_read_idx;


};

#endif /* AXI4_MONITOR_STREAM_LOGGER_H_ */
