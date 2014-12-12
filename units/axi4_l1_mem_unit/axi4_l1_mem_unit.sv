/****************************************************************************
 * axi4_l1_mem_unit.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_mem_unit
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_unit #(
			CACHE_WAYS = 4,
			AXI4_ADDRESS_WIDTH = 32,
			AXI4_DATA_WIDTH = 32,
			AXI4_ID_WIDTH = 2
		) (
			input				clk_i,
			input				rst_n,
			axi4_if.slave		s
		);
	
	wire[AXI4_ADDRESS_WIDTH-1:0] 	i_snoop_addr = 0;
	wire							i_snoop_addr_valid = 0;
	wire							o_snoop_stall;
	wire[AXI4_ADDRESS_WIDTH-1:0]	o_snoop_addr;
	wire							o_snoop_addr_valid;
	wire							i_snoop_stall = 0;
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) cache2mem (
		);

	axi4_l1_cache_2 #(
		.CACHE_WAYS          (CACHE_WAYS         ), 
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    )
		) u_cache (
		.clk_i               (clk_i              ), 
		.rst_n               (rst_n              ), 
		.in                  (s                 ), 
		.i_snoop_addr        (i_snoop_addr       ), 
		.i_snoop_addr_valid  (i_snoop_addr_valid ), 
		.o_snoop_stall       (o_snoop_stall      ), 
		.o_snoop_addr        (o_snoop_addr       ), 
		.o_snoop_addr_valid  (o_snoop_addr_valid ), 
		.i_snoop_stall       (i_snoop_stall      ), 
		.out                 (cache2mem.master   ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (AXI4_ID_WIDTH      )
		) u_sram (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n              ), 
		.s                  (cache2mem.slave    ));

endmodule

