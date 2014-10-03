/****************************************************************************
 * bidi_message_queue_direct_bfm.sv
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
interface bidi_message_queue #(
		// Total number of 32-bit words in the two queues
		parameter int QUEUE_ADDR_BITS=10
		) (
		input							clk,
		input							rst_n,
		generic_sram_line_en_if.sram	mem_if,
		bidi_message_queue_if.msg_q		queue_if,
		output							irq
		);
	
	assign queue_if.inbound_ready = 0;
	assign queue_if.outbound_data = 0;
	assign queue_if.outbound_valid = 0;
	
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
	
	
	wire reg_space = (mem_if.addr < 'h400);

	// Handle local register access
	always @(posedge clk) begin
		addr_r <= mem_if.addr;
		addr_sram_r <= (mem_if.addr - 'h400);
	
		if (mem_if.write_en && reg_space) begin
			if (mem_if.addr[3:0] == 0) begin
				inbound_rd_ptr <= mem_if.write_data;
			end
			if (mem_if.addr[3:0] == 1) begin
				inbound_wr_ptr = mem_if.write_data;
			end
			if (mem_if.addr[3:0] == 2) begin
				outbound_rd_ptr = mem_if.write_data;
			end
			if (mem_if.addr[3:0] == 3) begin
				outbound_wr_ptr <= mem_if.write_data;
			end
		end
	end
	
	assign read_data = 
		(mem_if.addr[3:0] == 0)?inbound_rd_ptr:
		(mem_if.addr[3:0] == 1)?inbound_wr_ptr:
		(mem_if.addr[3:0] == 2)?outbound_rd_ptr:
		(mem_if.addr[3:0] == 3)?outbound_wr_ptr:
		0;

	wire[31:0]				sram_addr;
	reg[31:0]				mem[0:2**QUEUE_ADDR_BITS];			
	reg[31:0]				o_read_data;
	
	assign sram_addr = (mem_if.addr - 'h400);
	always @(posedge clk) begin
		if (reg_space) begin
		 o_read_data <= (mem_if.write_en)?32'd0:read_data;
		end else begin
		 o_read_data <= (mem_if.write_en)?32'd0:mem[sram_addr];
		end
		 
		 if (mem_if.write_en && !reg_space) begin
		 	mem[sram_addr] = mem_if.write_data;
		 end
	end
	
	assign mem_if.read_data = o_read_data;
	
	reg wait_inbound_avail_req = 0;
	reg wait_outbound_avail_req = 0;
	
	always @(posedge clk) begin
		if (wait_inbound_avail_req) begin
			if (((inbound_wr_ptr+1) % QUEUE_SZ) != inbound_rd_ptr) begin
				bidi_message_queue_direct_bfm_inbound_avail_ack();
				wait_inbound_avail_req = 0;
			end
		end
		
		if (wait_outbound_avail_req) begin
			if (outbound_rd_ptr != outbound_wr_ptr) begin
				bidi_message_queue_direct_bfm_outbound_avail_ack();
				wait_outbound_avail_req = 0;
			end
		end
	end
	
	task bidi_message_queue_direct_bfm_get_queue_sz(
		output int unsigned		queue_sz);
		queue_sz = QUEUE_SZ;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_get_queue_sz;
	
	task bidi_message_queue_direct_bfm_get_inbound_ptrs(
		output int unsigned		rd_ptr,
		output int unsigned		wr_ptr);
		rd_ptr = inbound_rd_ptr;
		wr_ptr = inbound_wr_ptr;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_get_inbound_ptrs;
	
	task bidi_message_queue_direct_bfm_set_inbound_wr_ptr(
		int unsigned		wr_ptr);
		inbound_wr_ptr = wr_ptr;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_set_inbound_wr_ptr;
	
	task bidi_message_queue_direct_bfm_get_outbound_ptrs(
		output int unsigned		rd_ptr,
		output int unsigned		wr_ptr);
		rd_ptr = outbound_rd_ptr;
		wr_ptr = outbound_wr_ptr;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_get_outbound_ptrs;
	
	task bidi_message_queue_direct_bfm_set_outbound_rd_ptr(
		int unsigned		rd_ptr);
		outbound_rd_ptr = rd_ptr;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_set_outbound_rd_ptr;
	
	task bidi_message_queue_direct_bfm_set_data(
		int unsigned		offset,
		int unsigned		data);
		mem[offset] = data;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_set_data;
	
	task bidi_message_queue_direct_bfm_get_data(
		int unsigned			offset,
		output int unsigned		data);
		data = mem[offset];
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_get_data;
	
	task bidi_message_queue_direct_bfm_wait_inbound_avail();
		wait_inbound_avail_req = 1;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_wait_inbound_avail;

    import "DPI-C" context task bidi_message_queue_direct_bfm_inbound_avail_ack();

	task bidi_message_queue_direct_bfm_wait_outbound_avail();
		wait_outbound_avail_req = 1;
	endtask
	export "DPI-C" task bidi_message_queue_direct_bfm_wait_outbound_avail;

    import "DPI-C" context task bidi_message_queue_direct_bfm_outbound_avail_ack();
    
    
    import "DPI-C" context task bidi_message_queue_direct_bfm_register();
    initial begin
    	bidi_message_queue_direct_bfm_register();
    end

endinterface

