/****************************************************************************
 * ahb_lite_if.sv
 ****************************************************************************/

/**
 * Interface: ahb_lite_if
 * 
 * TODO: Add interface documentation
 */
interface ahb_lite_if #(
		parameter int AHB_ADDRESS_WIDTH=32,
		parameter int AHB_DATA_WIDTH=32
		);
	
	reg[AHB_ADDRESS_WIDTH-1:0]		HADDR;
	reg								HSEL;
	reg[1:0]						HTRANS;
	reg								HWRITE;
	reg[2:0]						HSIZE;
	reg[2:0]						HBURST;
	reg[5:0]						HPROT;
	reg[AHB_DATA_WIDTH-1:0]			HWDATA;
	reg[AHB_DATA_WIDTH-1:0]			HRDATA;
	reg								HREADY;
	reg[2:0]						HRESP;

	modport master(
			output		HADDR,
			output		HSEL,
			output		HTRANS,
			output		HWRITE,
			output		HSIZE,
			output		HBURST,
			output		HPROT,
			output		HWDATA,
			input		HRDATA,
			input		HREADY,
			input		HRESP
		);
	
	modport slave(
			input		HADDR,
			input		HSEL,
			input		HTRANS,
			input		HWRITE,
			input		HSIZE,
			input		HBURST,
			input		HPROT,
			input		HWDATA,
			output		HRDATA,
			output		HREADY,
			output		HRESP
		);
	
	modport monitor(
			input		HADDR,
			input		HSEL,
			input		HTRANS,
			input		HWRITE,
			input		HSIZE,
			input		HBURST,
			input		HPROT,
			input		HWDATA,
			input		HRDATA,
			input		HREADY,
			input		HRESP
		);


endinterface

