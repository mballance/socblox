/****************************************************************************
 * axi4_if.sv
 ****************************************************************************/

/**
 * Interface: axi4_if
 * 
 * TODO: Add interface documentation
 */
interface axi4_if #(
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=128,
		parameter int AXI4_ID_WIDTH=4);

	// ** 
	// * Write Address channel
	// ** 
	bit[(AXI4_ADDRESS_WIDTH-1):0]	AWADDR;
	bit[(AXI4_ID_WIDTH-1):0]		AWID;
	bit[7:0]						AWLEN;
	bit[2:0]						AWSIZE;
	bit[1:0]						AWBURST;
	bit								AWLOCK;
	bit[3:0]						AWCACHE;
	
	bit[2:0]						AWPROT;
	bit[3:0]						AWQOS;
	bit[3:0]						AWREGION;
	
	// AWUSER excluded (Not recommended)
	bit								AWVALID;
	bit								AWREADY;

	// ** 
	// * Write Data channel
	// ** 
	// WID excluded (AXI4)
	bit[(AXI4_DATA_WIDTH-1):0]		WDATA;
	bit[(AXI4_DATA_WIDTH/8)-1:0]	WSTRB;
	bit								WLAST;
	// WUSER excluded (Not recommended)
	bit								WVALID;
	bit								WREADY;
	
	// **
	// * Write response channel
	// **
	bit[(AXI4_ID_WIDTH-1):0]		BID;
	bit[1:0]						BRESP;
	// BUSER excluded (Not recommended)
	bit								BVALID;
	bit								BREADY;
	
	// ** 
	// * Read Address channel
	// ** 
	bit[(AXI4_ID_WIDTH-1):0]		ARID;
	bit[(AXI4_ADDRESS_WIDTH-1):0]	ARADDR;
	bit[7:0]						ARLEN;
	bit[2:0]						ARSIZE;
	bit[1:0]						ARBURST;
	bit								ARLOCK;
	bit[3:0]						ARCACHE;
	
	bit[2:0]						ARPROT;
	bit[3:0]						ARQOS;
	bit[3:0]						ARREGION;
	
	// ARUSER excluded (Not recommended)
	bit								ARVALID;
	bit								ARREADY;
	
	// ** 
	// * Read Data channel
	// ** 
	bit[(AXI4_ID_WIDTH-1):0]		RID;
	bit[(AXI4_DATA_WIDTH-1):0]		RDATA;
	reg[1:0]						RRESP;
	bit								RLAST;
	// RUSER excluded (Not recommended)
	bit								RVALID;
	bit								RREADY;
	
	//***************************************************************
	//* Modports
	//***************************************************************
	
	modport master(
			// AW
			output AWID,
			output AWADDR,
			output AWLEN,
			output AWSIZE,
			output AWBURST,
			output AWLOCK,
			output AWCACHE,
			output AWPROT,
			output AWQOS,
			output AWREGION,
			output AWVALID,
			input AWREADY,
			
			// Write Data
			output WDATA,
			output WSTRB,
			output WLAST,
			output WVALID,
			input WREADY,

			// Write response
			input BID,
			input BRESP,
			input BVALID,
			output BREADY,

			// Read Address
			output ARID,
			output ARADDR,
			output ARLEN,
			output ARSIZE,
			output ARBURST,
			output ARLOCK,
			output ARCACHE,
			output ARPROT,
			output ARQOS,
			output ARREGION,
			output ARVALID,
			input ARREADY,

			// Read Data
			input RID,
			input RDATA,
			input RRESP,
			input RLAST,
			input RVALID,
			output RREADY			
			);
	
	modport slave(
			input AWID,
			input AWADDR,
			input AWLEN,
			input AWSIZE,
			input AWBURST,
			input AWLOCK,
			input AWCACHE,
			input AWPROT,
			input AWQOS,
			input AWREGION,
			input AWVALID,
			output AWREADY,
			
			input WDATA,
			input WSTRB,
			input WLAST,
			input WVALID,
			output WREADY,

			output BID,
			output BRESP,
			output BVALID,
			input BREADY,
		
			input ARID,
			input ARADDR,
			input ARLEN,
			input ARSIZE,
			input ARBURST,
			input ARLOCK,
			input ARCACHE,
			input ARPROT,
			input ARQOS,
			input ARREGION,
			input ARVALID,
			output ARREADY,
			
			output RID,
			output RDATA,
			output RRESP,
			output RLAST,
			output RVALID,
			input RREADY);

		modport monitor(
			input AWID,
			input AWADDR,
			input AWLEN,
			input AWSIZE,
			input AWBURST,
			input AWLOCK,
			input AWCACHE,
			input AWPROT,
			input AWQOS,
			input AWREGION,
			input AWVALID,
			input AWREADY,
			
			input WDATA,
			input WSTRB,
			input WLAST,
			input WVALID,
			input WREADY,

			input BID,
			input BRESP,
			input BVALID,
			input BREADY,
		
			input ARID,
			input ARADDR,
			input ARLEN,
			input ARSIZE,
			input ARBURST,
			input ARLOCK,
			input ARCACHE,
			input ARPROT,
			input ARQOS,
			input ARREGION,
			input ARVALID,
			input ARREADY,
			
			input RID,
			input RDATA,
			input RRESP,
			input RLAST,
			input RVALID,
			input RREADY);
			
		modport monitor_master(
				output AWID,
				output AWADDR,
				output AWLEN,
				output AWSIZE,
				output AWBURST,
				output AWLOCK,
				output AWCACHE,
				output AWPROT,
				output AWQOS,
				output AWREGION,
				output AWVALID,
				output AWREADY,
			
				output WDATA,
				output WSTRB,
				output WLAST,
				output WVALID,
				output WREADY,

				output BID,
				output BRESP,
				output BVALID,
				output BREADY,
		
				output ARID,
				output ARADDR,
				output ARLEN,
				output ARSIZE,
				output ARBURST,
				output ARLOCK,
				output ARCACHE,
				output ARPROT,
				output ARQOS,
				output ARREGION,
				output ARVALID,
				output ARREADY,
			
				output RID,
				output RDATA,
				output RRESP,
				output RLAST,
				output RVALID,
				output RREADY);


endinterface

