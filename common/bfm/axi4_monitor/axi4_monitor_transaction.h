/*
 * axi4_monitor_transaction.h
 *
 *  Created on: Oct 23, 2014
 *      Author: ballance
 */

#ifndef AXI4_MONITOR_TRANSACTION_H_
#define AXI4_MONITOR_TRANSACTION_H_
#include <stdint.h>

class axi4_monitor_transaction {

	public:
		bool					is_write;
		uint32_t				addr;
		uint32_t				id;
		uint32_t				len;
		uint32_t				size;
		uint32_t				burst;
		uint32_t				lock;
		uint32_t				cache;
		uint32_t				prot;
		uint32_t				qos;
		uint32_t				region;

		uint64_t				data[16];
		uint32_t				data_idx;
		uint32_t				wstrb;

		uint32_t				resp;

	public:

		axi4_monitor_transaction();

		virtual ~axi4_monitor_transaction();
};

#endif /* AXI4_MONITOR_TRANSACTION_H_ */
