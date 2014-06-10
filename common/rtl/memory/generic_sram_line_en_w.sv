/****************************************************************************
 * generic_sram_byte_en_w.sv
 ****************************************************************************/

/**
 * Module: generic_sram_byte_en_w
 * 
 * TODO: Add module documentation
 */
module generic_sram_line_en_w #(
		parameter int			MEM_ADDR_BITS=10,
		parameter int			MEM_DATA_BITS=32
		) (
			input							i_clk,
			generic_sram_line_en_if.sram	s
		);

	// VL doesn't like direct assignments from the modport
	// to the sram instance
	wire [MEM_DATA_BITS-1:0] write_data;
	wire [MEM_DATA_BITS-1:0] read_data;
	wire write_en;
	wire [MEM_ADDR_BITS-1:0] address;
	
	assign write_data = s.write_data;
	assign write_en = s.write_en;
	assign address = s.addr;
	assign s.read_data = read_data;
	
    generic_sram_line_en #(
    	.DATA_WIDTH      (MEM_DATA_BITS  ), 
    	.ADDRESS_WIDTH   (MEM_ADDR_BITS  )
    	) ram (
    	.i_clk           (i_clk         ), 
    	.i_write_data    (write_data    ),
    	.i_write_enable  (write_en      ), 
    	.i_address       (address       ),
    	.o_read_data     (read_data		)
    	);

endmodule

