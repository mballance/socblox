/****************************************************************************
 * axi4_l1_mem_subsystem.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_mem_subsystem
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_subsystem #(
		parameter AXI4_ADDRESS_WIDTH = 32,
		parameter AXI4_DATA_WIDTH    = 32,
		parameter AXI4_ID_WIDTH      = 2
		) (
		input				clk_i,
		input				rst_n,
		axi4_if.slave		m0);
	
	localparam CACHE_WAYS = 4;

err
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) mic2m0 ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) mic2m1 ();
	
	axi4_interconnect_1x2 #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      ), 
		.SLAVE0_ADDR_BASE    ('h0000_0000        ), 
		.SLAVE0_ADDR_LIMIT   ('h7fff_ffff        ), 
		.SLAVE1_ADDR_BASE    ('h8000_0000        ), 
		.SLAVE1_ADDR_LIMIT   ('hffff_ffff        )
		) u_mic (
		.clk                 (clk_i              ), 
		.rstn                (rst_n              ), 
		.m0                  (m0                 ), 
		.s0                  (mic2m0.master      ), 
		.s1                  (mic2m1.master      ));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+2    )
		) l1ic2ic ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+2    )
		) ic2boot ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+2    )
		) ic2ram ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+2    )
		) ic2periph ();

	axi4_l1_interconnect_2 #(
		.CACHE_WAYS          (CACHE_WAYS         ), 
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) u_l1ic (
		.clk_i               (clk_i              ), 
		.rst_n               (rst_n              ), 
		.m0                  (mic2m0.slave       ), 
		.m1                  (mic2m1.slave       ), 
		.out                 (l1ic2ic.master     ));

	axi4_interconnect_1x3 #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    ), 
//		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH    ), 
		.SLAVE0_ADDR_BASE    ('h0000_0000        ), 
		.SLAVE0_ADDR_LIMIT   ('h0000_FFFF        ), 
		.SLAVE1_ADDR_BASE    ('h2000_0000        ), 
		.SLAVE1_ADDR_LIMIT   ('h2000_FFFF        ), 
		.SLAVE2_ADDR_BASE    ('hF000_0000        ), 
		.SLAVE2_ADDR_LIMIT   ('hF000_FFFF        )
		) u_ic (
		.clk                 (clk_i              ), 
		.rstn                (rst_n              ), 
		.m0                  (l1ic2ic.slave      ), 
//		.m0                  (m0),
		.s0                  (ic2boot.master     ), 
		.s1                  (ic2ram.master      ), 
		.s2                  (ic2periph.master   ));
	
//	localparam SRAM_AXI4_ID_WIDTH = AXI4_ID_WIDTH+1;
	localparam SRAM_AXI4_ID_WIDTH = AXI4_ID_WIDTH+2;
//	localparam SRAM_AXI4_ID_WIDTH = AXI4_ID_WIDTH;

	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (SRAM_AXI4_ID_WIDTH )
		) u_boot (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n           	), 
//		.s                  (mic2m0.slave       ));
		.s                  (ic2boot.slave      ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (SRAM_AXI4_ID_WIDTH )
		) u_sram (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n           	), 
//		.s                  (m0       ));
//		.s                  (mic2m1.slave       ));
		.s                  (ic2ram.slave      ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (SRAM_AXI4_ID_WIDTH )
		) u_periph (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n           	), 
		.s                  (ic2periph.slave    ));
	

endmodule

