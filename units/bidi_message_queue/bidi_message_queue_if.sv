/****************************************************************************
 * bidi_message_queue_if.sv
 ****************************************************************************/

/**
 * Interface: bidi_message_queue_if
 * 
 * TODO: Add module documentation
 */
interface bidi_message_queue_if;
	bit			outbound_valid;
	bit			outbound_ready;
	bit			inbound_valid;
	bit			inbound_ready;
	bit[31:0]	outbound_data;
	bit[31:0]	inbound_data;

	// Client side of the message queue interface.
	// Accepts outbound data from the message queue
	// and transmits inbound data.
	modport msg_q_client(
			input		outbound_valid,
			output		outbound_ready,
			input		outbound_data,
			output		inbound_valid,
			input		inbound_ready,
			output		inbound_data);
			
	modport msg_q(
			output		outbound_valid,
			input		outbound_ready,
			output		outbound_data,
			input		inbound_valid,
			output		inbound_ready,
			input		inbound_data);

endinterface

