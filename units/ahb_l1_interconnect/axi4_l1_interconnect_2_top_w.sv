/****************************************************************************
 * axi4_l1_interconnect_2_top.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_interconnect_2_top
 * 
 * TODO: Add module documentation
 */
`include "axi4_if_macros.svh"

module axi4_l1_interconnect_2_top_w #(
		parameter	CACHE_WAYS = 4,
		parameter	AXI4_ADDRESS_WIDTH = 32,
		parameter	AXI4_DATA_WIDTH = 32,
		parameter	AXI4_ID_WIDTH = 4
		) (
		input				clk_i,
		input				rst_n,
		axi4_if.slave		m0,
		axi4_if.slave		m1,
		axi4_if.master		out
		);

		axi4_l1_interconnect_2_top u_ic (
				.clk_i(clk_i),
				.rst_n(rst_n),
				`AXI4_IF_PORTMAP(m0, m0),
				`AXI4_IF_PORTMAP(out, out)
			);
//				`AXI4_IF_PORTMAP(m1, m1),

endmodule

