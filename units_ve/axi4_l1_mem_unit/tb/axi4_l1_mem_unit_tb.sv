/****************************************************************************
 * axi4_l1_mem_unit_tb.sv
 ****************************************************************************/
`ifdef GLS
`timescale 1 ps/ 1 ps
`else
`ifdef FPGA
`timescale 1 ps/ 1 ps
`endif
`endif

/**
 * Module: axi4_l1_mem_unit_tb
 * 
 * TODO: Add module documentation
 */
module axi4_l1_mem_unit_tb(input clk);
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
	
	localparam AXI4_ADDRESS_WIDTH = 32;
	localparam AXI4_DATA_WIDTH = 32;
	localparam AXI4_ID_WIDTH = 2;
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) bfm02unit (
		);
	
	axi4_svf_master_bfm #(
			.AXI4_ADDRESS_WIDTH     (AXI4_ADDRESS_WIDTH    ), 
			.AXI4_DATA_WIDTH        (AXI4_DATA_WIDTH       ), 
			.AXI4_ID_WIDTH          (AXI4_ID_WIDTH         ), 
			.AXI4_MAX_BURST_LENGTH  (16 )
		) u_bfm0 (
			.clk                    (clk                   ), 
			.rstn                   (rstn                  ), 
			.master                 (bfm02unit.master      )
		);
			

	// TODO: instantiate DUT, BFMs
`ifdef GLS
	axi4_l1_mem_unit_top_w #(
`else
	axi4_l1_mem_unit #(
`endif
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
	) u_top (
		.clk_i(clk),
		.rst_n(rstn),
		.s(bfm02unit.slave)
	);
	
	
endmodule

