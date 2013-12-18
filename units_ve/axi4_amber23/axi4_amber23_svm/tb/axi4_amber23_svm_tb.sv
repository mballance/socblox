/****************************************************************************
 * axi4_amber23_svm_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_amber23_svm_tb
 * 
 * TODO: Add module documentation
 */

module axi4_amber23_svm_tb(
		input				clk
		);
	reg 		rstn = 0;
	reg[15:0]	rstn_cnt = 0;
	
	always @(posedge clk) begin
		if (rstn_cnt == 100) begin
			rstn = 1;
		end else begin
			rstn_cnt = rstn_cnt + 1;
		end
	end
	
	axi4_if #(
				.AXI4_ADDRESS_WIDTH(32),
				.AXI4_DATA_WIDTH(32),
				.AXI4_ID_WIDTH(4)
			) c2ic (
				.clk(clk),
				.rstn(rstn)
			);
	
	axi4_a23_core #(
		.A23_CACHE_WAYS  (4 )
		) core (
		.i_clk           (clk            ), 
		.i_irq           (i_irq          ), 
		.i_firq          (i_firq         ), 
		.i_system_rdy    (i_system_rdy   ), 
		.master			 (c2ic.master	 )
		);
	
	axi4_interconnect_1x1 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE1_ADDR_BASE    (0   ), 
		.SLAVE1_ADDR_LIMIT   ('hffffffff  )
		) ic0 (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (c2ic.slave         ), 
		.s0                  (s0                 ), 
		.serr                (serr               ));


	
	
endmodule

