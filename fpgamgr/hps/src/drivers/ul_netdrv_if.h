/*
 * ul_netdrv_if.h
 *
 *  Created on: Jan 22, 2015
 *      Author: ballance
 */

#ifndef UL_NETDRV_IF_H_
#define UL_NETDRV_IF_H_
#include <stdint.h>

typedef struct ul_netdrv_frame_s {
	struct ul_netdrv_frame_s		*next;
	uint32_t						sz;

	uint8_t							data[0];
} ul_netdrv_frame_t;

#define UL_NETDRV_FRAME_DATAOFF (sizeof(ul_netdrv_frame_s *) + sizeof(uint32_t))
#define DATA_ADDR_2_NETDRV_FRAME(addr) \
	((ul_netdrv_frame_t *)((uint8_t *)(addr) - UL_NETDRV_FRAME_DATAOFF))

class ul_netdrv_if {

	public:

		virtual ~ul_netdrv_if() {}

		virtual ul_netdrv_frame_t *alloc_frame() = 0;

		virtual void release_frame(ul_netdrv_frame_t *frame) = 0;

		virtual ul_netdrv_frame_t *recv() = 0;

		virtual void send(ul_netdrv_frame_t *frame) = 0;

		virtual uint64_t get_macaddr() = 0;

//		virtual uint32_t
};



#endif /* UL_NETDRV_IF_H_ */
