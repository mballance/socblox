/****************************************************************************
 * axi4_master_bfm.sv
 ****************************************************************************/

/**
 * Module: axi4_master_bfm
 * 
 * TODO: Add module documentation
 */
module axi4_master_bfm #(
			parameter int AXI4_ADDRESS_WIDTH=32,
			parameter int AXI4_DATA_WIDTH=128,
			parameter int AXI4_ID_WIDTH=4
		) (
			input				clk,
			input				rstn,
			axi4_if.master		master
		);

	// Empty. BFM implementation binds to this module

endmodule

