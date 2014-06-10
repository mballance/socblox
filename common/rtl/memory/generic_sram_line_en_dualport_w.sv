/****************************************************************************
 * generic_sram_byte_en_w.sv
 ****************************************************************************/

/**
 * Module: generic_sram_byte_en_w
 * 
 * TODO: Add module documentation
 */
module generic_sram_line_en_dualport_w #(
		parameter int			MEM_ADDR_BITS=10,
		parameter int			MEM_DATA_BITS=32
		) (
			input							i_clk,
			generic_sram_line_en_if.sram	s_a,
			generic_sram_line_en_if.sram	s_b
		);

	// VL doesn't like direct assignments from the modport
	// to the sram instance
	wire [MEM_DATA_BITS-1:0] write_data_a;
	wire [MEM_DATA_BITS-1:0] read_data_a;
	wire write_en_a;
	wire [MEM_ADDR_BITS-1:0] address_a;
	
	wire [MEM_DATA_BITS-1:0] write_data_b;
	wire [MEM_DATA_BITS-1:0] read_data_b;
	wire write_en_b;
	wire [MEM_ADDR_BITS-1:0] address_b;
	
	assign write_data_a = s_a.write_data;
	assign write_en_a = s_a.write_en;
	assign address_a = s_a.addr;
	assign s_a.read_data = read_data_a;
	
	assign write_data_b = s_b.write_data;
	assign write_en_b = s_b.write_en;
	assign address_b = s_b.addr;
	assign s_b.read_data = read_data_b;
	
    generic_sram_line_en_dualport #(
    	.DATA_WIDTH      (MEM_DATA_BITS  ), 
    	.ADDRESS_WIDTH   (MEM_ADDR_BITS  )
    	) ram (
    	.i_clk           (i_clk         ), 
    	.i_write_data_a    (write_data_a),
    	.i_write_enable_a  (write_en_a  ), 
    	.i_address_a       (address_a   ),
    	.o_read_data_a     (read_data_a	),
    	.i_write_data_b    (write_data_b),
    	.i_write_enable_b  (write_en_b  ), 
    	.i_address_b       (address_b   ),
    	.o_read_data_b     (read_data_b	)
    	);

endmodule

