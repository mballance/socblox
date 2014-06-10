/****************************************************************************
 * generic_sram_byte_en_if.sv
 ****************************************************************************/

/**
 * Interface: generic_sram_byte_en_if
 * 
 * TODO: Add interface documentation
 */
interface generic_sram_byte_en_if #(
		parameter int NUM_ADDR_BITS=32,
		parameter int NUM_DATA_BITS=32);
	
	bit[NUM_ADDR_BITS-1:0]			addr;
	bit[NUM_DATA_BITS-1:0]			read_data;
	bit[NUM_DATA_BITS-1:0]			write_data;
	bit								write_en;
	bit[NUM_DATA_BITS/8-1:0]		byte_en;
	bit								read_en;

	modport sram(
			input addr,
			output  read_data,
			input write_data,
			input write_en,
			input byte_en,
			input read_en);
	
	modport sram_client(
			output  addr,
			input read_data,
			output  write_data,
			output  write_en,
			output  byte_en,
			output  read_en);


endinterface

