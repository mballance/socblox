/****************************************************************************
 * wb_sram_bfm.sv
 ****************************************************************************/

/**
 * Module: wb_sram_bfm
 * 
 * TODO: Add module documentation
 */
module wb_sram_bfm #(
			parameter int	MEM_ADDR_BITS=10,
			parameter int	ADDR_WIDTH=32,
			parameter int	DATA_WIDTH=32
		) (
			input 			clk,
			input			rstn,
			wb_if			slave
		);

	reg[1:0]					state;
	reg[(DATA_WIDTH-1):0]		ram[1 << MEM_ADDR_BITS];
	reg[DATA_WIDTH-1:0]			DAT_R;

	localparam WIDTH_BITS = $bits(DATA_WIDTH/8);
	
	initial begin
		$display("WIDTH_BITS=%0d", WIDTH_BITS);
	end
	
	assign slave.DAT_R = ram[slave.ADR[MEM_ADDR_BITS+WIDTH_BITS-1:WIDTH_BITS-1]];
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
		end else begin
		
			if (slave.ACK) begin
				slave.ACK <= 0;
			end
			if (slave.STB && slave.CYC) begin
				if (slave.WE) begin
					ram[slave.ADR[MEM_ADDR_BITS+WIDTH_BITS-1:WIDTH_BITS-1]] <= slave.DAT_W;
				end
				slave.ACK <= 1;
			end
		end
	end
	
endmodule

