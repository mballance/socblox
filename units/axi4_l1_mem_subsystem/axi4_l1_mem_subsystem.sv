/****************************************************************************
 * axi4_l1_mem_subsystem.sv
 ****************************************************************************/

/**
 * Module: axi4_l1_mem_subsystem
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_subsystem #(
		parameter AXI4_ADDRESS_WIDTH = 20,
		parameter AXI4_DATA_WIDTH    = 16,
		parameter AXI4_ID_WIDTH      = 2
		) (
		input				clk_i,
		input				rst_n,
		axi4_if.slave		m0,
		axi4_if.slave		m1);
	
	localparam CACHE_WAYS = 4;
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) l1ic2ic ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) ic2boot ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) ic2ram ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) ic2periph ();

	axi4_l1_interconnect_2 #(
		.CACHE_WAYS          (CACHE_WAYS         ), 
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) u_l1ic (
		.clk_i               (clk_i              ), 
		.rst_n               (rst_n              ), 
		.m0                  (m0                 ), 
		.m1                  (m1                 ), 
		.out                 (l1ic2ic.master     ));

	axi4_interconnect_1x3 #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      ), 
		.SLAVE0_ADDR_BASE    ('h0000_0000        ), 
		.SLAVE0_ADDR_LIMIT   ('h0000_FFFF        ), 
		.SLAVE1_ADDR_BASE    ('h0002_0000        ), 
		.SLAVE1_ADDR_LIMIT   ('h0002_FFFF        ), 
		.SLAVE2_ADDR_BASE    ('h000F_0000        ), 
		.SLAVE2_ADDR_LIMIT   ('h000F_FFFF        )
		) u_ic (
		.clk                 (clk_i              ), 
		.rstn                (rst_n              ), 
		.m0                  (l1ic2ic.slave      ), 
		.s0                  (ic2boot.master     ), 
		.s1                  (ic2ram.master      ), 
		.s2                  (ic2periph.master   ));

	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (AXI4_ID_WIDTH      )
		) u_boot (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n           	), 
		.s                  (ic2boot.slave      ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (AXI4_ID_WIDTH      )
		) u_sram (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n           	), 
		.s                  (ic2ram.slave      ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (AXI4_ID_WIDTH      )
		) u_periph (
		.ACLK               (clk_i              ), 
		.ARESETn            (rst_n           	), 
		.s                  (ic2periph.slave    ));
	

endmodule

