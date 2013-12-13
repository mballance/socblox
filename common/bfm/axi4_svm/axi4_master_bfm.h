/*
 * axi4_master_bfm.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_H_
#define AXI4_MASTER_BFM_H_

#include "svm_bfm.h"
#include <string>

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

class axi4_master_bfm: public svm_bfm {
	svm_component_ctor_decl(axi4_master_bfm)

	public:

		axi4_master_bfm(const char *name, svm_component *parent);

		virtual ~axi4_master_bfm();

		void init(const char *bfm_path);

		uint8_t write32(
				uint64_t			addr,
				uint32_t			data);

	private:
		string						m_bfm_path;
		bool						m_initialized;
//		sc_event					m_initialized_ev;

//		sc_event					m_aw_ack_ev;

};

#endif /* AXI4_MASTER_BFM_H_ */
