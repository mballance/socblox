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
		parameter CACHE_WAYS = 4
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

	typedef enum {
		ST_WAIT_REQ,
		ST_CHECK_RD_HIT,
		ST_CHECK_WR_HIT,
		ST_UNCACHED_AW,
		ST_UNCACHED_BR,
		ST_UNCACHED_AR,
		ST_UNCACHED_RD,
		ST_UNCACHED_WR_1,
		ST_UNCACHED_WR_2
	} rw_state_e;
	
	rw_state_e			rw_state;

	// Read/Write state machine
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			rw_state <= ST_WAIT_REQ;
			/*
			read_addr <= 0;
			read_offset <= 0;
			read_count <= 4'b0000;
			read_length <= 4'b0000;
			read_burst <= 0;
			read_wrap_mask <= 0;
			sram_owner_c <= 0;
			read_data <= 0;
			 */
		end else begin
			case (rw_state)
				// Wait for a request to come in
				ST_WAIT_REQ: begin
					if (in.ARVALID && in.ARREADY) begin
						if (ar_passthrough) begin
							rw_state <= ST_UNCACHED_RD;
						end else begin
							rw_state <= ST_CHECK_RD_HIT;
						end
					end else if (in.AWVALID && in.AWREADY) begin
						if (aw_passthrough) begin
							rw_state <= ST_UNCACHED_WR_1;
						end else begin
							rw_state <= ST_CHECK_WR_HIT;
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
				
				ST_CHECK_RD_HIT: begin
				end
				
				ST_CHECK_WR_HIT: begin
				end
			
			endcase
		end
	end

`ifdef UNDEFINED
	wire ar_passthrough = (rw_state == ST_WAIT_REQ && !in.ARCACHE[1]);
	wire aw_passthrough = (rw_state == ST_WAIT_REQ && !in.AWCACHE[1]);
	
	wire rd_passthrough = (rw_state == ST_UNCACHED_RD);
	wire wr_passthrough = (rw_state == ST_UNCACHED_WR_1 || rw_state == ST_UNCACHED_WR_2);
`else
	wire ar_passthrough = 1;
	wire aw_passthrough = 1;
	
	wire rd_passthrough = 1;
	wire wr_passthrough = 1;
`endif
	
	// Mux signals through for bypass
	assign out.AWID     = (aw_passthrough)?in.AWID:0;
	assign out.AWADDR   = (aw_passthrough)?in.AWADDR:0;
	assign out.AWLEN    = (aw_passthrough)?in.AWLEN:0;
	assign out.AWSIZE   = (aw_passthrough)?in.AWSIZE:0;
	assign out.AWBURST  = (aw_passthrough)?in.AWBURST:0;
	assign out.AWCACHE  = (aw_passthrough)?in.AWCACHE:0;
	assign out.AWPROT   = (aw_passthrough)?in.AWPROT:0;
	assign out.AWQOS    = (aw_passthrough)?in.AWQOS:0;
	assign out.AWREGION = (aw_passthrough)?in.AWREGION:0;
	assign out.AWVALID  = (aw_passthrough)?in.AWVALID:0;
	assign in.AWREADY   = (aw_passthrough)?out.AWREADY:(rw_state == ST_WAIT_REQ);
	
	assign out.ARID     = (aw_passthrough)?in.ARID:0;
	assign out.ARADDR   = (aw_passthrough)?in.ARADDR:0;
	assign out.ARLEN    = (aw_passthrough)?in.ARLEN:0;
	assign out.ARSIZE   = (aw_passthrough)?in.ARSIZE:0;
	assign out.ARBURST  = (aw_passthrough)?in.ARBURST:0;
	assign out.ARCACHE  = (aw_passthrough)?in.ARCACHE:0;
	assign out.ARPROT   = (aw_passthrough)?in.ARPROT:0;
	assign out.ARQOS    = (aw_passthrough)?in.ARQOS:0;
	assign out.ARREGION = (aw_passthrough)?in.ARREGION:0;
	assign out.ARVALID  = (aw_passthrough)?in.ARVALID:0;
	assign in.ARREADY   = (aw_passthrough)?out.ARREADY:(rw_state == ST_WAIT_REQ);
	

	assign in.RID       = (rd_passthrough)?out.RID:0;
	assign in.RDATA     = (rd_passthrough)?out.RDATA:0;
	assign in.RRESP     = (rd_passthrough)?out.RRESP:0;
	assign in.RLAST     = (rd_passthrough)?out.RLAST:0;
	assign in.RVALID    = (rd_passthrough)?out.RVALID:0;
	assign out.RREADY   = (rd_passthrough)?in.RREADY:0; // TODO:

	assign out.WDATA    = (wr_passthrough)?in.WDATA:0;
	assign out.WSTRB    = (wr_passthrough)?in.WSTRB:0;
	assign out.WLAST    = (wr_passthrough)?in.WLAST:0;
	assign out.WVALID   = (wr_passthrough)?in.WVALID:0;
	assign in.WREADY    = (wr_passthrough)?out.WREADY:0;

	assign in.BID       = (wr_passthrough)?out.BID:0;
	assign in.BRESP     = (wr_passthrough)?out.BRESP:0;
	assign in.BVALID    = (wr_passthrough)?out.BVALID:0;
	assign out.BREADY   = (wr_passthrough)?in.BREADY:0;

	// Limited to Linux 4k page sizes -> 256 lines
localparam CACHE_LINES          = 256;

// This cannot be changed without some major surgeory on
// this module                                       
localparam CACHE_WORDS_PER_LINE = 4;

// derived configuration parameters
localparam reg[7:0] CACHE_ADDR_WIDTH  = $clog2( CACHE_LINES );                        // = 8
localparam WORD_SEL_WIDTH    = $clog2 ( CACHE_WORDS_PER_LINE );               // = 2
localparam TAG_ADDR_WIDTH    = 32 - CACHE_ADDR_WIDTH - WORD_SEL_WIDTH - 2;  // = 20
localparam reg[7:0] TAG_WIDTH         = TAG_ADDR_WIDTH + 1;                          // = 21, including Valid flag
localparam CACHE_LINE_WIDTH  = CACHE_WORDS_PER_LINE * 32;                   // = 128
localparam TAG_ADDR32_LSB    = CACHE_ADDR_WIDTH + WORD_SEL_WIDTH + 2;       // = 12
localparam CACHE_ADDR32_MSB  = CACHE_ADDR_WIDTH + WORD_SEL_WIDTH + 2 - 1;   // = 11
localparam CACHE_ADDR32_LSB  =                    WORD_SEL_WIDTH + 2;       // = 4
localparam WORD_SEL_MSB      = WORD_SEL_WIDTH + 2 - 1;                      // = 3
localparam WORD_SEL_LSB      =                  2;                          // = 2

	wire 							tag_wenable_way[CACHE_WAYS-1:0];
	wire [TAG_WIDTH-1:0]			tag_wdata;
	wire [TAG_WIDTH-1:0]			tag_rdata_way[CACHE_WAYS-1:0];
	wire [CACHE_ADDR_WIDTH-1:0]		tag_address;
	wire							data_wenable_way[CACHE_WAYS-1:0];
	wire [CACHE_LINE_WIDTH-1:0]		data_wdata;
	wire [CACHE_LINE_WIDTH-1:0]		data_rdata_way[CACHE_WAYS-1:0];

	generate
		for (genvar i=0; i<CACHE_WAYS; i=i+1) begin : rams

			generic_sram_line_en #(
					.DATA_WIDTH                 ( TAG_WIDTH             ),
					.INITIALIZE_TO_ZERO         ( 1                     ),
					.ADDRESS_WIDTH              ( CACHE_ADDR_WIDTH      )
				) u_tag (
					.i_clk                      ( clk_i                 ),
					.i_write_data               ( tag_wdata             ),
					.i_write_enable             ( tag_wenable_way[i]    ),
					.i_address                  ( tag_address           ),

					.o_read_data                ( tag_rdata_way[i]      )
				);
            
			// Data RAMs 
			generic_sram_byte_en #(
					.DATA_WIDTH    ( CACHE_LINE_WIDTH) ,
					.ADDRESS_WIDTH ( CACHE_ADDR_WIDTH) 
				) u_data (
					.i_clk                      ( clk_i                         ),
					.i_write_data               ( data_wdata                    ),
					.i_write_enable             ( data_wenable_way[i]           ),
					.i_address                  ( data_address                  ),
					.i_byte_enable              ( {CACHE_LINE_WIDTH/8{1'd1}}    ),
					.o_read_data                ( data_rdata_way[i]             )
				);                                                     


/*			// Per tag-ram write-enable
			assign tag_wenable_way[i]  = tag_wenable && ( select_way[i] || source_sel[C_INIT] );

			// Per data-ram write-enable
			assign data_wenable_way[i] = (source_sel[C_FILL] && select_way[i]) || 
				(write_hit && data_hit_way[i] && c_state == CS_IDLE);
			// Per data-ram hit flag
			assign data_hit_way[i]     = tag_rdata_way[i][TAG_WIDTH-1] &&                                                  
				tag_rdata_way[i][TAG_ADDR_WIDTH-1:0] == i_address[31:TAG_ADDR32_LSB] &&  
				c_state == CS_IDLE;              */                                                 
		end                                                         
	endgenerate


endmodule

