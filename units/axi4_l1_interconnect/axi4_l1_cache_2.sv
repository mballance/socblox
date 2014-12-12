/****************************************************************************
 * axi4_l1_cache_2.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_cache_2
 * 
 * TODO: Add module documentation
 */
module axi4_l1_cache_2 #(
// Changing this parameter is the recommended
// way to change the overall cache size; 2, 4 and 8 ways are supported.
//   2 ways -> 8KB  cache
//   4 ways -> 16KB cache
//   8 ways -> 32KB cache
		parameter CACHE_WAYS = 4,
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=32
		) (
			input			clk_i,
			input			rst_n,
			axi4_if.slave	in,
			
			input [31:0]	i_snoop_addr,
			input			i_snoop_addr_valid,
			output			o_snoop_stall,
			
			output [31:0]	o_snoop_addr,
			output			o_snoop_addr_valid,
			input			i_snoop_stall,
			
			axi4_if.master	out
		);
	
//	always @(posedge clk_i) begin
//		if (out.AWVALID && out.AWREADY) begin
//			$display("%t: %m WRITE 'h%08h", $time, out.AWADDR);
//		end
//	end
	
	// Limited to Linux 4k page sizes -> 256 lines
	localparam CACHE_LINES          = 256;

	// This cannot be changed without some major surgeory on
	// this module                                       
	localparam CACHE_WORDS_PER_LINE = 4;

	// derived configuration parameters
	localparam CACHE_ADDR_WIDTH  = $clog2( CACHE_LINES );              // = 8
	localparam WORD_SEL_WIDTH    = $clog2 ( CACHE_WORDS_PER_LINE );             // = 2
	localparam TAG_ADDR_WIDTH    = 32 - CACHE_ADDR_WIDTH - WORD_SEL_WIDTH - 2;  // = 20
	localparam reg[7:0] TAG_WIDTH         = TAG_ADDR_WIDTH + 1;                 // = 21, including Valid flag
	localparam CACHE_LINE_WIDTH  = CACHE_WORDS_PER_LINE * 32;                   // = 128
	localparam TAG_ADDR32_LSB    = CACHE_ADDR_WIDTH + WORD_SEL_WIDTH + 2;       // = 12
	localparam CACHE_ADDR32_MSB  = CACHE_ADDR_WIDTH + WORD_SEL_WIDTH + 2 - 1;   // = 11
	localparam CACHE_ADDR32_LSB  =                    WORD_SEL_WIDTH + 2;       // = 4
	localparam WORD_SEL_MSB      = WORD_SEL_WIDTH + 2 - 1;                      // = 3
	localparam WORD_SEL_LSB      =                  2;                          // = 2
	
	reg [CACHE_ADDR_WIDTH-1:0]				tag_data_address;
	reg [31:TAG_ADDR32_LSB]					tag;
	reg [(WORD_SEL_MSB-WORD_SEL_LSB):0]		word_index;
	reg[AXI4_ADDRESS_WIDTH-1:4]				rw_addr;
	wire[AXI4_ADDRESS_WIDTH-1:0]			rw_addr_w;
	reg[1:0]								rw_offset;
	reg[2:0]								read_count;
	reg[$bits(in.ARID)-1:0]					id;
	reg[1:0]								way_sel_write;
	reg[1:0]								way_sel_rand;
	reg[1:0]								way_sel;
	
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			way_sel_rand <= 0;
		end else begin
			way_sel_rand <= way_sel_rand + 1;
		end
	end
	
	assign rw_addr_w = {rw_addr, rw_offset, 2'b0};

	typedef enum {
		ST_WAIT_REQ,
		ST_CHECK_RD_HIT_1,
		ST_CHECK_RD_HIT_2,
		ST_HIT_READBACK,
		ST_CHECK_WR_HIT_1,
		ST_CHECK_WR_HIT_2,
		ST_UNCACHED_AW,
		ST_UNCACHED_BR, // 7
		ST_UNCACHED_AR,
		ST_UNCACHED_RD,
		ST_UNCACHED_WR_1,
		ST_UNCACHED_WR_2,
		ST_HIT_WRITEBACK, // 12
		ST_WR_MISS,
		ST_WR_ACK,
		ST_FILL_AR,       // 15
		ST_FILL_RDATA,
		ST_FILL_STALL,
		ST_INIT_TAG_1,
		ST_INIT_TAG_2
	} rw_state_e;
	
	rw_state_e			rw_state;
	reg					arvalid;
	
`ifndef UNDEFINED
	wire ar_passthrough = (rw_state == ST_WAIT_REQ && !in.ARCACHE[1]);
//	wire aw_passthrough = (rw_state == ST_WAIT_REQ && !in.AWCACHE[1]);
	wire aw_passthrough = 1;
	
	wire rd_passthrough = (rw_state == ST_UNCACHED_RD);
	wire wr_passthrough = (rw_state == ST_UNCACHED_WR_1 || rw_state == ST_UNCACHED_WR_2);
//	wire wr_passthrough = 1;
`else
	wire ar_passthrough = 1;
	wire aw_passthrough = 1;
	
	wire rd_passthrough = 1;
	wire wr_passthrough = 1;
`endif

	wire 							tag_wenable_way[CACHE_WAYS-1:0];
	reg [TAG_WIDTH-1:0]				tag_wdata;
	reg								tag_valid;
	wire [TAG_WIDTH-2:0]			tag_rdata_way[CACHE_WAYS-1:0];
	wire          					tag_valid_way[CACHE_WAYS-1:0];
	wire          					tag_valid_wdata_way[CACHE_WAYS-1:0];
	wire							data_wenable_way[CACHE_WAYS-1:0];
	reg  [CACHE_LINE_WIDTH/8-1:0]	data_byte_enable;
	reg  [CACHE_LINE_WIDTH-1:0]		data_wdata;
	wire [CACHE_LINE_WIDTH-1:0]		data_rdata_way[CACHE_WAYS-1:0];
		
	reg								hit 		= 0;
	reg  [$clog2(CACHE_WAYS)-1:0]	hit_way 	= 0;
	wire [AXI4_DATA_WIDTH-1:0]		hit_data;
	reg  [AXI4_DATA_WIDTH-1:0]		stall_rdata = 0;
	
	wire 							snoop_tag_wenable_way[CACHE_WAYS-1:0];
	reg [TAG_WIDTH-1:0]				snoop_tag_wdata;
	wire							snoop_tag_valid_wdata;
	wire [TAG_WIDTH-2:0]			snoop_tag_rdata_way[CACHE_WAYS-1:0];
	wire          					snoop_tag_valid_way[CACHE_WAYS-1:0];
	wire          					snoop_tag_valid_wdata_way[CACHE_WAYS-1:0];
	wire							snoop_data_wenable_way[CACHE_WAYS-1:0];
	reg  [CACHE_LINE_WIDTH-1:0]		snoop_data_wdata = 0;
	wire [CACHE_LINE_WIDTH-1:0]		snoop_data_rdata_way[CACHE_WAYS-1:0];
		
	reg								snoop_hit 		= 0;
	reg  [$clog2(CACHE_WAYS)-1:0]	snoop_hit_way 	= 0;
	reg [31:TAG_ADDR32_LSB]			snoop_tag;
	reg [CACHE_ADDR_WIDTH-1:0]		snoop_tag_data_address;
//	reg [$clog2(CACHE_ADDR_WIDTH)-1:0]	init_cnt;
	
	wire [CACHE_LINE_WIDTH/8-1:0]	snoop_data_byteen;
	
	assign snoop_tag_valid_wdata = 0;
	assign snoop_data_byteen = '1;

	// Read/Write state machine
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			rw_state <= ST_INIT_TAG_1;
			rw_addr <= 0;
			rw_offset <= 0;
			read_count <= 4'b0000;
			arvalid <= 0;
			tag_data_address <= 0;
			tag_wdata <= 0;
			id <= 0;
			data_byte_enable <= 0;
			way_sel_write <= 0;
			data_wdata <= 0;
			/*
			read_length <= 4'b0000;
			read_burst <= 0;
			read_wrap_mask <= 0;
			sram_owner_c <= 0;
			read_data <= 0;
			 */
		end else begin
		
			// Catch snoops that invalidate a pending fill
			if (rw_state != ST_WAIT_REQ) begin
				if (i_snoop_addr_valid && (i_snoop_addr[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB] == tag_data_address)) begin
//					$display("%m: Invalidate in-flight fill: snoop='h%08h", i_snoop_addr);
					tag_valid <= 0;
				end
			end
			
			case (rw_state)
				// Wait for a request to come in
				ST_WAIT_REQ: begin
					read_count <= 0;
					if (in.ARVALID && in.ARREADY) begin
						if (ar_passthrough) begin
							rw_state <= ST_UNCACHED_RD;
						end else begin
							rw_state <= ST_CHECK_RD_HIT_1;
							tag_data_address <= in.ARADDR[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB];
							tag <= in.ARADDR[$bits(in.ARADDR)-1:TAG_ADDR32_LSB];
							word_index <= in.ARADDR[WORD_SEL_MSB:WORD_SEL_LSB];
							id <= in.ARID;
							rw_offset <= in.ARADDR[WORD_SEL_MSB:WORD_SEL_LSB]; // word_index
							rw_addr <= {in.ARADDR[$bits(in.ARADDR)-1:TAG_ADDR32_LSB], in.ARADDR[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB]};
							
							if (i_snoop_addr_valid && (i_snoop_addr[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB] == in.ARADDR[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB])) begin
//								$display("%m: Invalidate in-flight fill (1): snoop='h%08h", i_snoop_addr);
								tag_valid <= 0; // Just got a snoop for this line
							end else begin
								tag_valid <= 1'b1; // initial state is valid
							end
						end
					end else if (in.AWVALID && in.AWREADY) begin
						if (in.AWCACHE[1]) begin
							rw_state <= ST_CHECK_WR_HIT_1;
							tag_data_address <= in.AWADDR[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB];
							tag <= in.AWADDR[$bits(in.AWADDR)-1:TAG_ADDR32_LSB];
							word_index <= in.AWADDR[WORD_SEL_MSB:WORD_SEL_LSB];
							rw_offset <= in.AWADDR[WORD_SEL_MSB:WORD_SEL_LSB]; // word_index
							rw_addr <= {in.AWADDR[$bits(in.AWADDR)-1:TAG_ADDR32_LSB], in.AWADDR[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB]};
							id <= in.AWID;
						end else begin
							// Uncached write
							rw_state <= ST_UNCACHED_WR_1;
						end
					end
				end
				
				ST_UNCACHED_RD: begin
					if (out.RVALID && out.RREADY && out.RLAST) begin
						// Back to the top
						rw_state <= ST_WAIT_REQ;
					end
				end
				
				ST_UNCACHED_WR_1: begin
					// Response must follow the last beat
					if (out.WVALID && out.WREADY && out.WLAST) begin
						rw_state <= ST_UNCACHED_WR_2;
					end
				end
				
				ST_UNCACHED_WR_2: begin
					if (out.BVALID && out.BREADY) begin
						rw_state <= ST_WAIT_REQ;
					end
				end
				
				ST_CHECK_RD_HIT_1: begin
					rw_state <= ST_CHECK_RD_HIT_2;
				end
				
				ST_CHECK_RD_HIT_2: begin
					if (hit) begin
						// TODO:
						rw_state <= ST_HIT_READBACK;
//						$display("%t %m: read hit on 'h%0h (%0d)", $time, tag_data_address, hit_way);
						// Capture the data read from the 'hit' way
						data_wdata <= data_rdata_way[hit_way];
					end else begin
						rw_state <= ST_FILL_AR;
						read_count <= 0;
						tag_wdata <= {tag_valid, tag};
//						$display("%t %m: read miss on 'h%0h", $time, tag_data_address);
					end
				end
				
				ST_HIT_READBACK: begin
					if (in.RVALID && in.RREADY) begin
						rw_state <= ST_WAIT_REQ;
					end
				end
				
				ST_CHECK_WR_HIT_1: begin
					rw_state <= ST_CHECK_WR_HIT_2;
				end
				
				ST_CHECK_WR_HIT_2: begin
					if (hit) begin
						// TODO:
						rw_state <= ST_HIT_WRITEBACK;
						data_wdata <= data_rdata_way[hit_way];
						way_sel_write <= hit_way;
					end else begin
						rw_state <= ST_UNCACHED_WR_1;
					end
				end
				
				ST_WR_MISS: begin
					if (out.BREADY && out.BVALID) begin
						rw_state <= ST_WAIT_REQ;
					end
				end
			
				// Issue the address request
				ST_FILL_AR: begin
					if (out.ARVALID && out.ARREADY) begin
						arvalid <= 0;
						rw_state <= ST_FILL_RDATA;
						way_sel_write <= way_sel;
					end
				end
			
				// Wait for the data to come back
				ST_FILL_RDATA: begin
					if (out.RVALID && out.RREADY) begin
						data_byte_enable <= {CACHE_LINE_WIDTH/8{1'b1}};
						case (rw_offset) 
							0: data_wdata[31:0] <= out.RDATA;
							1: data_wdata[63:32] <= out.RDATA;
							2: data_wdata[95:64] <= out.RDATA;
							3: data_wdata[127:96] <= out.RDATA;
						endcase
						
						if (read_count == 3) begin
							rw_state <= ST_WAIT_REQ;
							read_count <= read_count + 1;
						end else if (read_count == 0) begin
							if (!(in.RVALID && in.RREADY)) begin
								// 
								rw_state <= ST_FILL_STALL;
								stall_rdata <= out.RDATA;
							end else begin
								// Increment once the data is accepted
								read_count <= read_count + 1;
								rw_offset <= rw_offset + 1;
							end
						end else begin
							read_count <= read_count + 1;
							rw_offset <= rw_offset + 1;
						end
					end
				end
				
				ST_FILL_STALL: begin
					if (in.RVALID && in.RREADY) begin
						// Increment once the data is accepted
						read_count <= read_count + 1;
						rw_offset <= rw_offset + 1;
						rw_state <= ST_FILL_RDATA;
					end
				end
				
				ST_HIT_WRITEBACK: begin
					if (in.WVALID && in.WREADY) begin
						// Capture data going out
						data_byte_enable <= in.WSTRB << (rw_offset * 4);
						case (rw_offset) 
							0: data_wdata[31:0] <= in.WDATA;
							1: data_wdata[63:32] <= in.WDATA;
							2: data_wdata[95:64] <= in.WDATA;
							3: data_wdata[127:96] <= in.WDATA;
						endcase
						// Initiate write
						rw_state <= ST_WR_ACK;
					end
				end
				
				ST_WR_ACK: begin
					if (in.BVALID && in.BREADY) begin
						rw_state <= ST_WAIT_REQ;
					end
				end
				
				ST_INIT_TAG_1: begin
					rw_state <= ST_INIT_TAG_2;
				end
				
				ST_INIT_TAG_2: begin
					if (tag_data_address == {CACHE_ADDR_WIDTH{1'b1}}) begin
						rw_state <= ST_WAIT_REQ;
					end else begin
						tag_data_address <= tag_data_address + 1;
						rw_state <= ST_INIT_TAG_1;
					end
				end
			endcase
		end
	end

	// Control for way write control
	generate
		genvar i;
		for (i=0; i<CACHE_WAYS; i=i+1) begin : g_tag_wenable_way
			assign tag_wenable_way[i] = 
				(((rw_state == ST_FILL_RDATA && read_count == 3) && way_sel_write == i) ||
					(rw_state == ST_INIT_TAG_1 || rw_state == ST_INIT_TAG_2));
			
			assign data_wenable_way[i] = 
				(((read_count == 4) && way_sel_write == i) ||
				 (rw_state == ST_WR_ACK && way_sel_write == i));
		end
	endgenerate
	
	typedef enum {
		SS_WAIT_REQ,
		SS_CHECK_HIT_1,
		SS_CHECK_HIT_2
	} snoop_state_e;
	
	snoop_state_e			snoop_state;
	
	// Snoop address generation
	typedef enum {
		SG_WAIT_REQ,
		SG_WAIT_ACK
	} snoop_gen_state_e;
	
	reg[31:0]				snoop_gen_addr_r;
	snoop_gen_state_e		snoop_gen_state;
	
	assign o_snoop_addr = snoop_gen_addr_r;
	assign o_snoop_addr_valid = (in.BVALID && in.BREADY);
	assign o_snoop_stall = (snoop_state != SS_WAIT_REQ);
	
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			snoop_gen_state <= SG_WAIT_REQ;
			snoop_gen_addr_r <= 0;
		end else begin
			case (snoop_gen_state) 
				SG_WAIT_REQ: begin
					if (in.AWVALID && in.AWREADY) begin
						snoop_gen_addr_r <= in.AWADDR;
						snoop_gen_state <= SG_WAIT_ACK;
					end
				end
				SG_WAIT_ACK: begin
					if (in.BVALID && in.BREADY) begin
						snoop_gen_state <= SG_WAIT_REQ;
					end
				end
			endcase
		end
	end
	
	
//	reg[31:0] snoop_addr_r;
	
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			snoop_state <= SS_WAIT_REQ;
		end else begin
			case (snoop_state)
				SS_WAIT_REQ: begin
					if (i_snoop_addr_valid) begin
						snoop_tag_data_address <= i_snoop_addr[CACHE_ADDR32_MSB:CACHE_ADDR32_LSB];
						snoop_tag <= i_snoop_addr[$bits(i_snoop_addr)-1:TAG_ADDR32_LSB];
//						snoop_addr_r <= i_snoop_addr;
						snoop_state <= SS_CHECK_HIT_1;
					end
				end
				
				SS_CHECK_HIT_1: begin
					snoop_state <= SS_CHECK_HIT_2;
				end
				
				SS_CHECK_HIT_2: begin
//					if (snoop_hit) begin
//						$display("%t %m: snoop hit on 'h%0h (%0d)", $time, snoop_tag_data_address, snoop_hit_way);
//					end else begin
//						$display("%t %m: snoop miss on 'h%0h", $time, snoop_tag_data_address);
//					end
					snoop_state <= SS_WAIT_REQ;
				end
					
			endcase
		end
	end
	
	// Control for snoop way write control
	generate
		for (i=0; i<CACHE_WAYS; i=i+1) begin : g_snoop_tag_wenable_way
			assign snoop_tag_wenable_way[i] = 
				((snoop_state == SS_CHECK_HIT_2) && snoop_hit && (snoop_hit_way == i));
		end
	endgenerate
	

	
	// Mux signals through for bypass
	assign out.AWID     = (aw_passthrough)?in.AWID:0;
	assign out.AWADDR   = (aw_passthrough)?in.AWADDR:0;
	assign out.AWLEN    = (aw_passthrough)?in.AWLEN:0;
	assign out.AWSIZE   = (aw_passthrough)?in.AWSIZE:0;
	assign out.AWBURST  = (aw_passthrough)?in.AWBURST:0;
	assign out.AWCACHE  = (aw_passthrough)?in.AWCACHE:0;
	assign out.AWLOCK	= (aw_passthrough)?in.AWLOCK:0;
	assign out.AWPROT   = (aw_passthrough)?in.AWPROT:0;
	assign out.AWQOS    = (aw_passthrough)?in.AWQOS:0;
	assign out.AWREGION = (aw_passthrough)?in.AWREGION:0;
	assign out.AWVALID  = (aw_passthrough)?
		(rw_state == ST_WAIT_REQ && in.AWVALID && !i_snoop_stall):0;
	// Do not allow a new write to start during snoop stall
	
	reg awready;
	assign in.AWREADY   = awready;
	
	always @* begin
		if (i_snoop_stall == 1) begin
			awready = 0;
		end else if (aw_passthrough == 1) begin
			awready = (rw_state == ST_WAIT_REQ && out.AWREADY);
		end else begin
			awready = (rw_state == ST_WAIT_REQ && !in.ARVALID);
		end
	end
	
	assign out.ARID     = (ar_passthrough)?in.ARID:0;
	assign out.ARADDR   = (ar_passthrough)?in.ARADDR:rw_addr_w;
	assign out.ARLEN    = (ar_passthrough)?in.ARLEN:(CACHE_WORDS_PER_LINE-1);
	assign out.ARSIZE   = (ar_passthrough)?in.ARSIZE:2; // 32-bit transfer
	assign out.ARBURST  = (ar_passthrough)?in.ARBURST:2; // wrap transfer
	assign out.ARCACHE  = (ar_passthrough)?in.ARCACHE:0;
	assign out.ARLOCK	= (ar_passthrough)?in.ARLOCK:0;
	assign out.ARPROT   = (ar_passthrough)?in.ARPROT:0;
	assign out.ARQOS    = (ar_passthrough)?in.ARQOS:0;
	assign out.ARREGION = (ar_passthrough)?in.ARREGION:0;
	assign out.ARVALID  = (ar_passthrough)?in.ARVALID:(rw_state == ST_FILL_AR);
	assign in.ARREADY   = (ar_passthrough)?out.ARREADY:(rw_state == ST_WAIT_REQ);
	

	assign in.RID       = (rd_passthrough)?out.RID:id;
	assign in.RDATA     = (rd_passthrough || rw_state == ST_FILL_RDATA)?out.RDATA:hit_data;
	assign in.RRESP     = (rd_passthrough)?out.RRESP:0;
	assign in.RLAST     = (rd_passthrough)?out.RLAST:1;
	assign in.RVALID    = (rd_passthrough)?out.RVALID:
		((rw_state == ST_FILL_RDATA && read_count == 0 && out.RVALID) ||
			(rw_state == ST_FILL_STALL) ||
			(rw_state == ST_HIT_READBACK));
	assign out.RREADY   = (rd_passthrough)?in.RREADY:
		(rw_state == ST_FILL_RDATA); // TODO:

	assign out.WDATA    = in.WDATA;
	assign out.WSTRB    = in.WSTRB;
	assign out.WLAST    = in.WLAST;
	assign out.WVALID   = (wr_passthrough)?in.WVALID:
		(in.WVALID && (rw_state == ST_UNCACHED_WR_1 || rw_state == ST_HIT_WRITEBACK));
	assign in.WREADY    = (wr_passthrough)?out.WREADY:
		(out.WREADY && (rw_state == ST_UNCACHED_WR_1 || rw_state == ST_HIT_WRITEBACK));

	assign in.BID       = (wr_passthrough)?out.BID:id;
	assign in.BRESP     = out.BRESP;
	assign in.BVALID    = (wr_passthrough)?out.BVALID:(out.BVALID && rw_state == ST_WR_ACK);
	assign out.BREADY   = (wr_passthrough)?in.BREADY:(in.BREADY && rw_state == ST_WR_ACK);
	
	always @* begin
		hit = 0;
		hit_way = 0;
//		for (int i=0; i<CACHE_WAYS; i=i+1) begin
//			if (tag_valid_way[i] && tag_rdata_way[i] == tag) begin
//				hit = 1;
//				hit_way = i;
//			end
//		end
	end
	
	always @* begin
		way_sel = way_sel_rand;
		for (int i=0; i<CACHE_WAYS; i=i+1) begin
			if (tag_valid_way[i] == 0) begin
				way_sel = i;
				break;
			end
		end
	end

	assign hit_data = 
		(rw_state == ST_FILL_STALL)?stall_rdata:
		(word_index == 0)?data_rdata_way[hit_way][31:0]:
		(word_index == 1)?data_rdata_way[hit_way][63:32]:
		(word_index == 2)?data_rdata_way[hit_way][95:64]:
		data_rdata_way[hit_way][127:96];
	
	always @* begin
		snoop_hit = 0;
		snoop_hit_way = 0;
		for (int i=0; i<CACHE_WAYS; i=i+1) begin
			if (snoop_tag_valid_way[i] && snoop_tag_rdata_way[i] == snoop_tag) begin
				snoop_hit = 1;
				snoop_hit_way = i;
			end
		end
	end
	
	generate
		for (i=0; i<CACHE_WAYS; i=i+1) begin : g_rams

			generic_sram_line_en_dualport #(
					.DATA_WIDTH                 ( TAG_WIDTH             ),
					.INITIALIZE_TO_ZERO         ( 0                     ),
					.ADDRESS_WIDTH              ( CACHE_ADDR_WIDTH      )
				) u_tag (
					.i_clk                      ( clk_i                 							),
					.i_write_data_a             ( tag_wdata											),
					.i_write_enable_a           ( tag_wenable_way[i]    							),
					.i_address_a                ( tag_data_address  		    					),
					.o_read_data_a              ( {tag_valid_way[i], tag_rdata_way[i]}				),
					
					.i_write_data_b             ( {snoop_tag_valid_wdata, snoop_tag_rdata_way[i]}	),
					.i_write_enable_b           ( snoop_tag_wenable_way[i]							),
					.i_address_b                ( snoop_tag_data_address 	    					),
					.o_read_data_b              ( {snoop_tag_valid_way[i], snoop_tag_rdata_way[i]}	)
				);
			
			// Data RAMs 
			generic_sram_byte_en_dualport #(
					.DATA_WIDTH    ( CACHE_LINE_WIDTH) ,
					.ADDRESS_WIDTH ( CACHE_ADDR_WIDTH) 
				) u_data (
					.i_clk                      ( clk_i                         ),
					.i_write_data_a             ( data_wdata                    ),
					.i_write_enable_a           ( data_wenable_way[i]           ),
					.i_address_a                ( tag_data_address              ),
					.i_byte_enable_a            ( data_byte_enable    			),
					.o_read_data_a              ( data_rdata_way[i]             ),
					
					.i_write_data_b             ( snoop_data_wdata              ),
					.i_write_enable_b           ( snoop_data_wenable_way[i]     ),
					.i_address_b                ( snoop_tag_data_address        ),
					.i_byte_enable_b            ( snoop_data_byteen				),
					.o_read_data_b              ( snoop_data_rdata_way[i]       )
				);
			
//			always @(posedge clk_i) begin
//				if (tag_wenable_way[i]) begin
//					$display("%t - %m: TAG_WRITE[%0d] 'h%0h = 'h%032h", $time, i, tag_data_address, tag_wdata);
//				end
//				if (data_wenable_way[i]) begin
//					$display("%t - %m: DAT_WRITE[%0d] 'h%0h = 'h%032h", $time, i, tag_data_address, data_wdata);
//				end
//			end
		end                                                         
	endgenerate

endmodule

