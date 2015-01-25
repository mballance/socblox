/*
 * designware_eth_drv.cpp
 *
 *  Created on: Jan 22, 2015
 *      Author: ballance
 */

#include "designware_eth_drv.h"
#include <stdlib.h>
#include <malloc.h>
#include <stdio.h>
#include "regio.h"

#define DESC_TXSTS_OWNBYDMA		(1 << 31)
#define DESC_TXSTS_TXINT		(1 << 30)
#define DESC_TXSTS_TXLAST		(1 << 29)
#define DESC_TXSTS_TXFIRST		(1 << 28)
#define DESC_TXSTS_TXCRCDIS		(1 << 27)

#define DESC_TXSTS_TXPADDIS		(1 << 26)
#define DESC_TXSTS_TXCHECKINSCTRL	(3 << 22)
#define DESC_TXSTS_TXRINGEND		(1 << 21)
#define DESC_TXSTS_TXCHAIN		(1 << 20)
#define DESC_TXSTS_MSK			(0x1FFFF << 0)

#define DESC_RXSTS_OWNBYDMA		(1 << 31)
#define DESC_RXSTS_DAFILTERFAIL		(1 << 30)
#define DESC_RXSTS_FRMLENMSK		(0x3FFF << 16)
#define DESC_RXSTS_FRMLENSHFT		(16)

#define DESC_RXSTS_ERROR		(1 << 15)
#define DESC_RXSTS_RXTRUNCATED		(1 << 14)
#define DESC_RXSTS_SAFILTERFAIL		(1 << 13)
#define DESC_RXSTS_RXIPC_GIANTFRAME	(1 << 12)
#define DESC_RXSTS_RXDAMAGED		(1 << 11)
#define DESC_RXSTS_RXVLANTAG		(1 << 10)
#define DESC_RXSTS_RXFIRST		(1 << 9)
#define DESC_RXSTS_RXLAST		(1 << 8)
#define DESC_RXSTS_RXIPC_GIANT		(1 << 7)
#define DESC_RXSTS_RXCOLLISION		(1 << 6)
#define DESC_RXSTS_RXFRAMEETHER		(1 << 5)
#define DESC_RXSTS_RXWATCHDOG		(1 << 4)
#define DESC_RXSTS_RXMIIERROR		(1 << 3)
#define DESC_RXSTS_RXDRIBBLING		(1 << 2)
#define DESC_RXSTS_RXCRC		(1 << 1)

#define DESC_TXCTRL_SIZE1MASK		(0x1FFF << 0)
#define DESC_TXCTRL_SIZE1SHFT		(0)
#define DESC_TXCTRL_SIZE2MASK		(0x1FFF << 16)
#define DESC_TXCTRL_SIZE2SHFT		(16)

#define DESC_RXCTRL_RXINTDIS		(1 << 31)
#define DESC_RXCTRL_RXRINGEND		(1 << 15)
#define DESC_RXCTRL_RXCHAIN		(1 << 14)

#define DESC_RXCTRL_SIZE1MASK		(0x1FFF << 0)
#define DESC_RXCTRL_SIZE1SHFT		(0)
#define DESC_RXCTRL_SIZE2MASK		(0x1FFF << 16)
#define DESC_RXCTRL_SIZE2SHFT		(16)

/* MAC configuration register definitions */
#define FRAMEBURSTENABLE	(1 << 21)
#define MII_PORTSELECT		(1 << 15)
#define FES_100			(1 << 14)
#define DISABLERXOWN		(1 << 13)
#define FULLDPLXMODE		(1 << 11)
#define RXENABLE		(1 << 2)
#define TXENABLE		(1 << 3)

/* MII address register definitions */
#define MII_BUSY		(1 << 0)
#define MII_WRITE		(1 << 1)
#define MII_CLKRANGE_60_100M	(0)
#define MII_CLKRANGE_100_150M	(0x4)
#define MII_CLKRANGE_20_35M	(0x8)
#define MII_CLKRANGE_35_60M	(0xC)
#define MII_CLKRANGE_150_250M	(0x10)
#define MII_CLKRANGE_250_300M	(0x14)

#define MIIADDRSHIFT		(11)
#define MIIREGSHIFT		(6)
#define MII_REGMSK		(0x1F << 6)
#define MII_ADDRMSK		(0x1F << 11)

/* Operation mode definitions */
#define STOREFORWARD		(1 << 21)
#define FLUSHTXFIFO		(1 << 20)
#define TXSTART			(1 << 13)
#define TXSECONDFRAME		(1 << 2)
#define RXSTART			(1 << 1)


designware_eth_drv::designware_eth_drv() {
	m_frame_alloc_ptr = 0;
	m_frame_sz = 1600;
	m_mac_addr = 0;

	init_dma_desc_chains(2);
}

designware_eth_drv::~designware_eth_drv() {
	// TODO Auto-generated destructor stub
}

void designware_eth_drv::init(void *ethmac_addr) {

	// Finally, turn things on...

	m_mac_regs = (eth_mac_regs_t *)ethmac_addr;
	m_dma_regs = (eth_dma_regs_t *)((uint8_t *)ethmac_addr + 0x1000);

	if (!m_mac_addr) {
		// Get the MAC address
		uint32_t lo, hi;

		lo = readl(&m_mac_regs->macaddr0lo);
		hi = readl(&m_mac_regs->macaddr0hi);

		m_mac_addr = (hi & 0xFFFF);
		m_mac_addr = (m_mac_addr << 32);
		m_mac_addr = (m_mac_addr | lo);
	} else {
		// TODO: set the address
	}


	// Disable the MAC temporarily
	writel((readl(&m_mac_regs->conf) & ~(RXENABLE|TXENABLE)), &m_mac_regs->conf);
	writel((readl(&m_dma_regs->opmode) & ~(RXSTART|TXSTART)), &m_dma_regs->opmode);

	writel((uint32_t)m_tx_dma_chain, &m_dma_regs->txdesclistaddr);
	writel((uint32_t)m_rx_dma_chain, &m_dma_regs->rxdesclistaddr);

	// Re-enable the MAC
	writel((readl(&m_dma_regs->opmode) | RXSTART), &m_dma_regs->opmode);
	writel((readl(&m_dma_regs->opmode) | TXSTART), &m_dma_regs->opmode);

	writel((readl(&m_mac_regs->conf) | (RXENABLE | TXENABLE)), &m_mac_regs->conf);
}

ul_netdrv_frame_t *designware_eth_drv::alloc_frame() {
	ul_netdrv_frame_t *ret;

	if (m_frame_alloc_ptr) {
		ret = m_frame_alloc_ptr;
		m_frame_alloc_ptr = m_frame_alloc_ptr->next;
	} else {
		ret = (ul_netdrv_frame_t *)memalign(16, sizeof(ul_netdrv_frame_t)+m_frame_sz);
	}
	ret->sz = m_frame_sz;

	return ret;
}

void designware_eth_drv::release_frame(ul_netdrv_frame_t *frame) {
	frame->next = m_frame_alloc_ptr;
	m_frame_alloc_ptr = frame;
}

ul_netdrv_frame_t *designware_eth_drv::recv() {
	uint32_t status;
	ul_netdrv_frame_t *frm = 0, *frm_n;

	// Wait for the next frame to be received
	do {
		while (((status = m_rx_dma_rdptr->txrx_status) & DESC_RXSTS_OWNBYDMA)) {
			;
		}

		uint32_t length = ((status & DESC_RXSTS_FRMLENMSK) >> DESC_RXSTS_FRMLENSHFT);

		if (length < (6+6+2)) {
			// frame is too short
			m_rx_dma_rdptr->txrx_status = DESC_RXSTS_OWNBYDMA;
			m_rx_dma_rdptr = m_rx_dma_rdptr->dmamac_next;
			frm = 0;
			continue;
		}

		// TODO: determine whether this is a VLAN packet

		// First, see if we really care about this frame
		uint8_t *data = (uint8_t *)m_rx_dma_rdptr->dmamac_addr;
		uint32_t destaddr_lo, destaddr_hi;
		destaddr_hi = ((data[5] << 8) | data[4]);
		destaddr_lo = (data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24));
		uint64_t destaddr = destaddr_hi;
		destaddr <<= 32;
		destaddr |= destaddr_lo;

		if (destaddr == m_mac_addr || destaddr == 0xFFFFFFFFFFFF) {
			uint32_t length = ((status & DESC_RXSTS_FRMLENMSK) >> DESC_RXSTS_FRMLENSHFT);
			frm = DATA_ADDR_2_NETDRV_FRAME(m_rx_dma_rdptr->dmamac_addr);
			frm->sz = length;

			frm_n = alloc_frame();
			m_rx_dma_rdptr->dmamac_addr = frm_n->data;
		} else {
			// Ignore this frame, since it's neither directed to us, nor
			// broadcast
			frm = 0;
		}

		m_rx_dma_rdptr->txrx_status = DESC_RXSTS_OWNBYDMA;
		m_rx_dma_rdptr = m_rx_dma_rdptr->dmamac_next;
	} while (!frm);

	return frm;
}

void designware_eth_drv::send(ul_netdrv_frame_t *frame) {

}

uint64_t designware_eth_drv::get_macaddr() {
	return m_mac_addr;
}

void designware_eth_drv::init_dma_desc_chains(uint32_t chain_len) {
	dma_desc_t *curr;

	// Init the TX chain
	m_tx_dma_chain = 0;
	curr = 0;
	for (uint32_t i=0; i<chain_len; i++) {
		dma_desc_t *t = (dma_desc_t *)memalign(16, sizeof(dma_desc_t));

		t->txrx_status &=
				~(DESC_TXSTS_TXINT | DESC_TXSTS_TXLAST |
						DESC_TXSTS_TXFIRST | DESC_TXSTS_TXCRCDIS |
						DESC_TXSTS_TXCHECKINSCTRL |
						DESC_TXSTS_TXRINGEND | DESC_TXSTS_TXPADDIS);
		t->txrx_status |= DESC_TXSTS_TXCHAIN;
		t->dmamac_cntl = 0;
		t->txrx_status &= ~(DESC_TXSTS_MSK | DESC_TXSTS_OWNBYDMA);

		if (curr) {
			curr->dmamac_next = t;
		} else {
			m_tx_dma_chain = t;
		}
		curr = t;
	}
	curr->dmamac_next = m_tx_dma_chain;

	// Init the RX chain
	m_rx_dma_chain = 0;
	curr = 0;
	for (uint32_t i=0; i<chain_len; i++) {
		dma_desc_t *t = (dma_desc_t *)memalign(16, sizeof(dma_desc_t));

		t->dmamac_cntl =
				((m_frame_sz & DESC_RXCTRL_SIZE1MASK) | DESC_RXCTRL_RXCHAIN);
		t->txrx_status = DESC_RXSTS_OWNBYDMA;

		ul_netdrv_frame_t *frame = alloc_frame();
		t->dmamac_addr = frame->data;

		printf("RX Descriptor: %p ctrl=0x%08x\n", curr, t->dmamac_cntl);

		if (curr) {
			curr->dmamac_next = t;
		} else {
			m_rx_dma_chain = t;
		}
		curr = t;
	}
	curr->dmamac_next = m_rx_dma_chain;
	m_rx_dma_rdptr = m_rx_dma_chain;

}

