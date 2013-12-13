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
		parameter int AXI4_ID_WIDTH=4)(
		input ACLK,
		input ARESETn
		);

	// ** 
	// * Write Address channel
	// ** 
	bit[(AXI4_ADDRESS_WIDTH-1):0]	AWADDR;
	bit[(AXI4_ID_WIDTH-1):0]		AWID;
	bit[7:0]						AWLEN;
	bit[2:0]						AWSIZE;
	bit[1:0]						AWBURST;
	// LOCK excluded (AXI4)
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
	// LOCK excluded (AXI4)
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
	bit[1:0]						RRESP;
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
			output ARCACHE,
			output ARPROT,
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
			input ARCACHE,
			input ARPROT,
			input ARREGION,
			input ARVALID,
			output ARREADY,
			
			output RID,
			output RDATA,
			output RRESP,
			output RLAST,
			output RVALID,
			input RREADY);

`ifdef UNDEFINED
	// Modport that implements a master
	modport aw_master(
			output AWID,
			output AWADDR,
			output AWLEN,
			output AWSIZE,
			output AWBURST,
			output AWCACHE,
			output AWPROT,
			output AWQOS,
			output AWREGION,
			output AWVALID,
			input AWREADY);

	// Modport that implements a slave
	modport aw_slave(
			input AWID,
			input AWADDR,
			input AWLEN,
			input AWSIZE,
			input AWBURST,
			input AWCACHE,
			input AWPROT,
			input AWQOS,
			input AWREGION,
			input AWVALID,
			output AWREADY);
	
	// Write data
	modport w_master(
			output WDATA,
			output WSTRB,
			output WLAST,
			output WVALID,
			input WREADY);
	
	modport w_slave(
			input WDATA,
			input WSTRB,
			input WLAST,
			input WVALID,
			output WREADY);
	
	// Write response
	modport b_master(
			input BID,
			input BRESP,
			input BVALID,
			output BREADY);
	
	modport b_slave(
			output BID,
			output BRESP,
			output BVALID,
			input BREADY);
	
	// Read address
	modport ar_master(
			output ARID,
			output ARADDR,
			output ARLEN,
			output ARSIZE,
			output ARBURST,
			output ARCACHE,
			output ARPROT,
			output ARREGION,
			output ARVALID,
			input ARREADY);
	
	modport ar_slave(
			input ARID,
			input ARADDR,
			input ARLEN,
			input ARSIZE,
			input ARBURST,
			input ARCACHE,
			input ARPROT,
			input ARREGION,
			input ARVALID,
			output ARREADY);
		
	// Read data
	modport r_master(
			input RID,
			input RDATA,
			input RRESP,
			input RLAST,
			input RVALID,
			output RREADY);
	
	modport r_slave(
			output RID,
			output RDATA,
			output RRESP,
			output RLAST,
			output RVALID,
			input RREADY);
`endif	


endinterface

