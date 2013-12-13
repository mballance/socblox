/****************************************************************************
 * apb_if.sv
 ****************************************************************************/

/**
 * Interface: apb_if
 * 
 * TODO: Add interface documentation
 */
interface apb_if #(
		parameter int APB_ADDRESS_WIDTH=32,
		parameter int APB_DATA_WIDTH=32
		)
		(
		input PCLK, input PRESETn
		);
	
	bit[APB_ADDRESS_WIDTH-1:0]					PADDR;
	bit											PPROT;
	bit											PSEL;
	bit											PENABLE;
	bit											PWRITE;
	bit[APB_DATA_WIDTH-1:0]						PWDATA;
	bit											PSTRB;
	bit											PREADY;
	bit[APB_DATA_WIDTH-1:0]						PRDATA;
	bit											PSLVERR;
	
	modport master(
			output			PADDR,
			output			PPROT,
			output			PSEL,
			output			PENABLE,
			output			PWRITE,
			output			PWDATA,
			output			PSTRB,
			input			PREADY,
			input			PRDATA,
			input			PSLVERR
			);
	
	modport slave(
			input			PADDR,
			input			PPROT,
			input			PSEL,
			input			PENABLE,
			input			PWRITE,
			input			PWDATA,
			input			PSTRB,
			output			PREADY,
			output			PRDATA,
			output			PSLVERR
			);


endinterface

