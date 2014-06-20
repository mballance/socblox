/****************************************************************************
 * bidi_message_queue_tb.sv
 ****************************************************************************/

/**
 * Module: bidi_message_queue_tb
 * 
 * TODO: Add module documentation
 */
module bidi_message_queue_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
`ifndef VERILATOR
	reg clk_r = 0;
	assign clk = clk_r;
	
	initial begin
		forever begin
			#5;
			clk_r <= 1;
			#5;
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
	
	bidi_message_queue_if u_queue_if ();
	
	localparam MEM_ADDR_BITS = 16;
	localparam AXI_ADDRESS_BITS = 32;
	localparam AXI_DATA_BITS = 32;
	localparam AXI_ID_WIDTH = 4;
	
	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (MEM_ADDR_BITS ), 
		.NUM_DATA_BITS  (32 )
		) u_mem_if (
		);
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI_ADDRESS_BITS ), 
		.AXI4_DATA_WIDTH     (AXI_DATA_BITS    ), 
		.AXI4_ID_WIDTH       (4      )
		) u_bfm2ic (
		);
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (AXI_ADDRESS_BITS ), 
		.AXI4_DATA_WIDTH     (AXI_DATA_BITS    ), 
		.AXI4_ID_WIDTH       (5      )
		) u_ic2bridge (
		);
	
	axi4_interconnect_1x1 #(
		.AXI4_ADDRESS_WIDTH  (AXI_ADDRESS_BITS ), 
		.AXI4_DATA_WIDTH     (AXI_DATA_BITS    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE0_ADDR_BASE    ('h00000000   ), 
		.SLAVE0_ADDR_LIMIT   ('hffffffff  )
		) u_ic (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (u_bfm2ic.slave     ), 
		.s0                  (u_ic2bridge.master ));
	
	axi4_svf_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (AXI_ADDRESS_BITS    ), 
		.AXI4_DATA_WIDTH        (AXI_DATA_BITS       ), 
		.AXI4_ID_WIDTH          (4         ), 
		.AXI4_MAX_BURST_LENGTH  (16 )
		) u_axi4_bfm (
		.clk                    (clk                ), 
		.rstn                   (rstn               ), 
		.master                 (u_bfm2ic.master   	));
	
	axi4_generic_line_en_sram_bridge #(
		.MEM_ADDR_BITS      (MEM_ADDR_BITS     ), 
		.AXI_ADDRESS_WIDTH  (AXI_ADDRESS_BITS ), 
		.AXI_DATA_WIDTH     (AXI_DATA_BITS    ), 
		.AXI_ID_WIDTH       (AXI_ID_WIDTH      )
		) u_axi2sram_bridge (
		.clk                (clk               		), 
		.rst_n              (rstn              		), 
		.axi_if             (u_ic2bridge.slave		), 
		.sram_if            (u_mem_if.sram_client	));
	
	bidi_message_queue_bfm u_queue_bfm (
		.clk       (clk      	), 
		.rst_n     (rstn    	), 
		.queue_if  (u_queue_if.msg_q_client));

	wire irq;
	
	bidi_message_queue #(
		.QUEUE_ADDR_BITS  (8)
		) u_queue (
		.clk              (clk             ), 
		.rst_n            (rstn            ), 
		.mem_if           (u_mem_if.sram   ), 
		.queue_if         (u_queue_if.msg_q), 
		.irq              (irq             ));
	
	
endmodule

