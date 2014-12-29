//////////////////////////////////////////////////////////////////
//                                                              //
//  Generic Library SRAM with single write enable               //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Configurable depth and width.                               //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////


module generic_sram_line_en_dualport #(
	parameter DATA_WIDTH            = 128,
	parameter ADDRESS_WIDTH         = 7,
	parameter INITIALIZE_TO_ZERO    = 0,
	parameter READ_DATA_REGISTERED  = 1
	) (
		input                           i_clk,

		input      [DATA_WIDTH-1:0]     i_write_data_a,
		input                           i_write_enable_a,
		input      [ADDRESS_WIDTH-1:0]  i_address_a,
		output     [DATA_WIDTH-1:0]     o_read_data_a,

		input      [DATA_WIDTH-1:0]     i_write_data_b,
		input                           i_write_enable_b,
		input      [ADDRESS_WIDTH-1:0]  i_address_b,
		output     [DATA_WIDTH-1:0]     o_read_data_b
	);                                                     

reg [DATA_WIDTH-1:0]   mem  [0:2**ADDRESS_WIDTH-1];
reg [ADDRESS_WIDTH-1:0]		address_a_r, address_b_r;
reg 						write_enable_a_r, write_enable_b_r;
reg [DATA_WIDTH-1:0]		write_data_a_r, write_data_b_r;
reg [DATA_WIDTH-1:0]		read_data_a_r, read_data_b_r;

generate
	if ( INITIALIZE_TO_ZERO ) begin : init0
		integer i;
		initial
		begin
			for (i=0;i<2**ADDRESS_WIDTH;i=i+1)
				mem[i] = 'd0;
		end
	end
endgenerate

generate
	if (READ_DATA_REGISTERED) begin
		assign o_read_data_a = read_data_a_r;
		assign o_read_data_b = read_data_b_r;
	end else begin
		assign o_read_data_a = mem[address_a_r];
		assign o_read_data_b = mem[address_b_r];
	end
endgenerate


// Port A
always @(posedge i_clk) begin
    // read
	address_a_r <= i_address_a;
	write_enable_a_r <= i_write_enable_a;
	write_data_a_r <= i_write_data_a;
	
	read_data_a_r <= mem[address_a_r];

    // write
	if (write_enable_a_r) begin
        mem[address_a_r] = write_data_a_r;
	end
end
    
// Port B
always @(posedge i_clk) begin
    // read
	address_b_r <= i_address_b;
	write_enable_b_r <= i_write_enable_b;
	write_data_b_r <= i_write_data_b;
	
	read_data_b_r <= mem[address_b_r];

    // write
	if (write_enable_b_r) begin
        mem[address_b_r] = write_data_b_r;
	end
end
    

endmodule

