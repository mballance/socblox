/*
 * bidi_message_queue_direct_bfm_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_bidi_message_queue_direct_bfm_DPI_MGR_H
#define INCLUDED_bidi_message_queue_direct_bfm_DPI_MGR_H
#include "svf.h"
#include "svf_dpi.h"
#include "bidi_message_queue_direct_bfm_if.h"
#include <map>
#include <string>

using namespace std;

class bidi_message_queue_direct_bfm_dpi_mgr;

class bidi_message_queue_direct_bfm_dpi_closure : public svf_dpi_closure<bidi_message_queue_direct_bfm_host_if, bidi_message_queue_direct_bfm_target_if> {

	public:

		bidi_message_queue_direct_bfm_dpi_closure(const string &target);

		virtual ~bidi_message_queue_direct_bfm_dpi_closure() {}

		// TODO: Virtual methods for target API
		virtual void get_queue_sz(uint32_t *queue_sz);
		virtual void get_inbound_ptrs(uint32_t *rd_ptr, uint32_t *wr_ptr);
		virtual void set_inbound_wr_ptr(uint32_t wr_ptr);

		virtual void get_outbound_ptrs(uint32_t *rd_ptr, uint32_t *wr_ptr);
		virtual void set_outbound_rd_ptr(uint32_t rd_ptr);

		virtual void set_data(uint32_t offset, uint32_t data);
		virtual void get_data(uint32_t offset, uint32_t *data);

		virtual void wait_inbound_avail();
		virtual void wait_outbound_avail();

};

class bidi_message_queue_direct_bfm_dpi_mgr : public svf_dpi_mgr<bidi_message_queue_direct_bfm_dpi_closure> {

	public:

		bidi_message_queue_direct_bfm_dpi_mgr();

};



#endif /* INCLUDED_bidi_message_queue_direct_bfm_DPI_MGR_H */
