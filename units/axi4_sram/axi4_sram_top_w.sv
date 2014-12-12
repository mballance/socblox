/****************************************************************************
 * axi4_sram_top.sv
 ****************************************************************************/
 
`include "axi4_if_macros.svh"

/**
 * Module: axi4_sram_top
 * 
 * TODO: Add module documentation
 */
module axi4_sram_top_w #(
		parameter MEM_ADDR_BITS=10,
		parameter AXI_ADDRESS_WIDTH=20,
		parameter AXI_DATA_WIDTH=16,
		parameter AXI_ID_WIDTH=4
		) (
			input			ACLK,
			input			ARESETn,
			axi4_if.slave	s
			);

		axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI_ID_WIDTH      )
		) s2s ();
		
		axi4_sram_top u_sram (
				.ACLK(ACLK),
				.ARESETn(ARESETn),
				`AXI4_IF_PORTMAP(s, s)
			);
				
endmodule

