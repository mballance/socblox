/****************************************************************************
 * axi4_a23_dual.sv
 ****************************************************************************/
 
`include "axi4_if_macros.svh"

/**
 * Module: axi4_a23_dual
 * 
 * TODO: Add module documentation
 */
module axi4_a23_dual #(
		parameter CACHE_WAYS = 4,
		parameter AXI4_ID_WIDTH = 4
		) (
		input				i_clk,
		input				i_rstn,
		input				i_rstn_1,
		
		input				i_irq_0,
		input				i_firq_0,
		
		input				i_irq_1,
		input				i_firq_1,
		
		axi4_if.master		master
		);
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH-1    )
		) core02ic ();
	
//	`AXI4_IF_CONNECT_MONITOR_IF2IF(c0mon, core02ic);
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH-1    )
		) core12ic ();
	
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH-1  )
		) core02ic_monitor(
			.clk(i_clk),
			.rst_n(i_rstn),
			.monitor(core02ic.monitor)
		);
	
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH-1  )
		) core12ic_monitor(
			.clk(i_clk),
			.rst_n(i_rstn),
			.monitor(core12ic.monitor)
		);
	

	axi4_a23_core_mp u_core0 (
		.i_clk             (i_clk            ), 
		.i_rstn            (i_rstn           ), 
		.i_irq             (i_irq_0          ), 
		.i_firq            (i_firq_0         ), 
		.master            (core02ic.master  ));
	
	axi4_a23_core_mp u_core1 (
		.i_clk             (i_clk            ), 
		.i_rstn            (i_rstn_1         ), 
		.i_irq             (i_irq_1          ), 
		.i_firq            (i_firq_1         ), 
		.master            (core12ic.master  ));
	
	axi4_l1_interconnect_2 #(
		.CACHE_WAYS          (CACHE_WAYS          ), 
		.AXI4_ADDRESS_WIDTH  (32                  ), 
		.AXI4_DATA_WIDTH     (32                  ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH-1     )
		) u_coreic (
		.clk_i               (i_clk               ), 
		.rst_n               (i_rstn              ), 
		.m0                  (core02ic.slave      ),
		.m1                  (core12ic.slave      ), 
		.out                 (master              ));

endmodule

