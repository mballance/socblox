/****************************************************************************
 * axi4_l1_interconnect_2.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_interconnect_2
 * 
 * TODO: Add module documentation
 */
module axi4_l1_interconnect_2 #(
			parameter CACHE_WAYS = 4,
			parameter AXI4_ADDRESS_WIDTH = 32,
			parameter AXI4_DATA_WIDTH = 32,
			parameter AXI4_ID_WIDTH = 4
		) (
			input				clk_i,
			input				rst_n,
			axi4_if.slave		m0,

			axi4_if.slave		m1,
		
			axi4_if.master		out
		);

	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) m02ic ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) m12ic ();

	// Testbench code only
	// synopsys translate_off
	initial begin
		if ($bits(out.ARID) != $bits(m0.ARID)+1) begin
			$display("Error: bit-width problem");
		end
	end
	// synopsys translate_on
	
	wire [AXI4_ADDRESS_WIDTH-1:0]			m0_cache_i_snoop_addr;
	wire									m0_cache_i_snoop_addr_valid;
	wire									m0_cache_o_snoop_stall;
	wire [AXI4_ADDRESS_WIDTH-1:0]			m0_cache_o_snoop_addr;
	wire									m0_cache_o_snoop_addr_valid;
	wire									m0_cache_i_snoop_stall;
	
	wire [AXI4_ADDRESS_WIDTH-1:0]			m1_cache_i_snoop_addr;
	wire									m1_cache_i_snoop_addr_valid;
	wire									m1_cache_o_snoop_stall;
	wire [AXI4_ADDRESS_WIDTH-1:0]			m1_cache_o_snoop_addr;
	wire									m1_cache_o_snoop_addr_valid;
	wire									m1_cache_i_snoop_stall;
	
	assign m0_cache_i_snoop_addr = m1_cache_o_snoop_addr;
	assign m1_cache_i_snoop_addr = m0_cache_o_snoop_addr;
	assign m0_cache_i_snoop_addr_valid = m1_cache_o_snoop_addr_valid;
	assign m1_cache_i_snoop_addr_valid = m0_cache_o_snoop_addr_valid;
	assign m0_cache_i_snoop_stall = m1_cache_o_snoop_stall;
	assign m1_cache_i_snoop_stall = m0_cache_o_snoop_stall;

	axi4_l1_cache_2 #(
		.CACHE_WAYS  (CACHE_WAYS )
		) u_m0_cache (
		.clk_i          (clk_i                ), 
		.rst_n          (rst_n                ), 
		.in             	(m0                   ), 
		.i_snoop_addr		(m0_cache_i_snoop_addr),
		.i_snoop_addr_valid	(m0_cache_i_snoop_addr_valid),
		.o_snoop_stall		(m0_cache_o_snoop_stall),
		.o_snoop_addr		(m0_cache_o_snoop_addr),
		.o_snoop_addr_valid	(m0_cache_o_snoop_addr_valid),
		.i_snoop_stall		(m0_cache_i_snoop_stall),
		.out            (m02ic.slave          ));
	
	axi4_l1_cache_2 #(
		.CACHE_WAYS  (CACHE_WAYS )
		) u_m1_cache (
		.clk_i          (clk_i                ), 
		.rst_n          (rst_n                ), 
		.in             (m1                   ), 
		.i_snoop_addr		(m1_cache_i_snoop_addr),
		.i_snoop_addr_valid	(m1_cache_i_snoop_addr_valid),
		.o_snoop_stall		(m1_cache_o_snoop_stall),
		.o_snoop_addr		(m1_cache_o_snoop_addr),
		.o_snoop_addr_valid	(m1_cache_o_snoop_addr_valid),
		.i_snoop_stall		(m1_cache_i_snoop_stall),
		.out            (m12ic.slave          ));
	
	// AR arbitration
	reg						ar_last_owner   = 0;
	reg						ar_next_owner   = 0;

	// Arbitrate for AR ownership of AR output
	always @* begin
		if (m02ic.ARVALID && (ar_last_owner == 1 || !m12ic.ARVALID)) begin
			ar_next_owner = 0;
		end else if (m12ic.ARVALID && (ar_last_owner == 0 || !m02ic.ARVALID)) begin
			ar_next_owner = 1;
		end else begin
			ar_next_owner = 0;
		end
	end
	
	// Need to signal ready based on owner and out.ARVALID
	assign m02ic.ARREADY = (ar_next_owner == 0 && out.ARREADY);
	assign m12ic.ARREADY = (ar_next_owner == 1 && out.ARREADY);
	assign out.ARVALID = (ar_next_owner == 0)?m02ic.ARVALID:m12ic.ARVALID;
	assign out.ARID = {ar_next_owner, (ar_next_owner == 0)?m02ic.ARID:m12ic.ARID};
	assign out.ARADDR = (ar_next_owner == 0)?m02ic.ARADDR:m12ic.ARADDR;
	assign out.ARBURST = (ar_next_owner == 0)?m02ic.ARBURST:m12ic.ARBURST;
	assign out.ARCACHE = (ar_next_owner == 0)?m02ic.ARCACHE:m12ic.ARCACHE;
	assign out.ARLEN = (ar_next_owner == 0)?m02ic.ARLEN:m12ic.ARLEN;
	assign out.ARLOCK = (ar_next_owner == 0)?m02ic.ARLOCK:m12ic.ARLOCK;
	assign out.ARPROT = (ar_next_owner == 0)?m02ic.ARPROT:m12ic.ARPROT;
	assign out.ARQOS = (ar_next_owner == 0)?m02ic.ARQOS:m12ic.ARQOS;
	assign out.ARREGION = (ar_next_owner == 0)?m02ic.ARREGION:m12ic.ARREGION;
	assign out.ARSIZE = (ar_next_owner == 0)?m02ic.ARSIZE:m12ic.ARSIZE;

	// AR handling
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			ar_last_owner <= 0;
		end else begin
			if (out.ARVALID && out.ARREADY) begin
				ar_last_owner <= ar_next_owner;
			end
		end
	end

	// AW arbitration
	reg						aw_last_owner = 0;
	reg						aw_next_owner = 0;
	reg						wr_next_owner = 0;

	// Arbitrate for AW ownership of AW output
	always @* begin
		if (m02ic.AWVALID && (aw_last_owner == 1 || !m12ic.AWVALID)) begin
			aw_next_owner = 0;
		end else if (m12ic.AWVALID && (aw_last_owner == 0 || !m02ic.AWVALID)) begin
			aw_next_owner = 1;
		end else begin
			aw_next_owner = 0;
		end
	end
	
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			wr_next_owner <= 0;
		end else begin
			if (out.AWVALID && out.AWREADY) begin
				wr_next_owner <= aw_next_owner;
			end
		end
	end
	
	// Need to signal ready based on owner and out.AWVALID
	assign m02ic.AWREADY = (aw_next_owner == 0 && out.AWREADY);
	assign m12ic.AWREADY = (aw_next_owner == 1 && out.AWREADY);
	assign out.AWVALID = (aw_next_owner == 0)?m02ic.AWVALID:m12ic.AWVALID;
	assign out.AWID = {aw_next_owner, (aw_next_owner == 0)?m02ic.AWID:m12ic.AWID};
	assign out.AWADDR = (aw_next_owner == 0)?m02ic.AWADDR:m12ic.AWADDR;
	assign out.AWBURST = (aw_next_owner == 0)?m02ic.AWBURST:m12ic.AWBURST;
	assign out.AWCACHE = (aw_next_owner == 0)?m02ic.AWCACHE:m12ic.AWCACHE;
	assign out.AWLEN = (aw_next_owner == 0)?m02ic.AWLEN:m12ic.AWLEN;
	assign out.AWLOCK = (aw_next_owner == 0)?m02ic.AWLOCK:m12ic.AWLOCK;
	assign out.AWPROT = (aw_next_owner == 0)?m02ic.AWPROT:m12ic.AWPROT;
	assign out.AWQOS = (aw_next_owner == 0)?m02ic.AWQOS:m12ic.AWQOS;
	assign out.AWREGION = (aw_next_owner == 0)?m02ic.AWREGION:m12ic.AWREGION;
	assign out.AWSIZE = (aw_next_owner == 0)?m02ic.AWSIZE:m12ic.AWSIZE;

	// AW handling
	// Note: WDATA must follow address, so drive WDATA from AW as well
	
	// WDATA routing
	
//	assign out.WID = {wr_next_owner, (wr_next_owner == 0)?m02ic.WID:m12ic.WID};
	assign out.WDATA = (wr_next_owner == 0)?m02ic.WDATA:m12ic.WDATA;
	assign out.WSTRB = (wr_next_owner == 0)?m02ic.WSTRB:m12ic.WSTRB;
	assign out.WLAST = (wr_next_owner == 0)?m02ic.WLAST:m12ic.WLAST;
	assign out.WVALID = (wr_next_owner == 0)?m02ic.WVALID:m12ic.WVALID;
	assign m02ic.WREADY = (wr_next_owner == 0 && out.WREADY);
	assign m12ic.WREADY = (wr_next_owner == 1 && out.WREADY);
	
	// WR handling
	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			aw_last_owner <= 0;
		end else begin
			if (out.WVALID && out.WREADY && out.WLAST) begin
				aw_last_owner <= wr_next_owner;
			end
		end
	end
	
	// Write response routing
	wire wr_target = out.BID[$bits(out.RID)-1:$bits(out.RID)-1];
	assign m02ic.BID = out.BID[$bits(out.RID)-2:0];
	assign m12ic.BID = out.BID[$bits(out.RID)-2:0];
	assign m02ic.BRESP = out.BRESP;
	assign m12ic.BRESP = out.BRESP;
	assign m02ic.BVALID = (wr_target == 0 && out.BVALID);
	assign m12ic.BVALID = (wr_target == 1 && out.BVALID);
	assign out.BREADY = (wr_target == 0)?m02ic.BREADY:m12ic.BREADY;

	// RDATA routing
	wire rd_target = out.RID[$bits(out.RID)-1:$bits(out.RID)-1];
	
	assign m02ic.RDATA = out.RDATA;
	assign m12ic.RDATA = out.RDATA;
	assign m02ic.RID   = out.RID[$bits(out.RID)-2:0];
	assign m12ic.RID    = out.RID[$bits(out.RID)-2:0];
	assign m02ic.RVALID = (rd_target == 0)?out.RVALID:0;
	assign m12ic.RVALID = (rd_target == 1)?out.RVALID:0;
	assign out.RREADY = (rd_target == 0)?m02ic.RREADY:m12ic.RREADY;
	assign m02ic.RLAST = (rd_target == 0)?out.RLAST:0;
	assign m12ic.RLAST = (rd_target == 1)?out.RLAST:0;

	

endmodule

