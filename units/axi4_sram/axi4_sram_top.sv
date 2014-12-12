/****************************************************************************
 * axi4_sram_top.sv
 ****************************************************************************/
 
`include "axi4_if_macros.svh"

/**
 * Module: axi4_sram_top
 * 
 * TODO: Add module documentation
 */
module axi4_sram_top #(
		parameter MEM_ADDR_BITS=10,
		parameter AXI_ADDRESS_WIDTH=20,
		parameter AXI_DATA_WIDTH=8,
		parameter AXI_ID_WIDTH=2
		) (
			input			ACLK,
			input			ARESETn,
			`AXI4_IF_SLAVE_PORTS(s, AXI_ADDRESS_WIDTH, AXI_DATA_WIDTH, AXI_ID_WIDTH)
			);

		axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI_ID_WIDTH      )
		) s2s ();
		
		`AXI4_IF_CONNECT_SLAVE_PORTS2IF(s, s2s);
		
		axi4_sram #(
				.MEM_ADDR_BITS(MEM_ADDR_BITS),
				.AXI_ADDRESS_WIDTH(AXI_ADDRESS_WIDTH),
				.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
				.AXI_ID_WIDTH(AXI_ID_WIDTH)
			) u_sram (
				.ACLK(ACLK),
				.ARESETn(ARESETn),
				.s(s2s.slave)
			);
				
endmodule

