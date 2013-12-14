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
#include "axi4_master_bfm_dpi_mgr.h"
#include <string>
#include <map>

using namespace std;

typedef enum {
	AXI4_BURST_SIZE_1 = 0,
	AXI4_BURST_SIZE_2,
	AXI4_BURST_SIZE_4,
	AXI4_BURST_SIZE_8,
	AXI4_BURST_SIZE_16,
	AXI4_BURST_SIZE_32,
	AXI4_BURST_SIZE_64,
	AXI4_BURST_SIZE_128,
} axi4_burst_size_t;

typedef enum {
	AXI4_BURST_TYPE_FIXED = 0,
	AXI4_BURST_TYPE_INCR,
	AXI4_BURST_TYPE_WRAP
} axi4_burst_type_t;

class axi4_master_bfm: public svm_bfm, virtual axi4_master_bfm_host_if {
	svm_component_ctor_decl(axi4_master_bfm)

	public:
		svm_bidi_api_port<axi4_master_bfm_host_if, axi4_master_bfm_target_if>		bfm_port;

	public:

		axi4_master_bfm(const char *name, svm_component *parent);

		virtual ~axi4_master_bfm();

		uint8_t write32(
				uint64_t			addr,
				uint32_t			data);

		// Implementation of host API
		void aw_ready();

	private:
		svm_thread_mutex			m_mutex;
		svm_semaphore				m_aw_sem;

};

#endif /* AXI4_MASTER_BFM_H_ */
