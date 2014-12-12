/****************************************************************************
 * axi4_l1_mem_unit_top_w.sv
 ****************************************************************************/
`include "axi4_if_macros.svh"

/**
 * Module: axi4_l1_mem_unit_top_w
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_unit_top_w #(
			CACHE_WAYS = 4,
			AXI4_ADDRESS_WIDTH = 32,
			AXI4_DATA_WIDTH = 32,
			AXI4_ID_WIDTH = 2
		) (
			input				clk_i,
			input				rst_n,
			axi4_if.slave		s
		);

	axi4_l1_mem_unit_top u_top (
			.clk_i(clk_i),
			.rst_n(rst_n),
			`AXI4_IF_PORTMAP(s, s)
		);

endmodule

