//////////////////////////////////////////////////////////////////
//                                                              //
//  Generic Library SRAM with per byte write enable             //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Configurable depth and width. The DATA_WIDTH must be a      //
//  multiple of 8.                                              //
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


module generic_sram_byte_en
#(
parameter DATA_WIDTH    = 128,
parameter ADDRESS_WIDTH = 7,
parameter READ_DATA_REGISTERED = 1
)

(
input                           i_clk,
input      [DATA_WIDTH-1:0]     i_write_data,
input                           i_write_enable,
input      [ADDRESS_WIDTH-1:0]  i_address,
input      [DATA_WIDTH/8-1:0]   i_byte_enable,
output     [DATA_WIDTH-1:0]     o_read_data
    );                                                     

reg [DATA_WIDTH-1:0]   mem  [0:2**ADDRESS_WIDTH-1];
reg [DATA_WIDTH-1:0]	read_data_r;
reg [ADDRESS_WIDTH-1:0]		address_r;
reg [DATA_WIDTH-1:0]		write_data_r;
reg 						write_enable_r;
reg [DATA_WIDTH/8-1:0]		byte_enable_r;
integer i;

generate
	if (READ_DATA_REGISTERED) begin
		assign o_read_data = read_data_r;
	end else begin
		assign o_read_data = mem[address_r];
	end
endgenerate

always @(posedge i_clk) begin
    // read
    address_r 		<= i_address;
    write_data_r 	<= i_write_data;
    write_enable_r	<= i_write_enable;
    byte_enable_r	<= i_byte_enable;
    
    read_data_r <= mem[address_r];

    // write
    if (write_enable_r) begin
        for (i=0;i<DATA_WIDTH/8;i=i+1) begin
            mem[i_address][i*8+0] = byte_enable_r[i] ? write_data_r[i*8+0] : mem[address_r][i*8+0] ;
            mem[i_address][i*8+1] = byte_enable_r[i] ? write_data_r[i*8+1] : mem[address_r][i*8+1] ;
            mem[i_address][i*8+2] = byte_enable_r[i] ? write_data_r[i*8+2] : mem[address_r][i*8+2] ;
            mem[i_address][i*8+3] = byte_enable_r[i] ? write_data_r[i*8+3] : mem[address_r][i*8+3] ;
            mem[i_address][i*8+4] = byte_enable_r[i] ? write_data_r[i*8+4] : mem[address_r][i*8+4] ;
            mem[i_address][i*8+5] = byte_enable_r[i] ? write_data_r[i*8+5] : mem[address_r][i*8+5] ;
            mem[i_address][i*8+6] = byte_enable_r[i] ? write_data_r[i*8+6] : mem[address_r][i*8+6] ;
            mem[i_address][i*8+7] = byte_enable_r[i] ? write_data_r[i*8+7] : mem[address_r][i*8+7] ;
		end              
    end
end
    
    

endmodule

