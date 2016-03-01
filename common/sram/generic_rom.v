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
			parameter INIT_FILE = ""
		) (
			input						i_clk,
			input [ADDRESS_WIDTH-1:0]	i_address,
			output [DATA_WIDTH-1:0]		o_read_data
		);
	reg[DATA_WIDTH-1:0]				rom[(2**ADDRESS_WIDTH)-1:0];
	reg[ADDRESS_WIDTH-1:0]			read_addr;
	reg[DATA_WIDTH-1:0]				read_data;

	initial begin
//		reg[7:0] tmp[(2**ADDRESS_WIDTH)*(DATA_WIDTH/8)-1:0];
		reg[7:0] tmp[(2**ADDRESS_WIDTH)*(DATA_WIDTH/8)-1:0];
		reg[DATA_WIDTH-1:0] data_tmp;
		int i, j;
	
		// Seems Verilator (at least) doesn't read full words from the memory file
		if (INIT_FILE != "") begin
			$display("Initializing ROM from %s", INIT_FILE);
			$readmemh(INIT_FILE, rom);
//			for (i=0; i<2**ADDRESS_WIDTH; i+=1) begin
//				$display("  ADDRESS[%0h] = 'h%08h", i, rom[i]);
//			end
//			for (i=0; i<((2**ADDRESS_WIDTH)*(DATA_WIDTH/8)); i+=(DATA_WIDTH/8)) begin
//				data_tmp = 0;
//				for (j=0; j<(DATA_WIDTH/8); j++) begin
//					data_tmp |= (tmp[i+j] << 8*j);
//				end
//				rom[i/(DATA_WIDTH/8)] = data_tmp;
//			end
		end
	end

	always @(posedge i_clk) begin
//		read_addr <= i_address;
//		read_data <= rom[read_addr];
		read_data <= rom[i_address];
	end

	assign o_read_data = read_data;
endmodule

