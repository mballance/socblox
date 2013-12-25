//////////////////////////////////////////////////////////////////
//                                                              //
// Decompiler for Amber 2 Core                                  //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Decompiler for debugging core - not synthesizable           //
//  Shows instruction in Execute Stage at last clock of         //
//  the instruction                                             //
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
`include "a23_config_defines.v"

module a23_tracer
(
input                       i_clk,
input                       i_fetch_stall,
input       [31:0]          i_instruction,
input                       i_instruction_valid,
input                       i_instruction_undefined,
input                       i_instruction_execute,
input       [2:0]           i_interrupt,            // non-zero value means interrupt triggered
input                       i_interrupt_state,
input       [31:0]          i_instruction_address,
input       [1:0]           i_pc_sel,
input                       i_pc_wen,
input						i_write_enable,
input						fetch_stall,
input						i_data_access,
input		[31:0]			pc_nxt,
input		[31:0]			i_address,
input		[31:0]			i_write_data,
input		[3:0]			i_byte_enable,
input		[31:0]			i_read_data
);

// Shell is overridden with a bind

endmodule

