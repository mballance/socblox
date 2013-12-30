/*
 * axi4_master_bfm.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_H_
#define AXI4_MASTER_BFM_H_

#include "svm.h"
#include "axi4_master_bfm_if.h"
#include "axi4_master_if.h"

using namespace std;


class axi4_master_bfm: public svm_component,
	virtual axi4_master_bfm_host_if, virtual axi4_master_if {
	svm_component_ctor_decl(axi4_master_bfm)

	public:
		svm_api_export<axi4_master_if>												master_export;

		// Port to the BFM
		svm_bidi_api_port<axi4_master_bfm_host_if, axi4_master_bfm_target_if>		bfm_port;

	public:

		axi4_master_bfm(const char *name, svm_component *parent);

		virtual ~axi4_master_bfm();

		virtual void start();

		virtual void write(
				uint64_t			addr,
				axi4_burst_size_t	burst_size,
				uint32_t			burst_len,
				uint32_t			*data,
				uint8_t				&resp,
				axi4_burst_type_t	burst_type);

		virtual void read(
				uint64_t			addr,
				axi4_burst_size_t	burst_size,
				uint32_t			burst_len,
				uint32_t			*data,
				uint8_t				&resp,
				axi4_burst_type_t	burst_type);

		virtual uint8_t read8(uint64_t addr);
		virtual uint16_t read16(uint64_t addr);
		virtual uint32_t read32(uint64_t addr);
		virtual uint64_t read64(uint64_t addr);

		virtual void write8(uint64_t addr, uint8_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write32(uint64_t addr, uint32_t data);
		virtual void write64(uint64_t addr, uint64_t data);

		// Implementation of host API
	public:

		void bresp(uint32_t resp);

		void aw_ready();

	private:
		uint32_t					ADDRESS_WIDTH;
		uint32_t					DATA_WIDTH;
		uint32_t					ID_WIDTH;

		uint32_t					m_aw_id;
		uint32_t					m_ar_id;

		svm_thread_mutex			m_mutex;
		svm_thread_mutex			m_write_mutex;

		svm_thread_mutex			m_aw_mutex;
		svm_semaphore				m_aw_sem;

		svm_thread_mutex			m_b_mutex;

};

#endif /* AXI4_MASTER_BFM_H_ */
