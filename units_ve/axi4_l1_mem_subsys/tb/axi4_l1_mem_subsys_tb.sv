/****************************************************************************
 * axi4_l1_mem_subsys_tb.sv
 ****************************************************************************/
 
`ifdef FPGA
`timescale 1 ps/ 1 ps
`else
`ifdef GLS
`timescale 1 ps/ 1 ps
`endif
`endif

/**
 * Module: axi4_l1_mem_subsys_tb
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_subsys_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
localparam AXI4_ADDRESS_WIDTH = 32;
localparam AXI4_DATA_WIDTH = 32;
localparam AXI4_ID_WIDTH = 2;
	
`ifndef VERILATOR
	reg clk_r = 0;
	assign clk = clk_r;
	
	initial begin
		forever begin
			#20ns;
			clk_r <= 1;
			#20ns;
			clk_r <= 0;
		end
	end
	initial begin
		svf_runtest();
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
		set_config_string("*", "TB_ROOT", TB_ROOT);
	end
	/* verilator tracing_on */

	// TODO: instantiate DUT, BFMs
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
			.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
			.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) bfm02ic ();
	
	axi4_svf_master_bfm #(
			.AXI4_ADDRESS_WIDTH     (AXI4_ADDRESS_WIDTH    ), 
			.AXI4_DATA_WIDTH        (AXI4_DATA_WIDTH       ), 
			.AXI4_ID_WIDTH          (AXI4_ID_WIDTH         ), 
			.AXI4_MAX_BURST_LENGTH  (16 )
		) u_m0 (
			.clk                    (clk                   ), 
			.rstn                   (rstn                  ), 
			.master                 (bfm02ic.master        ));
	
//	axi4_monitor_bfm #(
//			.AXI4_ADDRESS_WIDTH	(AXI4_ADDRESS_WIDTH		),
//			.AXI4_DATA_WIDTH	(AXI4_DATA_WIDTH		),
//			.AXI4_ID_WIDTH		(AXI4_ID_WIDTH			)
//		) u_bfm02ic_monitor (
//			.clk				(clk					),
//			.rst_n				(rstn					),
//			.monitor			(bfm02ic.monitor		));	
	
`ifdef GLS
	axi4_l1_mem_subsystem_top_w #(
`else
	axi4_l1_mem_subsystem #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
`endif
	) u_subsys (
		.clk_i(clk),
		.rst_n(rstn),
		.m0(bfm02ic.slave)
	);
	
	timebase u_timebase();
	
endmodule

