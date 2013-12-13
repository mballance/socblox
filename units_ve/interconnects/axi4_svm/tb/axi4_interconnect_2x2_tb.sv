/****************************************************************************
 * axi4_interconnect_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_interconnect_tb
 * 
 * TODO: Add module documentation
 */

module axi4_interconnect_2x2_tb(
		input clk
		);
	reg rstn = 0;
	reg[15:0]		rstn_cnt = 0;
	
	always @(posedge clk) begin
		if (rstn_cnt == 100) begin
			rstn = 1;
		end else begin
			rstn_cnt = rstn_cnt + 1;
		end
	end

	localparam N_MASTERS_p = 2;
	
			axi4_if			if2(clk, rstn);
			axi4_master_bfm m_bfm(clk, rstn, if2.master);
	genvar i;
	generate
		for (i=0; i<N_MASTERS_p; i++) begin
//			bfm bfm_i(.clk(clk));
		end
	endgenerate

	bind axi4_master_bfm svm_axi4_master_bfm axi4_master_bfm_i (.clk(clk), .rstn(rstn), .master(master));
endmodule

