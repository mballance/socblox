#ifndef INCLUDED_bidi_message_queue_bfm_IF_H
#define INCLUDED_bidi_message_queue_bfm_IF_H
#include <stdint.h>

class bidi_message_queue_bfm_target_if {
	public:

		virtual ~bidi_message_queue_bfm_target_if() {}

		// TODO: Virtual methods to be implemented by the SystemVerilog side of the BFM

		virtual void write_req(uint32_t data) = 0;
		virtual void read_req() = 0;
};

class bidi_message_queue_bfm_host_if {
	public:

		virtual ~bidi_message_queue_bfm_host_if() {}

		// TODO: Virtual methods to be implemented by the SVF side of the BFM
		virtual void write_ack() = 0;
		virtual void read_ack(uint32_t data) = 0;
};

#endif /* INCLUDED_bidi_message_queue_bfm_IF_H */
