/****************************************************************************
 * bidi_message_queue_bfm.sv
 ****************************************************************************/

/**
 * Module: bidi_message_queue_bfm
 * 
 * TODO: Add module documentation
 */
module bidi_message_queue_bfm(
		input								clk,
		input								rst_n,
		bidi_message_queue_if.msg_q_client	queue_if
		);
	
	reg						inbound_req = 0;
	reg						outbound_req = 0;
	reg						outbound_state = 0;
	reg						inbound_state = 0;
	reg						outbound_ready = 0;
	reg						inbound_valid = 0;
	reg[31:0]				inbound_data = 0;
	
	assign queue_if.outbound_ready = outbound_ready;
	assign queue_if.inbound_valid = inbound_valid;
	assign queue_if.inbound_data = inbound_data;

	task bidi_message_queue_bfm_write_req(
		int unsigned		data
		);
		inbound_data = data;
		inbound_req = 1;
	endtask
	export "DPI-C" task bidi_message_queue_bfm_write_req;
	
	task bidi_message_queue_bfm_read_req();
		outbound_req = 1;
	endtask
	export "DPI-C" task bidi_message_queue_bfm_read_req;
	
	import "DPI-C" task bidi_message_queue_bfm_write_ack();
	
	import "DPI-C" task bidi_message_queue_bfm_read_ack(
			int unsigned data);
	
	always @(posedge clk) begin
		case (outbound_state)
			0: begin
				if (outbound_req) begin
					outbound_ready <= 1;
					outbound_state <= 1;
				end
			end
				
			1: begin
				if (queue_if.outbound_ready && queue_if.outbound_valid) begin
					bidi_message_queue_bfm_read_ack(queue_if.outbound_data);
					outbound_ready <= 0;
					outbound_req = 0;
				end
			end
		endcase
		
		case (inbound_state)
			0: begin
				if (inbound_req) begin
					inbound_valid <= 1;
					inbound_state <= 1;
				end
			end
			
			1: begin
				if (queue_if.inbound_valid && queue_if.inbound_ready) begin
					bidi_message_queue_bfm_write_ack();
					inbound_valid <= 0;
					inbound_req = 0;
				end
			end
		endcase

	end
		
    import "DPI-C" context task bidi_message_queue_bfm_register();
    initial begin
    	bidi_message_queue_bfm_register();
    end

endmodule

