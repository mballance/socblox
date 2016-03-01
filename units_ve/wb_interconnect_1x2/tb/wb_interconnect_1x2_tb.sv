/****************************************************************************
 * wb_interconnect_1x2_tb.sv
 ****************************************************************************/
`ifdef GLS
`timescale 1 ps/ 1 ps
`endif

/**
 * Module: wb_interconnect_1x2_tb
 * 
 * TODO: Add module documentation
 */
module wb_interconnect_1x2_tb(input clk);
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
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) m2ic (
		);
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) ic2s1 (
		);
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) ic2s2 (
		);
	
	wb_master_bfm #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) bfm0 (
		.clk            (clk           ), 
		.rstn           (rstn          ), 
		.master         (m2ic.master   ));
	
	wb_interconnect_1x2 #(
		.WB_ADDR_WIDTH      (32           ), 
		.WB_DATA_WIDTH      (32           ), 
		.SLAVE0_ADDR_BASE   ('h0000_0000  ), 
		.SLAVE0_ADDR_LIMIT  ('h0000_0FFF  ), 
		.SLAVE1_ADDR_BASE   ('h0000_1000  ), 
		.SLAVE1_ADDR_LIMIT  ('h0000_1FFF  )
		) ic (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (m2ic.slave        ), 
		.s0                 (ic2s1.master      ), 
		.s1                 (ic2s2.master      ));

	wb_sram #(
		.MEM_ADDR_BITS     (10 ), 
		.WB_ADDRESS_WIDTH  (32 ), 
		.WB_DATA_WIDTH     (32 )
		) u_sram0 (
		.clk               (clk              ), 
		.rstn              (rstn             ), 
		.s                 (ic2s1.slave      ));
	
	wb_sram #(
		.MEM_ADDR_BITS     (10 ), 
		.WB_ADDRESS_WIDTH  (32 ), 
		.WB_DATA_WIDTH     (32 )
		) u_sram1 (
		.clk               (clk              ), 
		.rstn              (rstn             ), 
		.s                 (ic2s2.slave      ));
	
	
endmodule

