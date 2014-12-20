/****************************************************************************
 * axi4_interconnect_8x7_pt.sv
 ****************************************************************************/

/**
 * Module: axi4_interconnect_8x7_pt
 * 
 * TODO: Add module documentation
 */
 
module axi4_interconnect_8x7_pt #(
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=128,
		parameter int AXI4_ID_WIDTH=4
,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE0_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE0_ADDR_LIMIT='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE1_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE1_ADDR_LIMIT='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE2_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE2_ADDR_LIMIT='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE3_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE3_ADDR_LIMIT='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE4_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE4_ADDR_LIMIT='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE5_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE5_ADDR_LIMIT='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE6_ADDR_BASE='h0,
		parameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE6_ADDR_LIMIT='h0
		) (
		input						clk,
		input						rstn,
		axi4_if.slave					m0,
		axi4_if.slave					m1,
		axi4_if.slave					m2,
		axi4_if.slave					m3,
		axi4_if.slave					m4,
		axi4_if.slave					m5,
		axi4_if.slave					m6,
		axi4_if.slave					m7,
		axi4_if.master					s0,
		axi4_if.master					s1,
		axi4_if.master					s2,
		axi4_if.master					s3,
		axi4_if.master					s4,
		axi4_if.master					s5,
		axi4_if.master					s6,
		axi4_if.master					sdflt
		);
	
	localparam int AXI4_DATA_MSB = (AXI4_DATA_WIDTH-1);
	localparam int AXI4_WSTRB_MSB = (AXI4_DATA_WIDTH/8)-1;
	localparam int N_MASTERS = 8;
	localparam int N_SLAVES = 7;
	localparam int N_MASTERID_BITS = (N_MASTERS>1)?$clog2(N_MASTERS):1;
	localparam int N_SLAVEID_BITS = $clog2(N_SLAVES+1);
	localparam bit[N_SLAVEID_BITS:0]		NO_SLAVE  = {(N_SLAVEID_BITS+1){1'b1}};
	localparam bit[N_MASTERID_BITS:0]		NO_MASTER = {(N_MASTERID_BITS+1){1'b1}};
	localparam bit DEFAULT_SLAVE_ERROR = 0;
	
	// Interface to the decode-fail slave
`ifdef DEFAULT_SLAVE_ERROR_axi4_interconnect_8x7_pt	
/*
	axi4_if	#(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH+N_SLAVEID_BITS)
			) sdflt(.ACLK(clk), .ARESETn(rstn));
			
			 */
	axi4_if	sdflt();
`endif /* DEFAULT_SLAVE_ERROR_axi4_interconnect_8x7_pt */
	
	function reg[N_SLAVEID_BITS-1:0] addr2slave(
		reg[N_MASTERID_BITS-1:0]	master,
		reg[AXI4_ADDRESS_WIDTH-1:0] addr,
		output reg[AXI4_ADDRESS_WIDTH-1:0] addr_o
		);
		addr_o = addr;
		if (addr >= SLAVE0_ADDR_BASE && addr <= SLAVE0_ADDR_LIMIT) begin
			return 0;
		end
		if (addr >= SLAVE1_ADDR_BASE && addr <= SLAVE1_ADDR_LIMIT) begin
			return 1;
		end
		if (addr >= SLAVE2_ADDR_BASE && addr <= SLAVE2_ADDR_LIMIT) begin
			return 2;
		end
		if (addr >= SLAVE3_ADDR_BASE && addr <= SLAVE3_ADDR_LIMIT) begin
			return 3;
		end
		if (addr >= SLAVE4_ADDR_BASE && addr <= SLAVE4_ADDR_LIMIT) begin
			return 4;
		end
		if (addr >= SLAVE5_ADDR_BASE && addr <= SLAVE5_ADDR_LIMIT) begin
			return 5;
		end
		if (addr >= SLAVE6_ADDR_BASE && addr <= SLAVE6_ADDR_LIMIT) begin
			return 6;
		end
		
		return (7);
	endfunction
	
	reg[3:0]									write_req_state[N_MASTERS-1:0];
	wire[AXI4_ADDRESS_WIDTH-1:0]				AWADDR[N_MASTERS-1:0];
	wire[AXI4_ID_WIDTH-1:0]						AWID[N_MASTERS-1:0];
	wire[7:0]									AWLEN[N_MASTERS-1:0];
	wire[2:0]									AWSIZE[N_MASTERS-1:0];
	wire[1:0]									AWBURST[N_MASTERS-1:0];
	wire     									AWLOCK[N_MASTERS-1:0];
	wire[3:0]									AWCACHE[N_MASTERS-1:0];
	wire[2:0]									AWPROT[N_MASTERS-1:0];
	wire[3:0]									AWQOS[N_MASTERS-1:0];
	wire[3:0]									AWREGION[N_MASTERS-1:0];
	wire										AWREADY[N_MASTERS-1:0];
	wire										AWVALID[N_MASTERS-1:0];

	wire[AXI4_ADDRESS_WIDTH-1:0]				ARADDR[N_MASTERS-1:0];
	wire[AXI4_ID_WIDTH-1:0]						ARID[N_MASTERS-1:0];
	wire[7:0]									ARLEN[N_MASTERS-1:0];
	wire[2:0]									ARSIZE[N_MASTERS-1:0];
	wire[1:0]									ARBURST[N_MASTERS-1:0];
	wire     									ARLOCK[N_MASTERS-1:0];
	wire[3:0]									ARCACHE[N_MASTERS-1:0];
	wire[2:0]									ARPROT[N_MASTERS-1:0];
	wire[3:0]									ARQOS[N_MASTERS-1:0];
	wire[3:0]									ARREGION[N_MASTERS-1:0];
	wire										ARREADY[N_MASTERS-1:0];
	wire										ARVALID[N_MASTERS-1:0];
	
	wire[AXI4_ID_WIDTH-1:0]						BID[N_MASTERS-1:0];
	wire[1:0]									BRESP[N_MASTERS-1:0];
	wire										BVALID[N_MASTERS-1:0];
	wire										BREADY[N_MASTERS-1:0];
	
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		RID[N_MASTERS-1:0];
	wire[AXI4_DATA_WIDTH-1:0]					RDATA[N_MASTERS-1:0];
	wire[1:0]									RRESP[N_MASTERS-1:0];
	wire										RLAST[N_MASTERS-1:0];
	wire										RVALID[N_MASTERS-1:0];
	wire										RREADY[N_MASTERS-1:0];

	// Stored request
	reg[AXI4_ADDRESS_WIDTH-1:0]					R_AWADDR_i[N_MASTERS-1:0];
	reg[AXI4_ADDRESS_WIDTH-1:0]					R_AWADDR[N_MASTERS-1:0];
	reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		R_AWID[N_MASTERS-1:0];
	reg[7:0]									R_AWLEN[N_MASTERS-1:0];
	reg[2:0]									R_AWSIZE[N_MASTERS-1:0];
	reg[1:0]									R_AWBURST[N_MASTERS-1:0];
	reg     									R_AWLOCK[N_MASTERS-1:0];
	reg[3:0]									R_AWCACHE[N_MASTERS-1:0];
	reg[2:0]									R_AWPROT[N_MASTERS-1:0];
	reg[3:0]									R_AWQOS[N_MASTERS-1:0];
	reg[3:0]									R_AWREGION[N_MASTERS-1:0];
	reg											R_AWVALID[N_MASTERS-1:0];

	reg[AXI4_ADDRESS_WIDTH-1:0]					R_ARADDR_i[N_MASTERS-1:0];
	reg[AXI4_ADDRESS_WIDTH-1:0]					R_ARADDR[N_MASTERS-1:0];
	reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		R_ARID[N_MASTERS-1:0];
	reg[7:0]									R_ARLEN[N_MASTERS-1:0];
	reg[2:0]									R_ARSIZE[N_MASTERS-1:0];
	reg[1:0]									R_ARBURST[N_MASTERS-1:0];
	reg     									R_ARLOCK[N_MASTERS-1:0];
	reg[3:0]									R_ARCACHE[N_MASTERS-1:0];
	reg[2:0]									R_ARPROT[N_MASTERS-1:0];
	reg[3:0]									R_ARQOS[N_MASTERS-1:0];
	reg[3:0]									R_ARREGION[N_MASTERS-1:0];
	reg											R_ARVALID[N_MASTERS-1:0];
	
	reg[(AXI4_ID_WIDTH+N_MASTERID_BITS)-1:0]	R_SBID[N_SLAVES:0];
	reg[1:0]									R_SBRESP[N_SLAVES:0];
	reg											R_SBVALID[N_SLAVES:0];
	reg											R_SBREADY[N_SLAVES:0];
	
	wire[AXI4_DATA_MSB:0]						WDATA[N_MASTERS-1:0];
	wire[AXI4_WSTRB_MSB:0]						WSTRB[N_MASTERS-1:0];
	wire										WLAST[N_MASTERS-1:0];
	wire										WVALID[N_MASTERS-1:0];
	wire										WREADY[N_MASTERS-1:0];
	reg											write_request_busy[N_MASTERS-1:0];
	reg[N_SLAVEID_BITS:0]						write_selected_slave[N_MASTERS-1:0];

	wire[N_MASTERS-1:0]							aw_req[N_SLAVES:0];
	wire										aw_master_gnt[N_SLAVES:0];
	wire[$clog2(N_MASTERS)-1:0]					aw_master_gnt_id[N_SLAVES:0];
	
	wire[AXI4_ADDRESS_WIDTH-1:0]				SAWADDR[N_SLAVES:0];
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SAWID[N_SLAVES:0];
	wire[7:0]									SAWLEN[N_SLAVES:0];
	wire[2:0]									SAWSIZE[N_SLAVES:0];
	wire[1:0]									SAWBURST[N_SLAVES:0];
	wire     									SAWLOCK[N_SLAVES:0];
	wire[3:0]									SAWCACHE[N_SLAVES:0];
	wire[2:0]									SAWPROT[N_SLAVES:0];
	wire[3:0]									SAWQOS[N_SLAVES:0];
	wire[3:0]									SAWREGION[N_SLAVES:0];
	wire										SAWREADY[N_SLAVES:0];
	wire										SAWVALID[N_SLAVES:0];
	wire[AXI4_DATA_MSB:0]						SWDATA[N_SLAVES:0];
	wire[AXI4_WSTRB_MSB:0]						SWSTRB[N_SLAVES:0];
	wire										SWLAST[N_SLAVES:0];
	wire										SWVALID[N_SLAVES:0];
	wire										SWREADY[N_SLAVES:0];
	
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SBID[N_SLAVES:0];
	wire[1:0]									SBRESP[N_SLAVES:0];
	wire										SBVALID[N_SLAVES:0];
	wire										SBREADY[N_SLAVES:0];
	
	wire[AXI4_ADDRESS_WIDTH-1:0]				SARADDR[N_SLAVES:0];
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SARID[N_SLAVES:0];
	wire[7:0]									SARLEN[N_SLAVES:0];
	wire[2:0]									SARSIZE[N_SLAVES:0];
	wire[1:0]									SARBURST[N_SLAVES:0];
	wire     									SARLOCK[N_SLAVES:0];
	wire[3:0]									SARCACHE[N_SLAVES:0];
	wire[2:0]									SARPROT[N_SLAVES:0];
	wire[3:0]									SARQOS[N_SLAVES:0];
	wire[3:0]									SARREGION[N_SLAVES:0];
	wire										SARREADY[N_SLAVES:0];
	wire										SARVALID[N_SLAVES:0];	
	
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SRID[N_SLAVES:0];
	wire[AXI4_DATA_WIDTH-1:0]					SRDATA[N_SLAVES:0];
	wire[1:0]									SRRESP[N_SLAVES:0];
	wire										SRLAST[N_SLAVES:0];
	wire										SRVALID[N_SLAVES:0];
	wire										SRREADY[N_SLAVES:0];
	
	wire[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SRID_p[N_SLAVES:0];
	wire[AXI4_DATA_WIDTH-1:0]					SRDATA_p[N_SLAVES:0];
	wire[1:0]									SRRESP_p[N_SLAVES:0];
	wire										SRLAST_p[N_SLAVES:0];
	wire										SRVALID_p[N_SLAVES:0];
//	wire										SRREADY_p[N_SLAVES:0];
	
	reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		SRID_r[N_SLAVES:0];
	reg[AXI4_DATA_WIDTH-1:0]					SRDATA_r[N_SLAVES:0];
	reg[1:0]									SRRESP_r[N_SLAVES:0];
	reg											SRLAST_r[N_SLAVES:0];
	
// checking code
// synopsys translate_off
	initial begin
		if ($bits(s0.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s0 ID width is %0d ; expecting %0d", $bits(s0.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end
		if ($bits(s1.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s1 ID width is %0d ; expecting %0d", $bits(s1.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end
		if ($bits(s2.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s2 ID width is %0d ; expecting %0d", $bits(s2.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end
		if ($bits(s3.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s3 ID width is %0d ; expecting %0d", $bits(s3.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end
		if ($bits(s4.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s4 ID width is %0d ; expecting %0d", $bits(s4.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end
		if ($bits(s5.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s5 ID width is %0d ; expecting %0d", $bits(s5.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end
		if ($bits(s6.AWID) != AXI4_ID_WIDTH+N_MASTERID_BITS) begin
			$display("Error: %m.s6 ID width is %0d ; expecting %0d", $bits(s6.AWID), (AXI4_ID_WIDTH+N_MASTERID_BITS));
			$finish(1);
		end

	end
// synopsys translate_on
	
	// AW master assigns
	assign AWADDR[0] = m0.AWADDR;
	assign AWADDR[1] = m1.AWADDR;
	assign AWADDR[2] = m2.AWADDR;
	assign AWADDR[3] = m3.AWADDR;
	assign AWADDR[4] = m4.AWADDR;
	assign AWADDR[5] = m5.AWADDR;
	assign AWADDR[6] = m6.AWADDR;
	assign AWADDR[7] = m7.AWADDR;
	assign AWID[0] = m0.AWID;
	assign AWID[1] = m1.AWID;
	assign AWID[2] = m2.AWID;
	assign AWID[3] = m3.AWID;
	assign AWID[4] = m4.AWID;
	assign AWID[5] = m5.AWID;
	assign AWID[6] = m6.AWID;
	assign AWID[7] = m7.AWID;
	assign AWLEN[0] = m0.AWLEN;
	assign AWLEN[1] = m1.AWLEN;
	assign AWLEN[2] = m2.AWLEN;
	assign AWLEN[3] = m3.AWLEN;
	assign AWLEN[4] = m4.AWLEN;
	assign AWLEN[5] = m5.AWLEN;
	assign AWLEN[6] = m6.AWLEN;
	assign AWLEN[7] = m7.AWLEN;
	assign AWSIZE[0] = m0.AWSIZE;
	assign AWSIZE[1] = m1.AWSIZE;
	assign AWSIZE[2] = m2.AWSIZE;
	assign AWSIZE[3] = m3.AWSIZE;
	assign AWSIZE[4] = m4.AWSIZE;
	assign AWSIZE[5] = m5.AWSIZE;
	assign AWSIZE[6] = m6.AWSIZE;
	assign AWSIZE[7] = m7.AWSIZE;
	assign AWBURST[0] = m0.AWBURST;
	assign AWBURST[1] = m1.AWBURST;
	assign AWBURST[2] = m2.AWBURST;
	assign AWBURST[3] = m3.AWBURST;
	assign AWBURST[4] = m4.AWBURST;
	assign AWBURST[5] = m5.AWBURST;
	assign AWBURST[6] = m6.AWBURST;
	assign AWBURST[7] = m7.AWBURST;
	assign AWLOCK[0] = m0.AWLOCK;
	assign AWLOCK[1] = m1.AWLOCK;
	assign AWLOCK[2] = m2.AWLOCK;
	assign AWLOCK[3] = m3.AWLOCK;
	assign AWLOCK[4] = m4.AWLOCK;
	assign AWLOCK[5] = m5.AWLOCK;
	assign AWLOCK[6] = m6.AWLOCK;
	assign AWLOCK[7] = m7.AWLOCK;
	assign AWCACHE[0] = m0.AWCACHE;
	assign AWCACHE[1] = m1.AWCACHE;
	assign AWCACHE[2] = m2.AWCACHE;
	assign AWCACHE[3] = m3.AWCACHE;
	assign AWCACHE[4] = m4.AWCACHE;
	assign AWCACHE[5] = m5.AWCACHE;
	assign AWCACHE[6] = m6.AWCACHE;
	assign AWCACHE[7] = m7.AWCACHE;
	assign AWPROT[0] = m0.AWPROT;
	assign AWPROT[1] = m1.AWPROT;
	assign AWPROT[2] = m2.AWPROT;
	assign AWPROT[3] = m3.AWPROT;
	assign AWPROT[4] = m4.AWPROT;
	assign AWPROT[5] = m5.AWPROT;
	assign AWPROT[6] = m6.AWPROT;
	assign AWPROT[7] = m7.AWPROT;
	assign AWQOS[0] = m0.AWQOS;
	assign AWQOS[1] = m1.AWQOS;
	assign AWQOS[2] = m2.AWQOS;
	assign AWQOS[3] = m3.AWQOS;
	assign AWQOS[4] = m4.AWQOS;
	assign AWQOS[5] = m5.AWQOS;
	assign AWQOS[6] = m6.AWQOS;
	assign AWQOS[7] = m7.AWQOS;
	assign AWREGION[0] = m0.AWREGION;
	assign AWREGION[1] = m1.AWREGION;
	assign AWREGION[2] = m2.AWREGION;
	assign AWREGION[3] = m3.AWREGION;
	assign AWREGION[4] = m4.AWREGION;
	assign AWREGION[5] = m5.AWREGION;
	assign AWREGION[6] = m6.AWREGION;
	assign AWREGION[7] = m7.AWREGION;
	assign AWVALID[0] = m0.AWVALID;
	assign AWVALID[1] = m1.AWVALID;
	assign AWVALID[2] = m2.AWVALID;
	assign AWVALID[3] = m3.AWVALID;
	assign AWVALID[4] = m4.AWVALID;
	assign AWVALID[5] = m5.AWVALID;
	assign AWVALID[6] = m6.AWVALID;
	assign AWVALID[7] = m7.AWVALID;
	assign m0.AWREADY = AWREADY[0];
	assign m1.AWREADY = AWREADY[1];
	assign m2.AWREADY = AWREADY[2];
	assign m3.AWREADY = AWREADY[3];
	assign m4.AWREADY = AWREADY[4];
	assign m5.AWREADY = AWREADY[5];
	assign m6.AWREADY = AWREADY[6];
	assign m7.AWREADY = AWREADY[7];

	
	// W master assigns
	assign WDATA[0] = m0.WDATA;
	assign WDATA[1] = m1.WDATA;
	assign WDATA[2] = m2.WDATA;
	assign WDATA[3] = m3.WDATA;
	assign WDATA[4] = m4.WDATA;
	assign WDATA[5] = m5.WDATA;
	assign WDATA[6] = m6.WDATA;
	assign WDATA[7] = m7.WDATA;
	assign WSTRB[0] = m0.WSTRB;
	assign WSTRB[1] = m1.WSTRB;
	assign WSTRB[2] = m2.WSTRB;
	assign WSTRB[3] = m3.WSTRB;
	assign WSTRB[4] = m4.WSTRB;
	assign WSTRB[5] = m5.WSTRB;
	assign WSTRB[6] = m6.WSTRB;
	assign WSTRB[7] = m7.WSTRB;
	assign WLAST[0] = m0.WLAST;
	assign WLAST[1] = m1.WLAST;
	assign WLAST[2] = m2.WLAST;
	assign WLAST[3] = m3.WLAST;
	assign WLAST[4] = m4.WLAST;
	assign WLAST[5] = m5.WLAST;
	assign WLAST[6] = m6.WLAST;
	assign WLAST[7] = m7.WLAST;
	assign WVALID[0] = m0.WVALID;
	assign WVALID[1] = m1.WVALID;
	assign WVALID[2] = m2.WVALID;
	assign WVALID[3] = m3.WVALID;
	assign WVALID[4] = m4.WVALID;
	assign WVALID[5] = m5.WVALID;
	assign WVALID[6] = m6.WVALID;
	assign WVALID[7] = m7.WVALID;
	assign m0.WREADY = WREADY[0];
	assign m1.WREADY = WREADY[1];
	assign m2.WREADY = WREADY[2];
	assign m3.WREADY = WREADY[3];
	assign m4.WREADY = WREADY[4];
	assign m5.WREADY = WREADY[5];
	assign m6.WREADY = WREADY[6];
	assign m7.WREADY = WREADY[7];


	// B master assigns
	assign BREADY[0] = m0.BREADY;
	assign BREADY[1] = m1.BREADY;
	assign BREADY[2] = m2.BREADY;
	assign BREADY[3] = m3.BREADY;
	assign BREADY[4] = m4.BREADY;
	assign BREADY[5] = m5.BREADY;
	assign BREADY[6] = m6.BREADY;
	assign BREADY[7] = m7.BREADY;
	assign m0.BID = BID[0];
	assign m1.BID = BID[1];
	assign m2.BID = BID[2];
	assign m3.BID = BID[3];
	assign m4.BID = BID[4];
	assign m5.BID = BID[5];
	assign m6.BID = BID[6];
	assign m7.BID = BID[7];
	assign m0.BRESP = BRESP[0];
	assign m1.BRESP = BRESP[1];
	assign m2.BRESP = BRESP[2];
	assign m3.BRESP = BRESP[3];
	assign m4.BRESP = BRESP[4];
	assign m5.BRESP = BRESP[5];
	assign m6.BRESP = BRESP[6];
	assign m7.BRESP = BRESP[7];
	assign m0.BVALID = BVALID[0];
	assign m1.BVALID = BVALID[1];
	assign m2.BVALID = BVALID[2];
	assign m3.BVALID = BVALID[3];
	assign m4.BVALID = BVALID[4];
	assign m5.BVALID = BVALID[5];
	assign m6.BVALID = BVALID[6];
	assign m7.BVALID = BVALID[7];

	
	// Slave requests
	assign SAWREADY[0] = s0.AWREADY;
	assign SAWREADY[1] = s1.AWREADY;
	assign SAWREADY[2] = s2.AWREADY;
	assign SAWREADY[3] = s3.AWREADY;
	assign SAWREADY[4] = s4.AWREADY;
	assign SAWREADY[5] = s5.AWREADY;
	assign SAWREADY[6] = s6.AWREADY;
	assign SAWREADY[7] = sdflt.AWREADY;
	assign s0.AWADDR = SAWADDR[0];
	assign s1.AWADDR = SAWADDR[1];
	assign s2.AWADDR = SAWADDR[2];
	assign s3.AWADDR = SAWADDR[3];
	assign s4.AWADDR = SAWADDR[4];
	assign s5.AWADDR = SAWADDR[5];
	assign s6.AWADDR = SAWADDR[6];
	assign sdflt.AWADDR = SAWADDR[7];
	assign s0.AWID = SAWID[0];
	assign s1.AWID = SAWID[1];
	assign s2.AWID = SAWID[2];
	assign s3.AWID = SAWID[3];
	assign s4.AWID = SAWID[4];
	assign s5.AWID = SAWID[5];
	assign s6.AWID = SAWID[6];
	assign sdflt.AWID = SAWID[7];
	assign s0.AWLEN = SAWLEN[0];
	assign s1.AWLEN = SAWLEN[1];
	assign s2.AWLEN = SAWLEN[2];
	assign s3.AWLEN = SAWLEN[3];
	assign s4.AWLEN = SAWLEN[4];
	assign s5.AWLEN = SAWLEN[5];
	assign s6.AWLEN = SAWLEN[6];
	assign sdflt.AWLEN = SAWLEN[7];
	assign s0.AWSIZE = SAWSIZE[0];
	assign s1.AWSIZE = SAWSIZE[1];
	assign s2.AWSIZE = SAWSIZE[2];
	assign s3.AWSIZE = SAWSIZE[3];
	assign s4.AWSIZE = SAWSIZE[4];
	assign s5.AWSIZE = SAWSIZE[5];
	assign s6.AWSIZE = SAWSIZE[6];
	assign sdflt.AWSIZE = SAWSIZE[7];
	assign s0.AWBURST = SAWBURST[0];
	assign s1.AWBURST = SAWBURST[1];
	assign s2.AWBURST = SAWBURST[2];
	assign s3.AWBURST = SAWBURST[3];
	assign s4.AWBURST = SAWBURST[4];
	assign s5.AWBURST = SAWBURST[5];
	assign s6.AWBURST = SAWBURST[6];
	assign sdflt.AWBURST = SAWBURST[7];
	assign s0.AWLOCK = SAWLOCK[0];
	assign s1.AWLOCK = SAWLOCK[1];
	assign s2.AWLOCK = SAWLOCK[2];
	assign s3.AWLOCK = SAWLOCK[3];
	assign s4.AWLOCK = SAWLOCK[4];
	assign s5.AWLOCK = SAWLOCK[5];
	assign s6.AWLOCK = SAWLOCK[6];
	assign sdflt.AWLOCK = SAWLOCK[7];
	assign s0.AWCACHE = SAWCACHE[0];
	assign s1.AWCACHE = SAWCACHE[1];
	assign s2.AWCACHE = SAWCACHE[2];
	assign s3.AWCACHE = SAWCACHE[3];
	assign s4.AWCACHE = SAWCACHE[4];
	assign s5.AWCACHE = SAWCACHE[5];
	assign s6.AWCACHE = SAWCACHE[6];
	assign sdflt.AWCACHE = SAWCACHE[7];
	assign s0.AWPROT = SAWPROT[0];
	assign s1.AWPROT = SAWPROT[1];
	assign s2.AWPROT = SAWPROT[2];
	assign s3.AWPROT = SAWPROT[3];
	assign s4.AWPROT = SAWPROT[4];
	assign s5.AWPROT = SAWPROT[5];
	assign s6.AWPROT = SAWPROT[6];
	assign sdflt.AWPROT = SAWPROT[7];
	assign s0.AWQOS = SAWQOS[0];
	assign s1.AWQOS = SAWQOS[1];
	assign s2.AWQOS = SAWQOS[2];
	assign s3.AWQOS = SAWQOS[3];
	assign s4.AWQOS = SAWQOS[4];
	assign s5.AWQOS = SAWQOS[5];
	assign s6.AWQOS = SAWQOS[6];
	assign sdflt.AWQOS = SAWQOS[7];
	assign s0.AWREGION = SAWREGION[0];
	assign s1.AWREGION = SAWREGION[1];
	assign s2.AWREGION = SAWREGION[2];
	assign s3.AWREGION = SAWREGION[3];
	assign s4.AWREGION = SAWREGION[4];
	assign s5.AWREGION = SAWREGION[5];
	assign s6.AWREGION = SAWREGION[6];
	assign sdflt.AWREGION = SAWREGION[7];
	assign s0.AWVALID = SAWVALID[0];
	assign s1.AWVALID = SAWVALID[1];
	assign s2.AWVALID = SAWVALID[2];
	assign s3.AWVALID = SAWVALID[3];
	assign s4.AWVALID = SAWVALID[4];
	assign s5.AWVALID = SAWVALID[5];
	assign s6.AWVALID = SAWVALID[6];
	assign sdflt.AWVALID = SAWVALID[7];


	assign SWREADY[0] = s0.WREADY;
	assign SWREADY[1] = s1.WREADY;
	assign SWREADY[2] = s2.WREADY;
	assign SWREADY[3] = s3.WREADY;
	assign SWREADY[4] = s4.WREADY;
	assign SWREADY[5] = s5.WREADY;
	assign SWREADY[6] = s6.WREADY;
	assign SWREADY[7] = sdflt.WREADY;
	assign s0.WDATA = SWDATA[0];
	assign s1.WDATA = SWDATA[1];
	assign s2.WDATA = SWDATA[2];
	assign s3.WDATA = SWDATA[3];
	assign s4.WDATA = SWDATA[4];
	assign s5.WDATA = SWDATA[5];
	assign s6.WDATA = SWDATA[6];
	assign sdflt.WDATA = SWDATA[7];
	assign s0.WSTRB = SWSTRB[0];
	assign s1.WSTRB = SWSTRB[1];
	assign s2.WSTRB = SWSTRB[2];
	assign s3.WSTRB = SWSTRB[3];
	assign s4.WSTRB = SWSTRB[4];
	assign s5.WSTRB = SWSTRB[5];
	assign s6.WSTRB = SWSTRB[6];
	assign sdflt.WSTRB = SWSTRB[7];
	assign s0.WLAST = SWLAST[0];
	assign s1.WLAST = SWLAST[1];
	assign s2.WLAST = SWLAST[2];
	assign s3.WLAST = SWLAST[3];
	assign s4.WLAST = SWLAST[4];
	assign s5.WLAST = SWLAST[5];
	assign s6.WLAST = SWLAST[6];
	assign sdflt.WLAST = SWLAST[7];
	assign s0.WVALID = SWVALID[0];
	assign s1.WVALID = SWVALID[1];
	assign s2.WVALID = SWVALID[2];
	assign s3.WVALID = SWVALID[3];
	assign s4.WVALID = SWVALID[4];
	assign s5.WVALID = SWVALID[5];
	assign s6.WVALID = SWVALID[6];
	assign sdflt.WVALID = SWVALID[7];


	assign SBID[0] = s0.BID;
	assign SBID[1] = s1.BID;
	assign SBID[2] = s2.BID;
	assign SBID[3] = s3.BID;
	assign SBID[4] = s4.BID;
	assign SBID[5] = s5.BID;
	assign SBID[6] = s6.BID;
	assign SBID[7] = sdflt.BID;
	assign SBRESP[0] = s0.BRESP;
	assign SBRESP[1] = s1.BRESP;
	assign SBRESP[2] = s2.BRESP;
	assign SBRESP[3] = s3.BRESP;
	assign SBRESP[4] = s4.BRESP;
	assign SBRESP[5] = s5.BRESP;
	assign SBRESP[6] = s6.BRESP;
	assign SBRESP[7] = sdflt.BRESP;
	assign SBVALID[0] = s0.BVALID;
	assign SBVALID[1] = s1.BVALID;
	assign SBVALID[2] = s2.BVALID;
	assign SBVALID[3] = s3.BVALID;
	assign SBVALID[4] = s4.BVALID;
	assign SBVALID[5] = s5.BVALID;
	assign SBVALID[6] = s6.BVALID;
	assign SBVALID[7] = sdflt.BVALID;
	assign s0.BREADY = SBREADY[0];
	assign s1.BREADY = SBREADY[1];
	assign s2.BREADY = SBREADY[2];
	assign s3.BREADY = SBREADY[3];
	assign s4.BREADY = SBREADY[4];
	assign s5.BREADY = SBREADY[5];
	assign s6.BREADY = SBREADY[6];
	assign sdflt.BREADY = SBREADY[7];
	

// Read request state machine
	reg[3:0]									read_req_state[N_MASTERS-1:0];
	reg[N_SLAVEID_BITS:0]						read_selected_slave[N_MASTERS-1:0];
	wire[N_MASTERS-1:0]							ar_req[N_SLAVES:0];
	wire										ar_master_gnt[N_SLAVES:0];
	wire[$clog2(N_MASTERS)-1:0]					ar_master_gnt_id[N_SLAVES:0];
	
// Read request
	assign ARADDR[0] = m0.ARADDR;
	assign ARADDR[1] = m1.ARADDR;
	assign ARADDR[2] = m2.ARADDR;
	assign ARADDR[3] = m3.ARADDR;
	assign ARADDR[4] = m4.ARADDR;
	assign ARADDR[5] = m5.ARADDR;
	assign ARADDR[6] = m6.ARADDR;
	assign ARADDR[7] = m7.ARADDR;
	assign ARID[0] = m0.ARID;
	assign ARID[1] = m1.ARID;
	assign ARID[2] = m2.ARID;
	assign ARID[3] = m3.ARID;
	assign ARID[4] = m4.ARID;
	assign ARID[5] = m5.ARID;
	assign ARID[6] = m6.ARID;
	assign ARID[7] = m7.ARID;
	assign ARLEN[0] = m0.ARLEN;
	assign ARLEN[1] = m1.ARLEN;
	assign ARLEN[2] = m2.ARLEN;
	assign ARLEN[3] = m3.ARLEN;
	assign ARLEN[4] = m4.ARLEN;
	assign ARLEN[5] = m5.ARLEN;
	assign ARLEN[6] = m6.ARLEN;
	assign ARLEN[7] = m7.ARLEN;
	assign ARSIZE[0] = m0.ARSIZE;
	assign ARSIZE[1] = m1.ARSIZE;
	assign ARSIZE[2] = m2.ARSIZE;
	assign ARSIZE[3] = m3.ARSIZE;
	assign ARSIZE[4] = m4.ARSIZE;
	assign ARSIZE[5] = m5.ARSIZE;
	assign ARSIZE[6] = m6.ARSIZE;
	assign ARSIZE[7] = m7.ARSIZE;
	assign ARBURST[0] = m0.ARBURST;
	assign ARBURST[1] = m1.ARBURST;
	assign ARBURST[2] = m2.ARBURST;
	assign ARBURST[3] = m3.ARBURST;
	assign ARBURST[4] = m4.ARBURST;
	assign ARBURST[5] = m5.ARBURST;
	assign ARBURST[6] = m6.ARBURST;
	assign ARBURST[7] = m7.ARBURST;
	assign ARLOCK[0] = m0.ARLOCK;
	assign ARLOCK[1] = m1.ARLOCK;
	assign ARLOCK[2] = m2.ARLOCK;
	assign ARLOCK[3] = m3.ARLOCK;
	assign ARLOCK[4] = m4.ARLOCK;
	assign ARLOCK[5] = m5.ARLOCK;
	assign ARLOCK[6] = m6.ARLOCK;
	assign ARLOCK[7] = m7.ARLOCK;
	assign ARCACHE[0] = m0.ARCACHE;
	assign ARCACHE[1] = m1.ARCACHE;
	assign ARCACHE[2] = m2.ARCACHE;
	assign ARCACHE[3] = m3.ARCACHE;
	assign ARCACHE[4] = m4.ARCACHE;
	assign ARCACHE[5] = m5.ARCACHE;
	assign ARCACHE[6] = m6.ARCACHE;
	assign ARCACHE[7] = m7.ARCACHE;
	assign ARPROT[0] = m0.ARPROT;
	assign ARPROT[1] = m1.ARPROT;
	assign ARPROT[2] = m2.ARPROT;
	assign ARPROT[3] = m3.ARPROT;
	assign ARPROT[4] = m4.ARPROT;
	assign ARPROT[5] = m5.ARPROT;
	assign ARPROT[6] = m6.ARPROT;
	assign ARPROT[7] = m7.ARPROT;
	assign ARREGION[0] = m0.ARREGION;
	assign ARREGION[1] = m1.ARREGION;
	assign ARREGION[2] = m2.ARREGION;
	assign ARREGION[3] = m3.ARREGION;
	assign ARREGION[4] = m4.ARREGION;
	assign ARREGION[5] = m5.ARREGION;
	assign ARREGION[6] = m6.ARREGION;
	assign ARREGION[7] = m7.ARREGION;
	assign ARVALID[0] = m0.ARVALID;
	assign ARVALID[1] = m1.ARVALID;
	assign ARVALID[2] = m2.ARVALID;
	assign ARVALID[3] = m3.ARVALID;
	assign ARVALID[4] = m4.ARVALID;
	assign ARVALID[5] = m5.ARVALID;
	assign ARVALID[6] = m6.ARVALID;
	assign ARVALID[7] = m7.ARVALID;
	assign ARQOS[0] = m0.ARQOS;
	assign ARQOS[1] = m1.ARQOS;
	assign ARQOS[2] = m2.ARQOS;
	assign ARQOS[3] = m3.ARQOS;
	assign ARQOS[4] = m4.ARQOS;
	assign ARQOS[5] = m5.ARQOS;
	assign ARQOS[6] = m6.ARQOS;
	assign ARQOS[7] = m7.ARQOS;
	assign m0.ARREADY = ARREADY[0];
	assign m1.ARREADY = ARREADY[1];
	assign m2.ARREADY = ARREADY[2];
	assign m3.ARREADY = ARREADY[3];
	assign m4.ARREADY = ARREADY[4];
	assign m5.ARREADY = ARREADY[5];
	assign m6.ARREADY = ARREADY[6];
	assign m7.ARREADY = ARREADY[7];
	
	
	assign RREADY[0] = m0.RREADY;
	assign RREADY[1] = m1.RREADY;
	assign RREADY[2] = m2.RREADY;
	assign RREADY[3] = m3.RREADY;
	assign RREADY[4] = m4.RREADY;
	assign RREADY[5] = m5.RREADY;
	assign RREADY[6] = m6.RREADY;
	assign RREADY[7] = m7.RREADY;
	assign m0.RRESP = RRESP[0];
	assign m1.RRESP = RRESP[1];
	assign m2.RRESP = RRESP[2];
	assign m3.RRESP = RRESP[3];
	assign m4.RRESP = RRESP[4];
	assign m5.RRESP = RRESP[5];
	assign m6.RRESP = RRESP[6];
	assign m7.RRESP = RRESP[7];
	assign m0.RDATA = RDATA[0];
	assign m1.RDATA = RDATA[1];
	assign m2.RDATA = RDATA[2];
	assign m3.RDATA = RDATA[3];
	assign m4.RDATA = RDATA[4];
	assign m5.RDATA = RDATA[5];
	assign m6.RDATA = RDATA[6];
	assign m7.RDATA = RDATA[7];
	assign m0.RLAST = RLAST[0];
	assign m1.RLAST = RLAST[1];
	assign m2.RLAST = RLAST[2];
	assign m3.RLAST = RLAST[3];
	assign m4.RLAST = RLAST[4];
	assign m5.RLAST = RLAST[5];
	assign m6.RLAST = RLAST[6];
	assign m7.RLAST = RLAST[7];
	assign m0.RVALID = RVALID[0];
	assign m1.RVALID = RVALID[1];
	assign m2.RVALID = RVALID[2];
	assign m3.RVALID = RVALID[3];
	assign m4.RVALID = RVALID[4];
	assign m5.RVALID = RVALID[5];
	assign m6.RVALID = RVALID[6];
	assign m7.RVALID = RVALID[7];
	assign m0.RID = RID[0];
	assign m1.RID = RID[1];
	assign m2.RID = RID[2];
	assign m3.RID = RID[3];
	assign m4.RID = RID[4];
	assign m5.RID = RID[5];
	assign m6.RID = RID[6];
	assign m7.RID = RID[7];
	
	
	// Slave requests
	assign SARREADY[0] = s0.ARREADY;
	assign SARREADY[1] = s1.ARREADY;
	assign SARREADY[2] = s2.ARREADY;
	assign SARREADY[3] = s3.ARREADY;
	assign SARREADY[4] = s4.ARREADY;
	assign SARREADY[5] = s5.ARREADY;
	assign SARREADY[6] = s6.ARREADY;
	assign SARREADY[7] = sdflt.ARREADY;
	assign s0.ARADDR = SARADDR[0];
	assign s1.ARADDR = SARADDR[1];
	assign s2.ARADDR = SARADDR[2];
	assign s3.ARADDR = SARADDR[3];
	assign s4.ARADDR = SARADDR[4];
	assign s5.ARADDR = SARADDR[5];
	assign s6.ARADDR = SARADDR[6];
	assign sdflt.ARADDR = SARADDR[7];
	assign s0.ARID = SARID[0];
	assign s1.ARID = SARID[1];
	assign s2.ARID = SARID[2];
	assign s3.ARID = SARID[3];
	assign s4.ARID = SARID[4];
	assign s5.ARID = SARID[5];
	assign s6.ARID = SARID[6];
	assign sdflt.ARID = SARID[7];
	assign s0.ARLEN = SARLEN[0];
	assign s1.ARLEN = SARLEN[1];
	assign s2.ARLEN = SARLEN[2];
	assign s3.ARLEN = SARLEN[3];
	assign s4.ARLEN = SARLEN[4];
	assign s5.ARLEN = SARLEN[5];
	assign s6.ARLEN = SARLEN[6];
	assign sdflt.ARLEN = SARLEN[7];
	assign s0.ARSIZE = SARSIZE[0];
	assign s1.ARSIZE = SARSIZE[1];
	assign s2.ARSIZE = SARSIZE[2];
	assign s3.ARSIZE = SARSIZE[3];
	assign s4.ARSIZE = SARSIZE[4];
	assign s5.ARSIZE = SARSIZE[5];
	assign s6.ARSIZE = SARSIZE[6];
	assign sdflt.ARSIZE = SARSIZE[7];
	assign s0.ARBURST = SARBURST[0];
	assign s1.ARBURST = SARBURST[1];
	assign s2.ARBURST = SARBURST[2];
	assign s3.ARBURST = SARBURST[3];
	assign s4.ARBURST = SARBURST[4];
	assign s5.ARBURST = SARBURST[5];
	assign s6.ARBURST = SARBURST[6];
	assign sdflt.ARBURST = SARBURST[7];
	assign s0.ARLOCK = SARLOCK[0];
	assign s1.ARLOCK = SARLOCK[1];
	assign s2.ARLOCK = SARLOCK[2];
	assign s3.ARLOCK = SARLOCK[3];
	assign s4.ARLOCK = SARLOCK[4];
	assign s5.ARLOCK = SARLOCK[5];
	assign s6.ARLOCK = SARLOCK[6];
	assign sdflt.ARLOCK = SARLOCK[7];
	assign s0.ARCACHE = SARCACHE[0];
	assign s1.ARCACHE = SARCACHE[1];
	assign s2.ARCACHE = SARCACHE[2];
	assign s3.ARCACHE = SARCACHE[3];
	assign s4.ARCACHE = SARCACHE[4];
	assign s5.ARCACHE = SARCACHE[5];
	assign s6.ARCACHE = SARCACHE[6];
	assign sdflt.ARCACHE = SARCACHE[7];
	assign s0.ARPROT = SARPROT[0];
	assign s1.ARPROT = SARPROT[1];
	assign s2.ARPROT = SARPROT[2];
	assign s3.ARPROT = SARPROT[3];
	assign s4.ARPROT = SARPROT[4];
	assign s5.ARPROT = SARPROT[5];
	assign s6.ARPROT = SARPROT[6];
	assign sdflt.ARPROT = SARPROT[7];
	assign s0.ARREGION = SARREGION[0];
	assign s1.ARREGION = SARREGION[1];
	assign s2.ARREGION = SARREGION[2];
	assign s3.ARREGION = SARREGION[3];
	assign s4.ARREGION = SARREGION[4];
	assign s5.ARREGION = SARREGION[5];
	assign s6.ARREGION = SARREGION[6];
	assign sdflt.ARREGION = SARREGION[7];
	assign s0.ARVALID = SARVALID[0];
	assign s1.ARVALID = SARVALID[1];
	assign s2.ARVALID = SARVALID[2];
	assign s3.ARVALID = SARVALID[3];
	assign s4.ARVALID = SARVALID[4];
	assign s5.ARVALID = SARVALID[5];
	assign s6.ARVALID = SARVALID[6];
	assign sdflt.ARVALID = SARVALID[7];
	assign s0.ARQOS = SARQOS[0];
	assign s1.ARQOS = SARQOS[1];
	assign s2.ARQOS = SARQOS[2];
	assign s3.ARQOS = SARQOS[3];
	assign s4.ARQOS = SARQOS[4];
	assign s5.ARQOS = SARQOS[5];
	assign s6.ARQOS = SARQOS[6];
	assign sdflt.ARQOS = SARQOS[7];
	

	assign SRDATA[0] = s0.RDATA;
	assign SRDATA[1] = s1.RDATA;
	assign SRDATA[2] = s2.RDATA;
	assign SRDATA[3] = s3.RDATA;
	assign SRDATA[4] = s4.RDATA;
	assign SRDATA[5] = s5.RDATA;
	assign SRDATA[6] = s6.RDATA;
	assign SRDATA[7] = sdflt.RDATA;
	assign SRLAST[0] = s0.RLAST;
	assign SRLAST[1] = s1.RLAST;
	assign SRLAST[2] = s2.RLAST;
	assign SRLAST[3] = s3.RLAST;
	assign SRLAST[4] = s4.RLAST;
	assign SRLAST[5] = s5.RLAST;
	assign SRLAST[6] = s6.RLAST;
	assign SRLAST[7] = sdflt.RLAST;
	assign SRVALID[0] = s0.RVALID;
	assign SRVALID[1] = s1.RVALID;
	assign SRVALID[2] = s2.RVALID;
	assign SRVALID[3] = s3.RVALID;
	assign SRVALID[4] = s4.RVALID;
	assign SRVALID[5] = s5.RVALID;
	assign SRVALID[6] = s6.RVALID;
	assign SRVALID[7] = sdflt.RVALID;
	assign SRID[0] = s0.RID;
	assign SRID[1] = s1.RID;
	assign SRID[2] = s2.RID;
	assign SRID[3] = s3.RID;
	assign SRID[4] = s4.RID;
	assign SRID[5] = s5.RID;
	assign SRID[6] = s6.RID;
	assign SRID[7] = sdflt.RID;
	assign SRRESP[0] = s0.RRESP;
	assign SRRESP[1] = s1.RRESP;
	assign SRRESP[2] = s2.RRESP;
	assign SRRESP[3] = s3.RRESP;
	assign SRRESP[4] = s4.RRESP;
	assign SRRESP[5] = s5.RRESP;
	assign SRRESP[6] = s6.RRESP;
	assign SRRESP[7] = sdflt.RRESP;
	assign s0.RREADY = SRREADY[0];
	assign s1.RREADY = SRREADY[1];
	assign s2.RREADY = SRREADY[2];
	assign s3.RREADY = SRREADY[3];
	assign s4.RREADY = SRREADY[4];
	assign s5.RREADY = SRREADY[5];
	assign s6.RREADY = SRREADY[6];
	assign sdflt.RREADY = SRREADY[7];
	

	
	// Write request state machine
	generate
		genvar m_aw_i;
		for (m_aw_i=0; m_aw_i<N_MASTERS; m_aw_i++) begin : m_aw
			always @(posedge clk) begin
				if (rstn == 0) begin
					write_req_state[m_aw_i] <= 'b00;
					write_selected_slave[m_aw_i] <= NO_SLAVE;
					write_request_busy[m_aw_i] <= 0;
					R_AWADDR_i[m_aw_i] <= 0;
					R_AWADDR[m_aw_i] <= 0;
					R_AWBURST[m_aw_i] <= 0;
					R_AWLOCK[m_aw_i] <= 0;
					R_AWCACHE[m_aw_i] <= 0;
					R_AWID[m_aw_i] <= 0;
					R_AWLEN[m_aw_i] <= 0;
					R_AWPROT[m_aw_i] <= 0;
					R_AWQOS[m_aw_i] <= 0;
					R_AWREGION[m_aw_i] <= 0;
					R_AWSIZE[m_aw_i] <= 0;
					R_AWVALID[m_aw_i] <= 0;
				end else begin
					case (write_req_state[m_aw_i])
					// Wait receipt of a request for an available target
						'b00: begin
							if (AWREADY[m_aw_i] && AWVALID[m_aw_i] && !write_request_busy[m_aw_i]) begin
								R_AWADDR_i[m_aw_i] <= AWADDR[m_aw_i];
								// Save the master ID that this request came from
								R_AWID[m_aw_i][(N_MASTERID_BITS+AXI4_ID_WIDTH)-1:AXI4_ID_WIDTH] <= m_aw_i;
								R_AWID[m_aw_i][AXI4_ID_WIDTH-1:0] <= AWID[m_aw_i];
								R_AWLEN[m_aw_i] <= AWLEN[m_aw_i];
								R_AWSIZE[m_aw_i] <= AWSIZE[m_aw_i];
								R_AWBURST[m_aw_i] <= AWBURST[m_aw_i];
								R_AWLOCK[m_aw_i] <= AWLOCK[m_aw_i];
								R_AWCACHE[m_aw_i] <= AWCACHE[m_aw_i];
								R_AWPROT[m_aw_i] <= AWPROT[m_aw_i];
								R_AWQOS[m_aw_i] <= AWQOS[m_aw_i];
								R_AWREGION[m_aw_i] <= AWREGION[m_aw_i];
								write_request_busy[m_aw_i] <= 1'b1;
								write_req_state[m_aw_i] <= 'b01;
							end
						end
				
						// Decode state
						'b01: begin
							write_selected_slave[m_aw_i] <= addr2slave(m_aw_i, R_AWADDR_i[m_aw_i], R_AWADDR[m_aw_i]);
							// Initiate the transfer when the
							R_AWVALID[m_aw_i] <= 1;
							write_req_state[m_aw_i] <= 'b10;
						end

						// Wait for the targeted slave to become available
						'b10: begin
							if (aw_master_gnt[write_selected_slave[m_aw_i]] &&
									aw_master_gnt_id[write_selected_slave[m_aw_i]] == m_aw_i &&
									SAWREADY[write_selected_slave[m_aw_i]]) begin
								// Wait until the slave is granted and accepts the request
								R_AWVALID[m_aw_i] <= 0;
								write_req_state[m_aw_i] <= 'b11;
							end
						end
			
						// Wait for write data
						// TODO: could pipeline this with address phase, provided masters stay in order
						'b11: begin
							if (WVALID[m_aw_i] == 1'b1 && WREADY[m_aw_i] == 1'b1) begin
								if (WLAST[m_aw_i] == 1'b1) begin
									// We're done
									write_request_busy[m_aw_i] <= 1'b0;
									write_selected_slave[m_aw_i] <= NO_SLAVE;
									write_req_state[m_aw_i] <= 'b00;
								end
							end
						end
					endcase
				end
			end
		end
	endgenerate

	// Build the aw_req vector for each slave
	generate
		genvar aw_req_i, aw_req_j;

		for (aw_req_i=0; aw_req_i < N_SLAVES+1; aw_req_i++) begin : aw_req_slave
			for (aw_req_j=0; aw_req_j < N_MASTERS; aw_req_j++) begin : aw_req_master
				assign aw_req[aw_req_i][aw_req_j] = (write_selected_slave[aw_req_j] == aw_req_i);
			end
		end
	endgenerate

	generate
		genvar aw_arb_i;
		
		for (aw_arb_i=0; aw_arb_i<(N_SLAVES+1); aw_arb_i++) begin : aw_arb
			axi4_interconnect_8x7_pt_arbiter #(
				.N_REQ  (N_MASTERS)
				) 
				aw_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (aw_req[aw_arb_i]), 
					.gnt    (aw_master_gnt[aw_arb_i]),
					.gnt_id	(aw_master_gnt_id[aw_arb_i])
				);
		end
	endgenerate

	wire[N_MASTERID_BITS:0]					slave_active_master[N_SLAVES:0];

	generate
		genvar s_am_i;
		
		for (s_am_i=0; s_am_i<N_SLAVES+1; s_am_i++) begin : s_am
			assign slave_active_master[s_am_i] =
				(aw_master_gnt[s_am_i])?aw_master_gnt_id[s_am_i]:NO_MASTER;
		end
	endgenerate
	
	generate
		genvar m_w_i;
		
		for (m_w_i=0; m_w_i<N_MASTERS; m_w_i++) begin : m_w
			assign WREADY[m_w_i] = (write_selected_slave[m_w_i] != NO_SLAVE && 
										aw_master_gnt[write_selected_slave[m_w_i]] && 
										aw_master_gnt_id[write_selected_slave[m_w_i]] == m_w_i)?
										SWREADY[write_selected_slave[m_w_i]]:0;
			assign AWREADY[m_w_i] = (write_req_state[m_w_i] == 0 && write_request_busy[m_w_i] == 0);
		end
	endgenerate
	
	generate
		genvar s_w_i;
		for(s_w_i=0; s_w_i<(N_SLAVES+1); s_w_i++) begin : s_w
			assign SWDATA[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WDATA[slave_active_master[s_w_i]];
			assign SWSTRB[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WSTRB[slave_active_master[s_w_i]];
			assign SWLAST[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WLAST[slave_active_master[s_w_i]];
			assign SWVALID[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WVALID[slave_active_master[s_w_i]];
		end
	endgenerate

	generate
		genvar s_aw_i;
		for(s_aw_i=0; s_aw_i<(N_SLAVES+1); s_aw_i++) begin : SAW_assign
			assign SAWADDR[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWADDR[slave_active_master[s_aw_i]];
			assign SAWID[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWID[slave_active_master[s_aw_i]];
			assign SAWLEN[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWLEN[slave_active_master[s_aw_i]];
			assign SAWSIZE[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWSIZE[slave_active_master[s_aw_i]];
			assign SAWBURST[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWBURST[slave_active_master[s_aw_i]];
			assign SAWLOCK[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWLOCK[slave_active_master[s_aw_i]];
			assign SAWCACHE[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWCACHE[slave_active_master[s_aw_i]];
			assign SAWPROT[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWPROT[slave_active_master[s_aw_i]];
			assign SAWQOS[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWQOS[slave_active_master[s_aw_i]];
			assign SAWREGION[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWREGION[slave_active_master[s_aw_i]];
			assign SAWVALID[s_aw_i] = (slave_active_master[s_aw_i] == NO_MASTER)?0:R_AWVALID[slave_active_master[s_aw_i]];
		end
	endgenerate

	// Write response channel
	reg [N_MASTERID_BITS:0]		write_response_selected_master[N_SLAVES:0];
	wire [N_SLAVES:0]			b_req[N_MASTERS-1:0];
	wire						b_gnt[N_MASTERS-1:0];
	wire [N_SLAVEID_BITS-1:0]	b_gnt_id[N_MASTERS-1:0];
	
	generate
		genvar b_arb_i;
		
		for (b_arb_i=0; b_arb_i<N_MASTERS; b_arb_i++) begin : b_arb
			axi4_interconnect_8x7_pt_arbiter #(
				.N_REQ  (N_SLAVES+1)
				) 
				b_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (b_req[b_arb_i]), 
					.gnt    (b_gnt[b_arb_i]),
					.gnt_id	(b_gnt_id[b_arb_i])
				);
		end
	endgenerate
		
	generate
		genvar b_req_slave_i, b_req_master_i;

		for (b_req_slave_i=0; b_req_slave_i<N_SLAVES+1; b_req_slave_i++) begin : b_req_slave
			for (b_req_master_i=0; b_req_master_i<N_MASTERS; b_req_master_i++) begin : b_req_master
				assign b_req[b_req_master_i][b_req_slave_i] = (write_response_selected_master[b_req_slave_i] == b_req_master_i);
			end
		end
	endgenerate
		
	// Write response state machine
	reg[1:0]				write_response_state[N_SLAVES:0];
	
	generate
		genvar b_state_i;
		
		for (b_state_i=0; b_state_i<N_SLAVES+1; b_state_i++) begin : b_state
			always @(posedge clk) begin
				if (rstn == 0) begin
					write_response_state[b_state_i] <= 0;
					write_response_selected_master[b_state_i] <= NO_MASTER;
				end else begin
					case (write_response_state[b_state_i])
						0: begin
							if (SBREADY[b_state_i] && SBVALID[b_state_i]) begin
								R_SBID[b_state_i] <= SBID[b_state_i];
								R_SBRESP[b_state_i] <= SBRESP[b_state_i];
								
								// Issue request for targeted master
								write_response_selected_master[b_state_i] <= SBID[b_state_i][(AXI4_ID_WIDTH+N_MASTERID_BITS-1):AXI4_ID_WIDTH];
								write_response_state[b_state_i] <= 1;
								R_SBVALID[b_state_i] <= 1;
							end
						end
						
						1: begin
							if (b_gnt[write_response_selected_master[b_state_i]] &&
									b_gnt_id[write_response_selected_master[b_state_i]] == b_state_i &&
									BREADY[write_response_selected_master[b_state_i]]) begin
								R_SBVALID[b_state_i] <= 0;
								write_response_selected_master[b_state_i] <= NO_MASTER;
								write_response_state[b_state_i] <= 0;
							end
						end
					endcase
				end
			end
		end
	endgenerate
		
	generate
		genvar b_assign_i;
	
		for (b_assign_i=0; b_assign_i<N_SLAVES+1; b_assign_i++) begin : b_assign
			assign SBREADY[b_assign_i] = (write_response_state[b_assign_i] == 0);
		end
	endgenerate
		
	wire[N_SLAVEID_BITS:0]						b_slave_master_id[N_MASTERS-1:0];

	// Determine which slave should be driven the write response channel for each master
	// based on the slave->master grant
	generate
		genvar b_slave_master_i;
		
		for (b_slave_master_i=0; b_slave_master_i<N_MASTERS; b_slave_master_i++) begin : b_slave_master
			assign b_slave_master_id[b_slave_master_i] = 
				(b_gnt[b_slave_master_i])?b_gnt_id[b_slave_master_i]:NO_SLAVE;
		end
	endgenerate
		
	generate
		genvar b_master_assign_i;
	
		for (b_master_assign_i=0; b_master_assign_i<N_MASTERS; b_master_assign_i++) begin : b_master_assign
			assign BID[b_master_assign_i] = (b_slave_master_id[b_master_assign_i] == NO_SLAVE)?0:R_SBID[b_slave_master_id[b_master_assign_i]];
			assign BVALID[b_master_assign_i] = (b_slave_master_id[b_master_assign_i] == NO_SLAVE)?0:R_SBVALID[b_slave_master_id[b_master_assign_i]];
			assign BRESP[b_master_assign_i] = (b_slave_master_id[b_master_assign_i] == NO_SLAVE)?0:R_SBRESP[b_slave_master_id[b_master_assign_i]];
		end
	endgenerate

		

	
	generate
		genvar m_ar_i;
		for (m_ar_i=0; m_ar_i<N_MASTERS; m_ar_i++) begin : m_ar
			assign ARREADY[m_ar_i] = (rstn != 0 && read_req_state[m_ar_i] == 0);
			always @(posedge clk) begin
				if (rstn == 0) begin
					read_req_state[m_ar_i] <= 'b00;
					read_selected_slave[m_ar_i] <= NO_SLAVE;
					R_ARADDR_i[m_ar_i] <= 0;
					R_ARADDR[m_ar_i] <= 0;
					R_ARBURST[m_ar_i] <= 0;
					R_ARLOCK[m_ar_i] <= 0;
					R_ARCACHE[m_ar_i] <= 0;
					R_ARID[m_ar_i] <= 0;
					R_ARLEN[m_ar_i] <= 0;
					R_ARPROT[m_ar_i] <= 0;
					R_ARQOS[m_ar_i] <= 0;
					R_ARREGION[m_ar_i] <= 0;
					R_ARSIZE[m_ar_i] <= 0;
					R_ARVALID[m_ar_i] <= 0;
				end else begin
					case (read_req_state[m_ar_i])
						// Wait receipt of a request for an available target
						'b00: begin
							if (ARREADY[m_ar_i] && ARVALID[m_ar_i]) begin
								R_ARADDR_i[m_ar_i] <= ARADDR[m_ar_i];
								// Save the master ID that this request came from
								R_ARID[m_ar_i][(N_MASTERID_BITS+AXI4_ID_WIDTH)-1:AXI4_ID_WIDTH] <= m_ar_i;
								R_ARID[m_ar_i][AXI4_ID_WIDTH-1:0] <= ARID[m_ar_i];
								R_ARLEN[m_ar_i] <= ARLEN[m_ar_i];
								R_ARSIZE[m_ar_i] <= ARSIZE[m_ar_i];
								R_ARBURST[m_ar_i] <= ARBURST[m_ar_i];
								R_ARLOCK[m_ar_i] <= ARLOCK[m_ar_i];
								R_ARCACHE[m_ar_i] <= ARCACHE[m_ar_i];
								R_ARPROT[m_ar_i] <= ARPROT[m_ar_i];
								R_ARQOS[m_ar_i] <= ARQOS[m_ar_i];
								R_ARREGION[m_ar_i] <= ARREGION[m_ar_i];
								read_req_state[m_ar_i] <= 'b01;
							end
						end
				
						// Decode state
						'b01: begin
							read_selected_slave[m_ar_i] <= addr2slave(m_ar_i, R_ARADDR_i[m_ar_i], R_ARADDR[m_ar_i]);
							// Initiate the transfer when the
							R_ARVALID[m_ar_i] <= 1;
							read_req_state[m_ar_i] <= 'b10;
						end

						// Wait for the targeted slave to become available
						'b10: begin
							if (ar_master_gnt[read_selected_slave[m_ar_i]] &&
									ar_master_gnt_id[read_selected_slave[m_ar_i]] == m_ar_i &&
									SARREADY[read_selected_slave[m_ar_i]]) begin
								// Wait until the slave is granted and accepts the request
								// After that we're done
								R_ARVALID[m_ar_i] <= 0;
								read_selected_slave[m_ar_i] <= NO_SLAVE;
								read_req_state[m_ar_i] <= 0;
							end
						end
					endcase
				end
			end
		end
	endgenerate
		
		
	// Build the ar_req vector for each slave
	generate
		genvar ar_req_i, ar_req_j;

		for (ar_req_i=0; ar_req_i < N_SLAVES+1; ar_req_i++) begin : ar_req_slave
			for (ar_req_j=0; ar_req_j < N_MASTERS; ar_req_j++) begin : ar_req_master
				assign ar_req[ar_req_i][ar_req_j] = (read_selected_slave[ar_req_j] == ar_req_i);
			end
		end
	endgenerate

	generate
		genvar ar_arb_i;
		
		for (ar_arb_i=0; ar_arb_i<(N_SLAVES+1); ar_arb_i++) begin : ar_arb
			axi4_interconnect_8x7_pt_arbiter #(
				.N_REQ  (N_MASTERS)
				) 
				ar_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (ar_req[ar_arb_i]), 
					.gnt    (ar_master_gnt[ar_arb_i]),
					.gnt_id	(ar_master_gnt_id[ar_arb_i])
					);
		end
	endgenerate		

	wire[N_MASTERID_BITS:0]					slave_active_read_master[N_SLAVES:0];

	generate
		genvar s_ar_m_i;
		
		for (s_ar_m_i=0; s_ar_m_i<N_SLAVES+1; s_ar_m_i++) begin : s_ar_m
			assign slave_active_read_master[s_ar_m_i] =
				(ar_master_gnt[s_ar_m_i])?ar_master_gnt_id[s_ar_m_i]:NO_MASTER;
		end
	endgenerate

	generate
		genvar s_ar_i;
	
		for(s_ar_i=0; s_ar_i<(N_SLAVES+1); s_ar_i++) begin : SAR_assign
			assign SARADDR[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARADDR[slave_active_read_master[s_ar_i]];
			assign SARID[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARID[slave_active_read_master[s_ar_i]];
			assign SARLEN[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARLEN[slave_active_read_master[s_ar_i]];
			assign SARSIZE[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARSIZE[slave_active_read_master[s_ar_i]];
			assign SARBURST[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARBURST[slave_active_read_master[s_ar_i]];
			assign SARLOCK[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARLOCK[slave_active_read_master[s_ar_i]];
			assign SARCACHE[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARCACHE[slave_active_read_master[s_ar_i]];
			assign SARPROT[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARPROT[slave_active_read_master[s_ar_i]];
			assign SARQOS[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARQOS[slave_active_read_master[s_ar_i]];
			assign SARREGION[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARREGION[slave_active_read_master[s_ar_i]];
			assign SARVALID[s_ar_i] = (slave_active_read_master[s_ar_i] == NO_MASTER)?0:R_ARVALID[slave_active_read_master[s_ar_i]];
		end
	endgenerate

	// Read response channel
	reg [N_MASTERID_BITS:0]		read_response_selected_master[N_SLAVES:0];
	wire [N_SLAVES:0]			r_req[N_MASTERS-1:0];
	wire						r_gnt[N_MASTERS-1:0];
	wire [N_SLAVEID_BITS-1:0]	r_gnt_id[N_MASTERS-1:0];
	
	generate
		genvar r_arb_i;
		
		for (r_arb_i=0; r_arb_i<N_MASTERS; r_arb_i++) begin : r_arb
			axi4_interconnect_8x7_pt_arbiter #(
				.N_REQ  (N_SLAVES+1)
				) 
			r_arb (
				.clk    (clk   ), 
				.rstn   (rstn  ), 
				.req    (r_req[r_arb_i]), 
				.gnt    (r_gnt[r_arb_i]),
				.gnt_id	(r_gnt_id[r_arb_i])
				);
		end
	endgenerate
		
	generate
		genvar r_req_slave_i, r_req_master_i;

		for (r_req_slave_i=0; r_req_slave_i<N_SLAVES+1; r_req_slave_i++) begin : r_req_slave
			for (r_req_master_i=0; r_req_master_i<N_MASTERS; r_req_master_i++) begin : r_req_master
				assign r_req[r_req_master_i][r_req_slave_i] = (read_response_selected_master[r_req_slave_i] == r_req_master_i);
			end
		end
	endgenerate
		
	// Read response state machine
	reg[1:0]				read_response_state[N_SLAVES:0];
	
	generate
		genvar r_state_i;
		
		for (r_state_i=0; r_state_i<N_SLAVES+1; r_state_i++) begin : r_state
			always @(posedge clk) begin
				if (rstn == 0) begin
					read_response_state[r_state_i] <= 0;
					read_response_selected_master[r_state_i] <= NO_MASTER;
				end else begin
					case (read_response_state[r_state_i])
						0: begin
							if (SRVALID[r_state_i]) begin
								// Issue request for targeted master
								read_response_selected_master[r_state_i] <= SRID[r_state_i][(AXI4_ID_WIDTH+N_MASTERID_BITS-1):AXI4_ID_WIDTH];
								read_response_state[r_state_i] <= 1;
								
								// Capture initial request
								SRID_r[r_state_i] <= SRID[r_state_i];
								SRDATA_r[r_state_i] <= SRDATA[r_state_i];
								SRRESP_r[r_state_i] <= SRRESP[r_state_i];
								SRLAST_r[r_state_i] <= SRLAST[r_state_i];
							end
						end
						
						1: begin
							if (r_gnt[read_response_selected_master[r_state_i]] &&
									r_gnt_id[read_response_selected_master[r_state_i]] == r_state_i) begin
								// Slave now connected to selected master
								read_response_state[r_state_i] <= 2;
							end
						end
					
						// State in which the registered initial request is passed to the master
						2: begin
							if (RREADY[read_response_selected_master[r_state_i]]) begin
								if (SRLAST_p[r_state_i]) begin
									read_response_selected_master[r_state_i] <= NO_MASTER;
									read_response_state[r_state_i] <= 0;
								end else begin
									read_response_state[r_state_i] <= 3;
								end
							end 
						end
					
						// State in which we are connected directly to the selected master
						3: begin
							if (SRREADY[r_state_i] && SRVALID[r_state_i] && SRLAST[r_state_i]) begin
								// Done
								read_response_selected_master[r_state_i] <= NO_MASTER;
								read_response_state[r_state_i] <= 0;
							end
						end
					endcase
				end
			end
		end
	endgenerate
		
	generate
		genvar r_assign_i;
	
		for (r_assign_i=0; r_assign_i<N_SLAVES+1; r_assign_i++) begin : r_assign
			assign SRID_p[r_assign_i] = (read_response_state[r_assign_i] == 3)?SRID[r_assign_i]:(read_response_state[r_assign_i] == 2)?SRID_r[r_assign_i]:0;
			assign SRDATA_p[r_assign_i] = (read_response_state[r_assign_i] == 3)?SRDATA[r_assign_i]:(read_response_state[r_assign_i] == 2)?SRDATA_r[r_assign_i]:0;
			assign SRRESP_p[r_assign_i] = (read_response_state[r_assign_i] == 3)?SRRESP[r_assign_i]:(read_response_state[r_assign_i] == 2)?SRRESP_r[r_assign_i]:0;
			assign SRLAST_p[r_assign_i] = (read_response_state[r_assign_i] == 3)?SRLAST[r_assign_i]:(read_response_state[r_assign_i] == 2)?SRLAST_r[r_assign_i]:0;
			assign SRVALID_p[r_assign_i] = (read_response_state[r_assign_i] == 3)?SRVALID[r_assign_i]:(read_response_state[r_assign_i] == 2)?1:0;
			assign SRREADY[r_assign_i] = (read_response_state[r_assign_i] == 3)?RREADY[read_response_selected_master[r_assign_i]]:(read_response_state[r_assign_i] == 0);
//			assign SRREADY[r_assign_i] = (read_response_state[r_assign_i] == 3)?SRREADY_p[r_assign_i]:(read_response_state[r_assign_i] == 2)?1:0;

//			assign SRREADY[r_assign_i] = (read_response_state[r_assign_i] == 2)?RREADY[read_response_selected_master[r_assign_i]]:0;
			// 
//			assign SRREADY[r_assign_i] = (read_response_state[r_assign_i] == 0)?1:(read_response_state[r_assign_i] == 1)?0:RREADY[read_response_selected_master[r_assign_i]];
		end
	endgenerate
		
	wire[N_SLAVEID_BITS:0]						r_slave_master_id[N_MASTERS-1:0];

	// Determine which slave should be driven the write response channel for each master
	// based on the slave->master grant
	generate
		genvar r_slave_master_i;
		
		for (r_slave_master_i=0; r_slave_master_i<N_MASTERS; r_slave_master_i++) begin : r_slave_master
			assign r_slave_master_id[r_slave_master_i] = 
				(r_gnt[r_slave_master_i])?r_gnt_id[r_slave_master_i]:NO_SLAVE;
		end
	endgenerate
		
	generate
		genvar r_master_assign_i;
	
		for (r_master_assign_i=0; r_master_assign_i<N_MASTERS; r_master_assign_i++) begin : r_master_assign
			assign RID[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRID_p[r_slave_master_id[r_master_assign_i]];
			assign RVALID[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRVALID_p[r_slave_master_id[r_master_assign_i]];
			assign RRESP[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRRESP_p[r_slave_master_id[r_master_assign_i]];
			assign RLAST[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRLAST_p[r_slave_master_id[r_master_assign_i]];
			assign RDATA[r_master_assign_i] = (r_slave_master_id[r_master_assign_i] == NO_SLAVE)?0:SRDATA_p[r_slave_master_id[r_master_assign_i]];
		end
	endgenerate

	// Decode-fail target
`ifdef DEFAULT_SLAVE_ERROR_axi4_interconnect_8x7_pt	
			reg[1:0]									write_state;
			reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		write_id;
			assign sdflt.AWREADY = (write_state == 0);
			assign sdflt.WREADY = (write_state == 1);
			assign sdflt.BVALID = (write_state == 2);
			assign sdflt.BID = (write_state == 2)?write_id:0;

			always @(posedge clk) begin
				if (rstn != 1) begin
					write_state <= 0;
					write_id <= 0;
				end else begin
					case (write_state)
						2'b00: begin
							if (sdflt.AWVALID) begin
								write_id <= sdflt.AWID;
								write_state <= 1;
							end
						end
				
						2'b01: begin
							if (sdflt.WVALID == 1'b1 && sdflt.WREADY == 1'b1) begin
								if (sdflt.WLAST == 1'b1) begin
									write_state <= 2;
								end
							end
						end
				
						2'b10: begin // Send write response
							if (sdflt.BVALID == 1'b1 && sdflt.BREADY == 1'b1) begin
								write_state <= 2'b0;
							end
						end
					endcase
				end
			end
	
			reg[1:0]									read_state;
			reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		read_id;
			reg[7:0]									read_count;
			reg[7:0]									read_length;
			assign sdflt.ARREADY = (read_state == 0);
			assign sdflt.RVALID = (read_state == 1);
			assign sdflt.RDATA = 0;
			assign sdflt.RLAST = (read_state == 1 && read_count == read_length);
			assign sdflt.RID = (read_state == 1)?read_id:0;
			assign sdflt.RRESP = 0;
	
			always @(posedge clk) begin
				if (rstn != 1) begin
					read_state <= 0;
					read_count <= 0;
					read_length <= 0;
					read_id <= 0;
				end else begin
					case (read_state)
						0: begin
							if (sdflt.ARVALID && sdflt.ARREADY) begin
								read_state <= 1;
								read_id <= sdflt.ARID;
								read_count <= 0;
								read_length <= sdflt.ARLEN;
							end
						end
				
						1: begin
							if (sdflt.RVALID && sdflt.RREADY) begin
								if (read_count == read_length) begin
									read_state <= 1'b0;
								end else begin
									read_count <= read_count + 1;
								end
							end
						end
					endcase
				end
			end
`endif /* DEFAULT_SLAVE_ERROR_axi4_interconnect_8x7_pt */

endmodule

module axi4_interconnect_8x7_pt_arbiter_2 #(
		parameter int			N_REQ=2
		) (
		input						clk,
		input						rstn,
		input[N_REQ-1:0]			req,
		output						gnt,
		output[$clog2(N_REQ)-1:0]	gnt_id
		);
	
	reg state;
	
	reg [N_REQ-1:0]	gnt_o;
	reg [N_REQ-1:0]	last_gnt;
//	reg [$clog2(N_REQ)-1:0] gnt_id_o;
	reg						gnt_r = 0;
	reg [((N_REQ>1)?($clog2(N_REQ)-1):0):0] gnt_id_r = 0;
	reg [((N_REQ>1)?($clog2(N_REQ)-1):0):0] gnt_id_next;
	
	assign gnt = gnt_r; // (gnt_id_r != {N_REQ{1'b1}}); // |gnt_o;
	assign gnt_id = gnt_id_r;

	reg[N_REQ-1:0] req_mask;
	always @* begin
		req_mask = (gnt_id_r == N_REQ-1)?0:(1 << (gnt_id_r+1));
		gnt_id_next = 0;
		for (int i=0; i<N_REQ; i=i+1) begin
			if (req & req_mask) begin
				gnt_id_next = gnt_id_r+i;
				break;
			end else begin
				if (req_mask[N_REQ-1]) begin
					req_mask = 1;
				end else begin
					req_mask = (N_REQ>1)?{req_mask[N_REQ-2:0], 1'b0}:0;
				end
			end
		end
	end
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			last_gnt <= 0;
			gnt_r <= 0;
			gnt_id_r <= 0;
		end else begin
			case (state) 
				0: begin
					if (|req) begin
						state <= 1;
						gnt_r <= 1;
						gnt_id_r <= gnt_id_next;
					end
				end
				
				1: begin
					if ((req & (1 << gnt_id_r)) == 0) begin
						state <= 0;
						gnt_r <= 0;
					end
				end
			endcase
		end
	end

endmodule

module axi4_interconnect_8x7_pt_arbiter #(
		parameter int			N_REQ=2
		) (
		input						clk,
		input						rstn,
		input[N_REQ-1:0]			req,
		output						gnt,
		output[$clog2(N_REQ)-1:0]	gnt_id
		);
	
	reg state;
	
	reg [N_REQ-1:0]	gnt_o;
	reg [N_REQ-1:0]	last_gnt;
	reg [$clog2(N_REQ)-1:0] gnt_id_o;
	assign gnt = |gnt_o;
	assign gnt_id = gnt_id_o;
	
	wire[N_REQ-1:0] gnt_ppc;
	wire[N_REQ-1:0]	gnt_ppc_next;

	generate
		if (N_REQ > 1) begin
			assign gnt_ppc_next = {gnt_ppc[N_REQ-2:0], 1'b0};
		end else begin
			assign gnt_ppc_next = gnt_ppc;
		end
	endgenerate

	generate
		genvar gnt_ppc_i;
		
	for (gnt_ppc_i=N_REQ-1; gnt_ppc_i>=0; gnt_ppc_i--) begin : gnt_ppc_genblk
		if (gnt_ppc_i == 0) begin
			assign gnt_ppc[gnt_ppc_i] = last_gnt[0];
		end else begin
			assign gnt_ppc[gnt_ppc_i] = |last_gnt[gnt_ppc_i-1:0];
		end
	end
	endgenerate
	
		wire[N_REQ-1:0]		unmasked_gnt;
	generate
		genvar unmasked_gnt_i;
		
	for (unmasked_gnt_i=0; unmasked_gnt_i<N_REQ; unmasked_gnt_i++) begin : unmasked_gnt_genblk
		// Prioritized unmasked grant vector. Grant to the lowest active grant
		if (unmasked_gnt_i == 0) begin
			assign unmasked_gnt[unmasked_gnt_i] = req[unmasked_gnt_i];
		end else begin
			assign unmasked_gnt[unmasked_gnt_i] = (req[unmasked_gnt_i] & ~(|req[unmasked_gnt_i-1:0]));
		end
	end
	endgenerate
	
		wire[N_REQ-1:0]		masked_gnt;
	generate
		genvar masked_gnt_i;
		
	for (masked_gnt_i=0; masked_gnt_i<N_REQ; masked_gnt_i++) begin : masked_gnt_genblk
		if (masked_gnt_i == 0) begin
			assign masked_gnt[masked_gnt_i] = (gnt_ppc_next[masked_gnt_i] & req[masked_gnt_i]);
		end else begin
			// Select first request above the last grant
			assign masked_gnt[masked_gnt_i] = (gnt_ppc_next[masked_gnt_i] & req[masked_gnt_i] & 
					~(|(gnt_ppc_next[masked_gnt_i-1:0] & req[masked_gnt_i-1:0])));
		end
	end
	endgenerate
	
		wire[N_REQ-1:0] prioritized_gnt;

	// Give priority to the 'next' request
	assign prioritized_gnt = (|masked_gnt)?masked_gnt:unmasked_gnt;
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			last_gnt <= 0;
			gnt_o <= 0;
			gnt_id_o <= 0;
		end else begin
			case (state) 
				0: begin
					if (|prioritized_gnt) begin
						state <= 1;
						gnt_o <= prioritized_gnt;
						last_gnt <= prioritized_gnt;
						gnt_id_o <= gnt2id(prioritized_gnt);
					end
				end
				
				1: begin
					if ((gnt_o & req) == 0) begin
						state <= 0;
						gnt_o <= 0;
					end
				end
			endcase
		end
	end

	function reg[$clog2(N_REQ)-1:0] gnt2id(reg[N_REQ-1:0] gnt);
		automatic int i;
//		static reg[$clog2(N_REQ)-1:0] result;
		reg[$clog2(N_REQ)-1:0] result;
		
		result = 0;
		
		for (i=0; i<N_REQ; i++) begin
			if (gnt[i]) begin
				result |= i;
			end
		end
	
		return result;
	endfunction
	


endmodule

`undef DEFAULT_SLAVE_ERROR_axi4_interconnect_8x7_pt

