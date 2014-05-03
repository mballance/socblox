/****************************************************************************
 * axi4_monitor.sv
 ****************************************************************************/

/**
 * Module: axi4_monitor
 * 
 * TODO: Add module documentation
 */
module axi4_monitor #(
		parameter int		AXI4_ADDRESS_WIDTH=32,
		parameter int		AXI4_DATA_WIDTH=32,
		parameter int		AXI4_ID_WIDTH=32
		) (
		input				clk,
		input				rst_n,
		axi4_if.monitor		monitor
		);


	
endmodule

