/****************************************************************************
 * axi4_l1_interconnect_2_tb.sv
 ****************************************************************************/

`ifdef GLS
`timescale 1 ps/ 1 ps
`endif

/**
 * Module: axi4_l1_interconnect_2_tb
 * 
 * TODO: Add module documentation
 */
module axi4_l1_interconnect_2_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
`ifndef VERILATOR
	reg clk_r = 0;
	assign clk = clk_r;
	
	initial begin
		forever begin
			#10ns;
			clk_r <= 1;
			#10ns;
			clk_r <= 0;
		end
	end
	initial begin
		$display("--> svf_runtest()");
		svf_runtest();
		$display("<-- svf_runtest()");
	end
`endif
	
	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rstn <= 1;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	/* verilator tracing_off */
	initial begin
		string TB_ROOT;
		$display("TB_ROOT=%m");
		$sformat(TB_ROOT, "%m");
		$display("--> set_config_string()");
		set_config_string("*", "TB_ROOT", TB_ROOT);
		$display("<-- set_config_string()");
	end
	/* verilator tracing_on */

	// TODO: instantiate DUT, BFMs

`ifdef GLS
	localparam AXI4_ADDRESS_WIDTH = 20;
	localparam AXI4_DATA_WIDTH = 8;
	localparam AXI4_ID_WIDTH = 2;
	localparam CACHE_WAYS = 4;
`else
	localparam AXI4_ADDRESS_WIDTH = 32;
	localparam AXI4_DATA_WIDTH = 32;
	localparam AXI4_ID_WIDTH = 4;
	localparam CACHE_WAYS = 4;
`endif
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) bfm02ic ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) bfm12ic ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) ic2mem ();
	
	axi4_svf_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (AXI4_ADDRESS_WIDTH    ), 
		.AXI4_DATA_WIDTH        (AXI4_DATA_WIDTH       ), 
		.AXI4_ID_WIDTH          (AXI4_ID_WIDTH         ), 
		.AXI4_MAX_BURST_LENGTH  (16 )
		) u_m0 (
		.clk                    (clk                   ), 
		.rstn                   (rstn                  ), 
		.master                 (bfm02ic.master        ));
	
	axi4_svf_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (AXI4_ADDRESS_WIDTH    ), 
		.AXI4_DATA_WIDTH        (AXI4_DATA_WIDTH       ), 
		.AXI4_ID_WIDTH          (AXI4_ID_WIDTH         ), 
		.AXI4_MAX_BURST_LENGTH  (16 )
		) u_m1 (
		.clk                    (clk                   ), 
		.rstn                   (rstn                  ), 
		.master                 (bfm12ic.master        ));
	
	axi4_monitor_bfm #(
			.AXI4_ADDRESS_WIDTH	(AXI4_ADDRESS_WIDTH		),
			.AXI4_DATA_WIDTH	(AXI4_DATA_WIDTH		),
			.AXI4_ID_WIDTH		(AXI4_ID_WIDTH			)
		) u_bfm02ic_monitor (
			.clk				(clk					),
			.rst_n				(rstn					),
			.monitor			(bfm12ic.monitor		));
	
`ifdef GLS
	axi4_l1_interconnect_2_top_w #(
`else
	axi4_l1_interconnect_2 #(
`endif
			.CACHE_WAYS(CACHE_WAYS),
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
		) u_ic (
			.clk_i(clk),
			.rst_n(rstn),
			.m0(bfm02ic.slave),
			
			.m1(bfm12ic.slave),
			
			.out(ic2mem.master)
		);

`ifdef GLS
	axi4_sram_top_w #(
`else
	axi4_sram #(
`endif
		.MEM_ADDR_BITS      (18     ), 
		.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI_ID_WIDTH       (AXI4_ID_WIDTH+1    )
		) u_mem (
		.ACLK               (clk                ), 
		.ARESETn            (rstn               ), 
		.s                  (ic2mem.slave       ));
	

	timebase u_timebase();
	
endmodule

