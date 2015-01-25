/*
 * designware_eth_drv.h
 *
 *  Created on: Jan 22, 2015
 *      Author: ballance
 */

#ifndef DESIGNWARE_ETH_DRV_H_
#define DESIGNWARE_ETH_DRV_H_
#include "ul_netdrv_if.h"
#include <stdint.h>

class designware_eth_drv : public virtual ul_netdrv_if {

	public:

		designware_eth_drv();

		virtual ~designware_eth_drv();

		void init(void *ethmac_addr);

		virtual ul_netdrv_frame_t *alloc_frame();

		virtual void release_frame(ul_netdrv_frame_t *frame);

		virtual ul_netdrv_frame_t *recv();

		virtual void send(ul_netdrv_frame_t *frame);

		virtual uint64_t get_macaddr();

	private:

		typedef struct eth_mac_regs_s {
			uint32_t conf;		/* 0x00 */
			uint32_t framefilt;		/* 0x04 */
			uint32_t hashtablehigh;	/* 0x08 */
			uint32_t hashtablelow;	/* 0x0c */
			uint32_t miiaddr;		/* 0x10 */
			uint32_t miidata;		/* 0x14 */
			uint32_t flowcontrol;	/* 0x18 */
			uint32_t vlantag;		/* 0x1c */
			uint32_t version;		/* 0x20 */
			uint8_t reserved_1[20];
			uint32_t intreg;		/* 0x38 */
			uint32_t intmask;		/* 0x3c */
			uint32_t macaddr0hi;		/* 0x40 */
			uint32_t macaddr0lo;		/* 0x44 */
		} eth_mac_regs_t;

		typedef struct eth_dma_regs_s {
			uint32_t busmode;		/* 0x00 */
			uint32_t txpolldemand;	/* 0x04 */
			uint32_t rxpolldemand;	/* 0x08 */
			uint32_t rxdesclistaddr;	/* 0x0c */
			uint32_t txdesclistaddr;	/* 0x10 */
			uint32_t status;		/* 0x14 */
			uint32_t opmode;		/* 0x18 */
			uint32_t intenable;		/* 0x1c */
			uint8_t reserved[40];
			uint32_t currhosttxdesc;	/* 0x48 */
			uint32_t currhostrxdesc;	/* 0x4c */
			uint32_t currhosttxbuffaddr;	/* 0x50 */
			uint32_t currhostrxbuffaddr;	/* 0x54 */
		} eth_dma_regs_t;

		typedef struct dma_desc_s {
			uint32_t 				txrx_status;
			uint32_t 				dmamac_cntl;
			void 					*dmamac_addr;
			struct dma_desc_s 		*dmamac_next;
		} dma_desc_t;


	private:

		void init_dma_desc_chains(uint32_t chain_len);


	private:
		uint64_t				m_mac_addr;
		volatile eth_mac_regs_t	*m_mac_regs;
		volatile eth_dma_regs_t	*m_dma_regs;
		uint32_t				m_frame_sz;
		dma_desc_t				*m_tx_dma_chain;
		volatile dma_desc_t		*m_tx_dma_rdptr;
		volatile dma_desc_t		*m_tx_dma_wrptr;

		dma_desc_t				*m_rx_dma_chain;
		volatile dma_desc_t		*m_rx_dma_rdptr;

		ul_netdrv_frame_t		*m_frame_alloc_ptr;


};

#endif /* DESIGNWARE_ETH_DRV_H_ */
