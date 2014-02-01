/****************************************************************************
 * generic_rom.sv
 ****************************************************************************/

/**
 * Module: generic_rom
 * 
 * TODO: Add module documentation
 */
module generic_rom #(
			parameter int DATA_WIDTH	= 32,
			parameter int ADDRESS_WIDTH	= 32,
			parameter INIT_FILE = "file.mem"
		) (
			input						i_clk,
			input [ADDRESS_WIDTH-1:0]	i_address,
			output [DATA_WIDTH-1:0]		o_read_data
		);
	reg[ADDRESS_WIDTH-1:0]				rom[DATA_WIDTH-1:0];
	reg[ADDRESS_WIDTH-1:0]				read_addr;

	initial begin
		
	end

	always @(posedge clk) begin
		read_addr <= i_address;
	end

	assign o_read_data = rom[i_address];
endmodule

