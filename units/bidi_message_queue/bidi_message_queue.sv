/****************************************************************************
 * bidi_message_queue.sv
 ****************************************************************************/

/**
 * Module: bidi_message_queue
 * 
 * The BIDI message queue manages communication between a memory-oriented
 * device, such as a processor, and a stream-oriented device.
 * 
 * The processor views this device as two blocks of memory:
 * Control registers: 0x0000-0x03FF (word addresses)
 *   inbound_rd_ptr		-- RW for processor
 *   inbound_wr_ptr		-- RO for processor
 *   outbound_rd_ptr	-- RO for processor
 *   outbound_wr_ptr	-- RW for processor
 *   control			-- RW for processor
 *   status
 *   	[1]				-- outbound_irq
 *   	[0]				-- inbound_irq
 * 
 * Memory: 0x0400--0xXXXX
 *   Inbound  FIFO: [2**(QUEUE_ADDR_BITS/2)]
 *   Outbound FIFO: [2**(QUEUE_ADDR_BITS/2)]
 */
module bidi_message_queue #(
		// Total number of 32-bit words in the two queues
		parameter int QUEUE_ADDR_BITS=10
		) (
		input							clk,
		input							rst_n,
		generic_sram_line_en_if.sram	mem_if,
		bidi_message_queue_if.msg_q	queue_if,
		output							irq
		);

	localparam QUEUE_SZ = (1 << (QUEUE_ADDR_BITS-1));
	
	reg[31:0]			inbound_rd_ptr;
	reg[31:0]			inbound_wr_ptr;
	wire[31:0]			inbound_wr_ptr_next;
	reg[31:0]			outbound_rd_ptr;
	wire[31:0]			outbound_rd_ptr_next;
	reg[31:0]			outbound_wr_ptr;
	
	reg[31:0]			addr_r;
	reg[31:0]			addr_sram_r;
	wire[31:0]			read_data;
	
	wire				bus_mem_access = (
			(mem_if.read_en | mem_if.write_en) &&
			(addr_r[11:6] >= 'h1));
	
	
	wire reg_space = (addr_r < 'h400);

	// Handle local register access
	always @(posedge clk) begin
		addr_r <= mem_if.addr;
		addr_sram_r <= (mem_if.addr - 'h400);
	
		if (mem_if.write_en) begin
			if (mem_if.addr[3:0] == 0) begin
				inbound_rd_ptr <= mem_if.write_data;
			end
			if (mem_if.addr[3:0] == 1) begin
				inbound_wr_ptr <= mem_if.write_data;
			end
			if (mem_if.addr[3:0] == 2) begin
				outbound_rd_ptr <= mem_if.write_data;
			end
			if (mem_if.addr[3:0] == 3) begin
				$display("outbound_wr_ptr=%0d", mem_if.write_data);
				outbound_wr_ptr <= mem_if.write_data;
			end
		end
	end
	
	assign read_data = 
		(addr_r[3:0] == 0)?inbound_rd_ptr:
		(addr_r[3:0] == 1)?inbound_wr_ptr:
		(addr_r[3:0] == 2)?outbound_rd_ptr:
		(addr_r[3:0] == 3)?outbound_wr_ptr:
		0;
	
	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (QUEUE_ADDR_BITS), 
		.NUM_DATA_BITS  (32 )
		) u_ram_if ();
	
	assign u_ram_if.sram_client.addr = (mem_if.addr - 'h400);
	assign u_ram_if.sram_client.write_data = mem_if.write_data;
	
	assign mem_if.read_data = (reg_space)?read_data:u_ram_if.sram_client.read_data;
	assign u_ram_if.sram_client.write_en = (!reg_space)?mem_if.write_en:0;
	assign u_ram_if.sram_client.read_en = (!reg_space)?mem_if.read_en:0;

	
	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (QUEUE_ADDR_BITS), 
		.NUM_DATA_BITS  (32 )
		) u_ram_hw_if ();
	
	generic_sram_line_en_dualport_w #(
		.MEM_ADDR_BITS  (QUEUE_ADDR_BITS ), 
		.MEM_DATA_BITS  (32 )
		) u_ram_w (
		.i_clk          (clk          ), 
		.s_a            (u_ram_if.sram),
		.s_b			(u_ram_hw_if.sram));
	
	
	// HW interface support
	
	// Outbound pump that immediately reads one outbound word when
	// available. How do we ensure we pipeline?
	// We'll worry about pipelining later
	reg[3:0]		outbound_state;
	reg[31:0]		outbound_data;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			outbound_state <= 0;
		end else begin
			case (outbound_state)
				0: begin
				end
			endcase
		end
	end
	
	assign queue_if.outbound_data = outbound_data;
	assign queue_if.outbound_valid = (outbound_state == 2); // FIXME

	// Inbound uses a similar scheme to buffer one word of data
	reg[3:0]		inbound_state;
	reg[31:0]		inbound_data;
	
	reg				sram_inbound_req = 0;
	reg				sram_inbound_gnt = 0;
	reg				sram_outbound_req = 0;
	reg				sram_outbound_gnt = 0;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			inbound_state <= 0;
		end else begin
			case (inbound_state)
				0: begin
					if (queue_if.inbound_ready && queue_if.inbound_valid) begin
						inbound_data <= queue_if.inbound_data;
						sram_inbound_req <= 1;
						inbound_state <= 1;
					end
				end
				
				1: begin
					// TODO: Arbitrate for sram
					if (sram_inbound_gnt) begin
						inbound_state <= 2;
						sram_inbound_req <= 0;
					end
				end
				
				2: begin
					inbound_wr_ptr <= inbound_wr_ptr_next; // ((inbound_wr_ptr + 1) % QUEUE_SZ);
					inbound_state <= 0;
				end
			endcase
		end
	end
	
	// Outbound state machine
	always @(posedge clk) begin
		if (rst_n == 0) begin
			outbound_state <= 0;
		end else begin
			case (outbound_state)
				0: begin
					if (outbound_rd_ptr != outbound_wr_ptr) begin
						// Data to be provided
						sram_outbound_req <= 1;
						outbound_state <= 1;
					end
				end
				
				1: begin
					if (sram_outbound_gnt) begin
						outbound_state <= 2;
						sram_outbound_req <= 0;
					end
				end
				
				2: begin
					if (queue_if.outbound_ready && queue_if.outbound_valid) begin
						outbound_rd_ptr <= outbound_rd_ptr_next;
						outbound_state <= 0;
					end
				end
			endcase
		end
	end
	
	assign inbound_wr_ptr_next = ((inbound_wr_ptr + 1) % QUEUE_SZ);
	assign outbound_rd_ptr_next = ((outbound_rd_ptr + 1) % QUEUE_SZ);

	// SRAM state machine
	reg[2:0]		sram_state = 0;
	reg				sram_last_owner = 0; // inbound=0, outbound=1
	reg				sram_owner = 0; // inbound=0, outbound=1
	reg[31:0]		queue_outbound_data = 0;
	always @(posedge clk) begin
		if (rst_n == 0) begin
			sram_state <= 0;
		end else begin
			case (sram_state) 
				0: begin
					sram_outbound_gnt <= 0;
					if (sram_inbound_req || sram_outbound_req) begin
						if (sram_inbound_req && (sram_last_owner == 1 || !sram_outbound_req)) begin
							sram_last_owner <= 0;
							sram_inbound_gnt <= 1;
							sram_state <= 1;
						end else if (sram_outbound_req && (sram_last_owner == 0 || !sram_inbound_req)) begin
							sram_last_owner <= 1;
							sram_outbound_gnt <= 1;
							sram_state <= 2;
						end
					end
				end
			
				// Inbound
				1: begin
					sram_state <= 0;
					sram_inbound_gnt <= 0;
				end
				
				// Outbound
				2: begin
					sram_state <= 0;
					sram_outbound_gnt <= 0;
					queue_outbound_data <= u_ram_hw_if.sram_client.read_data;
				end
			endcase
		end
	end

	assign u_ram_hw_if.sram_client.addr = (sram_last_owner == 0)?inbound_wr_ptr:outbound_rd_ptr;
	assign u_ram_hw_if.sram_client.write_data = inbound_data;
	assign u_ram_hw_if.sram_client.write_en = (sram_last_owner == 0 && sram_state == 1);

	assign queue_if.inbound_ready = (inbound_state == 0 && (inbound_wr_ptr_next != inbound_rd_ptr));
	assign queue_if.outbound_valid = (outbound_state == 2);
	assign queue_if.outbound_data = queue_outbound_data;

	// Can only perform one operation at a time. Round-robin to
	// keep things as fair as possible
	/*
	reg		last_access_wr = 0;
	wire inbound_avail = 
		(inbound_wr_ptr>inbound_rd_ptr)?((QUEUE_SZ-inbound_wr_ptr-inbound_rd_ptr-2) != 0):
			((QUEUE_SZ-inbound_rd_ptr-inbound_wr_ptr-2) != 0);
	wire outbound_avail = 
		(outbound_wr_ptr>outbound_rd_ptr)?((QUEUE_SZ-outbound_wr_ptr-outbound_rd_ptr-2) != 0):
			((QUEUE_SZ-outbound_rd_ptr-outbound_wr_ptr-2) != 0);
	 */
	
//	assign queue_if.inbound_ready = inbound_avail;

endmodule

