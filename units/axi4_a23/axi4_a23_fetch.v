/////////////////////////////////////////////////////////////////
//                                                              //
//  Fetch - Instantiates the fetch stage sub-modules of         //
//  the Amber 2 Core                                            //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Instantiates the Cache and Wishbone I/F                     //
//  Also contains a little bit of logic to decode memory        //
//  accesses to decide if they are cached or not                //
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


module axi4_a23_fetch #(
		parameter int A23_CACHE_WAYS = 4
		) (
input                       i_clk,
input						i_rstn,

input       [31:0]          i_address,
input                       i_address_valid,
input       [31:0]          i_address_nxt,      // un-registered version of address to the cache rams
input       [31:0]          i_write_data,
input                       i_write_enable,
output       [31:0]         o_read_data,
output						o_read_data_valid,
input                       i_priviledged,
input                       i_exclusive,        // high for read part of swap access
input       [3:0]           i_byte_enable,
input                       i_data_access,      // high for data petch, low for instruction fetch
input                       i_cache_enable,     // cache enable
input                       i_cache_flush,      // cache flush
input       [31:0]          i_cacheable_area,   // each bit corresponds to 2MB address space
input                       i_system_rdy,
output                      o_fetch_stall,      // when this is asserted all registers 
                                                // in all 3 pipeline stages are held
                                                // at their current values
output						o_dabt,
                                                

axi4_if.master				master

);

wire                        cache_stall;
wire                        stall_cache;
wire                        wb_stall;
wire    [31:0]              cache_read_data;
wire                        sel_cache;
wire                        sel_wb;
wire						ack_wb;
wire                        cache_wb_req;
wire                        address_cachable;

`ifdef UNDEFINED
always @(posedge i_clk) begin
	if (i_address_valid && !o_fetch_stall) begin
		$display("FETCH: 'h%08h 'h%08h", i_address, o_read_data);
	end
end
`endif

// ======================================
// Memory Decode
// ======================================
// assign address_cachable  = /*in_cachable_mem( i_address ) &&*/ i_cacheable_area[i_address[25:21]];
// 10 - 1024
// 11 - 2048
// 11 - 4096
// 12 - 8192
// 13 - 16384
// 14 - 32768
// 16 - 64k
// 17 - 128k
// 18 - 256k
// 19 - 512k
// 20 - 1m
// 21 - 2m
// 22 - 4m
// 23 - 8m
// 24 - 16m
// 25 - 32m
// 26 - 64m
// 27 - 128m
assign address_cachable  = i_cacheable_area[i_address[31:27]];

assign sel_cache         = address_cachable && i_address_valid && i_cache_enable &&  !i_exclusive;

// Don't start wishbone transfers when the cache is stalling the core
// The cache stalls the core during its initialization sequence
assign sel_wb            = !sel_cache && i_address_valid && !(cache_stall);

// Return read data either from the wishbone bus or the cache
assign o_read_data       = sel_cache  ? cache_read_data : 
                           sel_wb     ? master.RDATA    :
                                        32'hffeeddcc    ;
assign o_read_data_valid = 
	((sel_wb && ack_wb) || (sel_cache && !cache_stall));
	
// assign o_dabt = (i_exclusive && sel_wb && ack_wb);

// Stall the instruction decode and execute stages of the core
// when the fetch stage needs more than 1 cycle to return the requested
// read data
assign o_fetch_stall     = !i_system_rdy || wb_stall || cache_stall;

wire[31:0]						o_wb_adr;
wire[31:0]						i_wb_dat;

wire[31:0]						ARADDR;
wire[31:0]						RDATA;
wire							RVALID;

assign ARADDR = master.ARADDR;
assign RDATA = master.RDATA;
assign RVALID = master.RVALID;


// ======================================
// L1 Cache (Unified Instruction and Data)
// ======================================
axi4_a23_cache #(
		.WAYS(A23_CACHE_WAYS)
		) 
	u_cache 
	(
    .i_clk                      ( i_clk                 ),
    .i_rstn						( i_rstn				),
     
    .i_select                   ( sel_cache             ),
    .i_exclusive                ( i_exclusive           ),
    .i_write_data               ( i_write_data          ),
    .i_write_enable             ( i_write_enable        ),
    .i_address                  ( i_address             ),
    .i_address_nxt              ( i_address_nxt         ),
    .i_byte_enable              ( i_byte_enable         ),
    .i_cache_enable             ( i_cache_enable        ),
    .i_cache_flush              ( i_cache_flush         ),
    .o_read_data                ( cache_read_data       ),
    
    .o_stall                    ( cache_stall           ),
    .i_core_stall               ( o_fetch_stall         ),
    
    .o_wb_req                   ( cache_wb_req          ),
    .i_wb_address               ( ARADDR         		),
    .i_wb_read_data             ( RDATA					),
    .i_read_data_valid			( RVALID				),
    .i_wb_stall                 ( stall_cache			)
    
);



// ======================================
//  Wishbone Master I/F
// ======================================
axi4_a23_axi_if u_axi4 (
    // CPU Side
    .i_clk                      ( i_clk                 ),
    .i_rstn						( i_rstn				),
    
    // Core Accesses to Wishbone bus
    .i_select                   ( sel_wb                ),
    .o_ack						( ack_wb				),
    .o_dabt						( o_dabt				),
    .i_write_data               ( i_write_data          ),
    .i_write_enable             ( i_write_enable        ),
    .i_byte_enable              ( i_byte_enable         ),
    .i_data_access              ( i_data_access         ),
    .i_exclusive                ( i_exclusive           ),
    .i_address                  ( i_address             ),
    .o_stall                    ( wb_stall              ),

    // Cache Accesses to Wishbone bus 
    // L1 Cache enable - used for hprot
    .i_cache_req                ( cache_wb_req          ),
    
    .o_stall_cache				( stall_cache			),
    
    .master						( master				)
);


endmodule

