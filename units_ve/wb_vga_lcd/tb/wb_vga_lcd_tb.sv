/****************************************************************************
 * wb_vga_lcd_tb.sv
 ****************************************************************************/
`ifdef GLS
`timescale 1 ps/ 1 ps
`endif

/**
 * Module: wb_vga_lcd_tb
 * 
 * TODO: Add module documentation
 */
module wb_vga_lcd_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
	wire				clk_p;
	assign clk_p = clk;
	wire				wb_inta_o;
	
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
		) sys2vga ();
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) vga2sys ();
	
	vga_if fb ();
	
	vga_enh_top_w u_dut (
		.clk       (clk				), 
		.rstn      (rstn			), 
		.slave     (sys2vga.slave	), 
		.master    (vga2sys.master	), 
		.wb_inta_o (wb_inta_o		),
		.clk_p_i   (clk_p			), 
		.framebuf  (fb.framebuf		));
	
	wb_master_bfm #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) bfm0 (
		.clk            (clk			), 
		.rstn           (rstn			), 
		.master         (sys2vga.master	));
	
	wb_sram #(
		.MEM_ADDR_BITS     (12				), 
		.WB_ADDRESS_WIDTH  (32				), 
		.WB_DATA_WIDTH     (32				)
		) u_sram (
		.clk               (clk				), 
		.rstn              (rstn			), 
		.s                 (vga2sys.slave	));
	
endmodule

