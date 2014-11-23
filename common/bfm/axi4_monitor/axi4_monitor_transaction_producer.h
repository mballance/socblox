/*
 * axi4_monitor_transaction_producer.h
 *
 *  Created on: Oct 23, 2014
 *      Author: ballance
 */

#ifndef AXI4_MONITOR_TRANSACTION_PRODUCER_H_
#define AXI4_MONITOR_TRANSACTION_PRODUCER_H_
#include "svf.h"
#include "axi4_monitor_bfm_if.h"
#include "axi4_monitor_transaction.h"

class axi4_monitor_transaction_producer : virtual public axi4_monitor_bfm_host_if {

	public:
		svf_analysis_port<axi4_monitor_transaction>			ap;

	public:
		axi4_monitor_transaction_producer();

		virtual ~axi4_monitor_transaction_producer();

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

	private:
		axi4_monitor_transaction *alloc_t();

		void free_t(axi4_monitor_transaction *t);

		axi4_monitor_transaction *find_transaction(bool is_write, uint32_t id);

		axi4_monitor_transaction *find_last_write();

	private:

		svf_ptr_vector<axi4_monitor_transaction>	m_inflight_trans;
		svf_ptr_vector<axi4_monitor_transaction>	m_freelist;
};

#endif /* AXI4_MONITOR_TRANSACTION_PRODUCER_H_ */
