/*
 * axi4_monitor_transaction_producer.cpp
 *
 *  Created on: Oct 23, 2014
 *      Author: ballance
 */

#include "axi4_monitor_transaction_producer.h"
#include <stdio.h>

axi4_monitor_transaction_producer::axi4_monitor_transaction_producer() {
	// TODO Auto-generated constructor stub

}

axi4_monitor_transaction_producer::~axi4_monitor_transaction_producer() {
	// TODO Auto-generated destructor stub
}

void axi4_monitor_transaction_producer::ar(
		uint32_t			araddr,
		uint32_t			arid,
		uint32_t			arlen,
		uint32_t			arsize,
		uint32_t			arburst,
		uint32_t			arlock,
		uint32_t			arcache,
		uint32_t			arprot,
		uint32_t			arqos,
		uint32_t			arregion) {
	axi4_monitor_transaction *t = alloc_t();

	t->is_write = false;
	t->addr = araddr;
	t->id = arid;
	t->len = arlen;
	t->size = arsize;
	t->burst = arburst;
	t->lock = arlock;
	t->cache = arcache;
	t->prot = arprot;
	t->qos = arqos;
	t->region = arregion;
	t->data_idx = 0;

	m_inflight_trans.push_back(t);
}

void axi4_monitor_transaction_producer::rdata(
		uint64_t			rdata,
		uint32_t			rid,
		uint32_t			rresp,
		uint32_t			rlast) {
	axi4_monitor_transaction *t = find_transaction(false, rid);

	if (!t) {
		fprintf(stdout, "Error: Unmatched rdata with id %d\n", rid);
		fflush(stdout);
		return;
	}

	// find transaction
	t->data[t->data_idx] = rdata;
	t->resp = rresp;

	if (rlast) {
		// Remove from inflight, publish, and free
		m_inflight_trans.remove(t);
		ap.write(*t);
		free_t(t);
	}
}

void axi4_monitor_transaction_producer::aw(
		uint32_t			awaddr,
		uint32_t			awid,
		uint32_t			awlen,
		uint32_t			awsize,
		uint32_t			awburst,
		uint32_t			awlock,
		uint32_t			awcache,
		uint32_t			awprot,
		uint32_t			awqos,
		uint32_t			awregion) {
	axi4_monitor_transaction *t = alloc_t();

	t->is_write = true;
	t->addr = awaddr;
	t->id = awid;
	t->len = awlen;
	t->size = awsize;
	t->burst = awburst;
	t->lock = awlock;
	t->cache = awcache;
	t->prot = awprot;
	t->qos = awqos;
	t->region = awregion;
	t->data_idx = 0;

	m_inflight_trans.push_back(t);
}

void axi4_monitor_transaction_producer::wdata(
		uint64_t			wdata,
		uint64_t			wstrb,
		uint32_t			wlast) {
	axi4_monitor_transaction *t = find_last_write();

	if (!t) {
		fprintf(stdout, "Error: Unmatched wdata transaction\n");
		fflush(stdout);
		return;
	}

	// find transaction
	t->data[t->data_idx] = wdata;
	t->wstrb = wstrb;

}

void axi4_monitor_transaction_producer::wresp(
		uint32_t			bid,
		uint32_t			bresp) {
	axi4_monitor_transaction *t = find_transaction(false, bid);

	if (!t) {
		fprintf(stdout, "Error: Unmatched wresp with id %d\n", bid);
		fflush(stdout);
		return;
	}

	// Remove from inflight, publish, and free
	m_inflight_trans.remove(t);
	ap.write(*t);
	free_t(t);
}

axi4_monitor_transaction *axi4_monitor_transaction_producer::alloc_t() {
	axi4_monitor_transaction *t;

	if (m_freelist.size() > 0) {
		t = m_freelist.pop_back();
	} else {
		t = new axi4_monitor_transaction();
	}

	return t;
}

void axi4_monitor_transaction_producer::free_t(axi4_monitor_transaction *t) {
	m_freelist.push_back(t);
}

axi4_monitor_transaction *axi4_monitor_transaction_producer::find_transaction(
		bool			is_write,
		uint32_t		id) {
	axi4_monitor_transaction *t = 0;

	for (uint32_t i=0; i<m_inflight_trans.size(); i++) {
		if (m_inflight_trans.at(i)->is_write == is_write &&
				m_inflight_trans.at(i)->id == id) {
			t = m_inflight_trans.at(i);
			break;
		}
	}

	return t;
}

axi4_monitor_transaction *axi4_monitor_transaction_producer::find_last_write() {
	axi4_monitor_transaction *t = 0;

	for (uint32_t i=0; i<m_inflight_trans.size(); i++) {
		if (m_inflight_trans.at(i)->is_write) {
			t = m_inflight_trans.at(i);
			break;
		}
	}

	return t;
}
