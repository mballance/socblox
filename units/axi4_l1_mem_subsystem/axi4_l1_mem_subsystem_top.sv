/****************************************************************************
 * axi4_l1_mem_subsystem_top.sv
 ****************************************************************************/
`include "axi4_if_macros.svh"

/**
 * Module: axi4_l1_mem_subsystem_top
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_subsystem_top #(
		parameter AXI4_ADDRESS_WIDTH = 20,
		parameter AXI4_DATA_WIDTH = 32,
		parameter AXI4_ID_WIDTH = 2
		) (
		input				clk_i,
		input				rst_n,
		`AXI4_IF_SLAVE_PORTS(m0, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH)
//		`AXI4_IF_SLAVE_PORTS(m1, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH)
		);

		axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) m02m0 ();
		
		axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) m12m1 ();
		
		`AXI4_IF_CONNECT_SLAVE_PORTS2IF(m0, m02m0);
//		`AXI4_IF_CONNECT_SLAVE_PORTS2IF(m1, m12m1);
		`AXI4_IF_STUB_SLAVE_IF(m12m1);
		
		axi4_l1_mem_subsystem #(
				.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
				.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
				.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
			) u_subsys (
				.clk_i(clk_i),
				.rst_n(rst_n),
				.m0(m02m0.slave),
				.m1(m12m1.slave)
			);

endmodule

