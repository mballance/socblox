/****************************************************************************
 * axi4_l1_interconnect_2_top.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_interconnect_2_top
 * 
 * TODO: Add module documentation
 */
 
`include "axi4_if_macros.svh"

// synthesis syn_black_box
module m0_driver(axi4_if.master m0);
endmodule

module axi4_l1_interconnect_2_top #(
		parameter	CACHE_WAYS = 4,
//		parameter	AXI4_ADDRESS_WIDTH = 20,
//		parameter	AXI4_DATA_WIDTH = 8,
//		parameter	AXI4_ID_WIDTH = 2
		parameter	AXI4_ADDRESS_WIDTH = 20,
		parameter	AXI4_DATA_WIDTH = 16,
		parameter	AXI4_ID_WIDTH = 4
		) (
		input				clk_i,
		input				rst_n,
		`AXI4_IF_SLAVE_PORTS(m0, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH),
		`AXI4_IF_SLAVE_PORTS(m1, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH),
		`AXI4_IF_MASTER_PORTS(out, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH)
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
		
		axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) out2out ();
	
		`AXI4_IF_CONNECT_SLAVE_PORTS2IF(m0, m02m0);
		`AXI4_IF_CONNECT_SLAVE_PORTS2IF(m1, m12m1);
//		`AXI4_IF_STUB_SLAVE_IF(m12m1);
		`AXI4_IF_CONNECT_MASTER_PORTS2IF(out, out2out);
		
		axi4_l1_interconnect_2 #(
				.CACHE_WAYS(CACHE_WAYS),
				.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
				.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
				.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
			) u_ic (
				.clk_i(clk_i),
				.rst_n(rst_n),
				.m0(m02m0.slave),
				.m1(m12m1.slave),
				.out(out2out.master)
			);

endmodule

