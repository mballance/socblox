/****************************************************************************
 * wb_2x2_svf_tb.sv
 ****************************************************************************/

/**
 * Module: wb_2x2_svf_tb
 * 
 * TODO: Add module documentation
 */
module wb_2x2_svf_tb(input clk);
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rstn <= 1;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) m02ic;
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) m12ic;
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) ic2s0;
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) ic2s1;
	
	wb_svf_master_bfm #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) m0 (
		.clk            (clk           ), 
		.rstn           (rstn          ), 
		.master         (m02ic.master  ));
	
	wb_svf_master_bfm #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) m1 (
		.clk            (clk           ), 
		.rstn           (rstn          ), 
		.master         (m12ic.master  ));

	wb_interconnect_2x2 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   ('h00000000  ), 
		.SLAVE0_ADDR_LIMIT  ('h00000fff  ), 
		.SLAVE1_ADDR_BASE   ('h00001000  ), 
		.SLAVE1_ADDR_LIMIT  ('h00001fff  )
		) wb_interconnect_2x2 (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (m02ic.slave       ), 
		.m1                 (m12ic.slave	   ), 
		.s0                 (ic2s0.master      ), 
		.s1                 (ic2s1.master      ));

endmodule

