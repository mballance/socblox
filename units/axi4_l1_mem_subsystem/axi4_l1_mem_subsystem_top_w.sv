/****************************************************************************
 * axi4_l1_mem_subsystem_top_w.sv
 ****************************************************************************/
`include "axi4_if_macros.svh"

/**
 * Module: axi4_l1_mem_subsystem_top
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_subsystem_top_w #(
		parameter AXI4_ADDRESS_WIDTH = 20,
		parameter AXI4_DATA_WIDTH = 32,
		parameter AXI4_ID_WIDTH = 2
		) (
		input				clk_i,
		input				rst_n,
		axi4_if.slave		m0,
		axi4_if.slave		m1
		);

		axi4_l1_mem_subsystem_top u_top (
				.clk_i(clk_i),
				.rst_n(rst_n),
				`AXI4_IF_PORTMAP(m0, m0)
//				`AXI4_IF_PORTMAP(m1, m1)
			);

endmodule

