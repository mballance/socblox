#ifndef INCLUDED_bidi_message_queue_direct_bfm_IF_H
#define INCLUDED_bidi_message_queue_direct_bfm_IF_H
#include <stdint.h>

class bidi_message_queue_direct_bfm_target_if {
	public:

		virtual ~bidi_message_queue_direct_bfm_target_if() {}


		// TODO: Virtual methods to be implemented by the SystemVerilog side of the BFM
		virtual void get_queue_sz(uint32_t *queue_sz) = 0;
		virtual void get_inbound_ptrs(uint32_t *rd_ptr, uint32_t *wr_ptr) = 0;
		virtual void set_inbound_wr_ptr(uint32_t wr_ptr) = 0;

		virtual void get_outbound_ptrs(uint32_t *rd_ptr, uint32_t *wr_ptr) = 0;
		virtual void set_outbound_rd_ptr(uint32_t rd_ptr) = 0;

		virtual void set_data(uint32_t offset, uint32_t data) = 0;
		virtual void get_data(uint32_t offset, uint32_t *data) = 0;

		virtual void wait_inbound_avail() = 0;
		virtual void wait_outbound_avail() = 0;
};

class bidi_message_queue_direct_bfm_host_if {
	public:

		virtual ~bidi_message_queue_direct_bfm_host_if() {}

		// TODO: Virtual methods to be implemented by the SVF side of the BFM

		virtual void inbound_avail_ack() = 0;
		virtual void outbound_avail_ack() = 0;
};

#endif /* INCLUDED_bidi_message_queue_direct_bfm_IF_H */
