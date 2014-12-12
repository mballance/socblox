/****************************************************************************
 * axi4_l1_mem_unit_top.sv
 ****************************************************************************/
 
`include "axi4_if_macros.svh"

/**
 * Module: axi4_l1_mem_unit_top
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_unit_top #(
			CACHE_WAYS = 4,
			AXI4_ADDRESS_WIDTH = 32,
			AXI4_DATA_WIDTH = 32,
			AXI4_ID_WIDTH = 2
		) (
			input				clk_i,
			input				rst_n,
			`AXI4_IF_SLAVE_PORTS(s, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH)
		);
	
		axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) s2s ();
	
		`AXI4_IF_CONNECT_SLAVE_PORTS2IF(s, s2s);
		
		axi4_l1_mem_unit #(
				.CACHE_WAYS(CACHE_WAYS),
				.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
				.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
				.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
			) u_unit (
				.clk_i(clk_i),
				.rst_n(rst_n),
				.s(s2s.slave)
			);

endmodule

