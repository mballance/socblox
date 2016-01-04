/****************************************************************************
 * wb_generic_byte_en_sram_bridge.sv
 ****************************************************************************/

/**
 * Module: wb_generic_byte_en_sram_bridge
 * 
 * TODO: Add module documentation
 */
module wb_generic_byte_en_sram_bridge #(
		) (
			input									clk,
			input									rstn,
			wb_if.slave								wb_s,
			generic_sram_byte_en_if.sram_client		sram_m
		);
	
	reg req, req_1;

	always @(posedge clk) begin
		if (rstn == 0) begin
			req <= 0;
			req_1 <= 0;
		end else begin
			if (wb_s.CYC) begin
				req <= 1;
			end else begin
				req <= 0;
			end
			req_1 <= req;
		end
	end
	
	assign sram_m.addr = wb_s.ADR;
	assign sram_m.read_en = (wb_s.CYC & wb_s.SEL & !wb_s.WE);
	assign sram_m.write_en = (wb_s.CYC & wb_s.SEL & wb_s.WE);
	assign sram_m.byte_en = wb_s.SEL;
	assign sram_m.write_data = wb_s.DAT_W;
	assign wb_s.DAT_R = sram_m.read_data;

	assign wb_s.ACK = (sram_m.read_en)?req_1:req;

endmodule


