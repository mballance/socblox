/*
 * axi4_master_if.h
 *
 *  Created on: Dec 30, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_IF_H_
#define AXI4_MASTER_IF_H_
#include <stdint.h>
#include "svm_mem_if.h"

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


class axi4_master_if : public svm_mem_if {

	public:
		virtual ~axi4_master_if() {}

		virtual void write(
				uint64_t				addr,
				axi4_burst_size_t		burst_size,
				uint32_t				burst_len,
				uint32_t				*data,
				uint8_t					&resp,
				axi4_burst_type_t		burst_type=AXI4_BURST_TYPE_FIXED
				) = 0;

		virtual void read(
				uint64_t				addr,
				axi4_burst_size_t		burst_size,
				uint32_t				burst_len,
				uint32_t				*data,
				uint8_t					&resp,
				axi4_burst_type_t		burst_type=AXI4_BURST_TYPE_FIXED
				) = 0;

};



#endif /* AXI4_MASTER_IF_H_ */
