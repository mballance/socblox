// megafunction wizard: %RAM: 2-PORT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altsyncram 

// ============================================================
// File Name: generic_sram_line_en_dualport.v
// Megafunction Name(s):
// 			altsyncram
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.1.0 Build 162 10/23/2013 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module generic_sram_line_en_dualport #(
		parameter DATA_WIDTH			= 128,
		parameter ADDRESS_WIDTH			= 7,
		parameter INITIALIZE_TO_ZERO	= 0
	) (
	i_clk,
	
	i_write_data_a,
	i_write_enable_a,
	i_address_a,
	o_read_data_a,
	
	i_address_b,
	i_write_data_b,
	i_write_enable_b,
	o_read_data_b);

	input	[ADDRESS_WIDTH-1:0]  i_address_a;
	input	[ADDRESS_WIDTH-1:0]  i_address_b;
	input	  i_clk;
	input	[DATA_WIDTH-1:0]  i_write_data_a;
	input	[DATA_WIDTH-1:0]  i_write_data_b;
	input	  i_write_enable_a;
	input	  i_write_enable_b;
	output	[DATA_WIDTH-1:0]  o_read_data_a;
	output	[DATA_WIDTH-1:0]  o_read_data_b;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  i_clk;
	tri0	  i_write_enable_a;
	tri0	  i_write_enable_b;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [DATA_WIDTH-1:0] sub_wire0;
	wire [DATA_WIDTH-1:0] sub_wire1;
	wire [DATA_WIDTH-1:0] o_read_data_a = sub_wire0[DATA_WIDTH-1:0];
	wire [DATA_WIDTH-1:0] o_read_data_b = sub_wire1[DATA_WIDTH-1:0];

	altsyncram	altsyncram_component (
				.clock0 (i_clk),
				.wren_a (i_write_enable_a),
				.address_b (i_address_b),
				.data_b (i_write_data_b),
				.wren_b (i_write_enable_b),
				.address_a (i_address_a),
				.data_a (i_write_data_a),
				.q_a (sub_wire0),
				.q_b (sub_wire1),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.eccstatus (),
				.rden_a (1'b1),
				.rden_b (1'b1));
	defparam
		altsyncram_component.address_reg_b = "CLOCK0",
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_input_b = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.clock_enable_output_b = "BYPASS",
		altsyncram_component.indata_reg_b = "CLOCK0",
		altsyncram_component.intended_device_family = "Cyclone IV GX",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = (1 << ADDRESS_WIDTH),
		altsyncram_component.numwords_b = (1 << ADDRESS_WIDTH),
		altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_aclr_b = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.outdata_reg_b = "CLOCK0",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = ADDRESS_WIDTH,
		altsyncram_component.widthad_b = ADDRESS_WIDTH,
		altsyncram_component.width_a = DATA_WIDTH,
		altsyncram_component.width_b = DATA_WIDTH,
		altsyncram_component.width_byteena_a = 1,
		altsyncram_component.width_byteena_b = 1,
		altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK0";


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
// Retrieval info: PRIVATE: ADDRESSSTALL_B NUMERIC "0"
// Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
// Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
// Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
// Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_B NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_B NUMERIC "0"
// Retrieval info: PRIVATE: CLRdata NUMERIC "0"
// Retrieval info: PRIVATE: CLRq NUMERIC "0"
// Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
// Retrieval info: PRIVATE: CLRrren NUMERIC "0"
// Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
// Retrieval info: PRIVATE: CLRwren NUMERIC "0"
// Retrieval info: PRIVATE: i_clk NUMERIC "0"
// Retrieval info: PRIVATE: Clock_A NUMERIC "0"
// Retrieval info: PRIVATE: Clock_B NUMERIC "0"
// Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
// Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "1"
// Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_A"
// Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
// Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
// Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
// Retrieval info: PRIVATE: MEMSIZE NUMERIC "32768"
// Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
// Retrieval info: PRIVATE: MIFfilename STRING ""
// Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "3"
// Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "1"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "2"
// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_A NUMERIC "3"
// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_B NUMERIC "3"
// Retrieval info: PRIVATE: REGdata NUMERIC "1"
// Retrieval info: PRIVATE: REGq NUMERIC "1"
// Retrieval info: PRIVATE: REGrdaddress NUMERIC "0"
// Retrieval info: PRIVATE: REGrren NUMERIC "0"
// Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
// Retrieval info: PRIVATE: REGwren NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: USE_DIFF_CLKEN NUMERIC "0"
// Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
// Retrieval info: PRIVATE: VarWidth NUMERIC "0"
// Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "32"
// Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "32"
// Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "32"
// Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "32"
// Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "1"
// Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: enable NUMERIC "0"
// Retrieval info: PRIVATE: rden NUMERIC "0"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: ADDRESS_REG_B STRING "CLOCK0"
// Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_A STRING "BYPASS"
// Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_B STRING "BYPASS"
// Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_A STRING "BYPASS"
// Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_B STRING "BYPASS"
// Retrieval info: CONSTANT: INDATA_REG_B STRING "CLOCK0"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
// Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "1024"
// Retrieval info: CONSTANT: NUMWORDS_B NUMERIC "1024"
// Retrieval info: CONSTANT: OPERATION_MODE STRING "BIDIR_DUAL_PORT"
// Retrieval info: CONSTANT: OUTDATA_ACLR_A STRING "NONE"
// Retrieval info: CONSTANT: OUTDATA_ACLR_B STRING "NONE"
// Retrieval info: CONSTANT: OUTDATA_REG_A STRING "CLOCK0"
// Retrieval info: CONSTANT: OUTDATA_REG_B STRING "CLOCK0"
// Retrieval info: CONSTANT: POWER_UP_UNINITIALIZED STRING "FALSE"
// Retrieval info: CONSTANT: READ_DURING_WRITE_MODE_MIXED_PORTS STRING "DONT_CARE"
// Retrieval info: CONSTANT: READ_DURING_WRITE_MODE_PORT_A STRING "NEW_DATA_NO_NBE_READ"
// Retrieval info: CONSTANT: READ_DURING_WRITE_MODE_PORT_B STRING "NEW_DATA_NO_NBE_READ"
// Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "10"
// Retrieval info: CONSTANT: WIDTHAD_B NUMERIC "10"
// Retrieval info: CONSTANT: WIDTH_A NUMERIC "32"
// Retrieval info: CONSTANT: WIDTH_B NUMERIC "32"
// Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
// Retrieval info: CONSTANT: WIDTH_BYTEENA_B NUMERIC "1"
// Retrieval info: CONSTANT: WRCONTROL_WRADDRESS_REG_B STRING "CLOCK0"
// Retrieval info: USED_PORT: i_address_a 0 0 10 0 INPUT NODEFVAL "i_address_a[9..0]"
// Retrieval info: USED_PORT: i_address_b 0 0 10 0 INPUT NODEFVAL "i_address_b[9..0]"
// Retrieval info: USED_PORT: i_clk 0 0 0 0 INPUT VCC "i_clk"
// Retrieval info: USED_PORT: i_write_data_a 0 0 32 0 INPUT NODEFVAL "i_write_data_a[31..0]"
// Retrieval info: USED_PORT: i_write_data_b 0 0 32 0 INPUT NODEFVAL "i_write_data_b[31..0]"
// Retrieval info: USED_PORT: o_read_data_a 0 0 32 0 OUTPUT NODEFVAL "o_read_data_a[31..0]"
// Retrieval info: USED_PORT: o_read_data_b 0 0 32 0 OUTPUT NODEFVAL "o_read_data_b[31..0]"
// Retrieval info: USED_PORT: i_write_enable_a 0 0 0 0 INPUT GND "i_write_enable_a"
// Retrieval info: USED_PORT: i_write_enable_b 0 0 0 0 INPUT GND "i_write_enable_b"
// Retrieval info: CONNECT: @i_address_a 0 0 10 0 i_address_a 0 0 10 0
// Retrieval info: CONNECT: @i_address_b 0 0 10 0 i_address_b 0 0 10 0
// Retrieval info: CONNECT: @clock0 0 0 0 0 i_clk 0 0 0 0
// Retrieval info: CONNECT: @i_write_data_a 0 0 32 0 i_write_data_a 0 0 32 0
// Retrieval info: CONNECT: @i_write_data_b 0 0 32 0 i_write_data_b 0 0 32 0
// Retrieval info: CONNECT: @i_write_enable_a 0 0 0 0 i_write_enable_a 0 0 0 0
// Retrieval info: CONNECT: @i_write_enable_b 0 0 0 0 i_write_enable_b 0 0 0 0
// Retrieval info: CONNECT: o_read_data_a 0 0 32 0 @o_read_data_a 0 0 32 0
// Retrieval info: CONNECT: o_read_data_b 0 0 32 0 @o_read_data_b 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL generic_sram_line_en_dualport.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL generic_sram_line_en_dualport.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL generic_sram_line_en_dualport.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL generic_sram_line_en_dualport.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL generic_sram_line_en_dualport_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL generic_sram_line_en_dualport_bb.v TRUE
// Retrieval info: LIB_FILE: altera_mf
