//////////////////////////////////////////////////////////////////
//                                                              //
//  Interrupt Controller for Amber                              //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Wishbone slave module that arbitrates between a number of   //
//  interrupt sources.
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//		- Matthew Ballance, matt.ballance@gmail.com				//
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


module interrupt_controller(
input                       i_clk,

wb_if.slave					slave,


output reg                  o_irq = 1'b0,
output reg                  o_firq = 1'b0,

input		[15:0]			i_interrupts

);
	
wire       [31:0]          i_wb_adr;
assign i_wb_adr = slave.ADR;
wire       [3:0] 			i_wb_sel;
assign i_wb_sel = slave.SEL;
wire                       i_wb_we;
assign i_wb_we = slave.WE;
wire      [31:0] o_wb_dat;
assign slave.DAT_R = o_wb_dat;
wire       [31:0] i_wb_dat;
assign i_wb_dat = slave.DAT_W;
wire                       i_wb_cyc;
assign i_wb_cyc = slave.CYC;
wire                       i_wb_stb;
assign i_wb_stb = slave.STB;
wire                      o_wb_ack;
assign slave.ACK = o_wb_ack;
wire                      o_wb_err;
assign slave.ERR = o_wb_err;

localparam IC_IRQ0_ENABLESET  = 0;
localparam IC_IRQ0_ENABLECLR  = 1;
localparam IC_IRQ0_RAWSTAT    = 2;
localparam IC_IRQ0_STATUS     = 3;

localparam IC_FIRQ0_ENABLESET = 4;
localparam IC_FIRQ0_ENABLECLR = 5;
localparam IC_FIRQ0_RAWSTAT   = 6;
localparam IC_FIRQ0_STATUS    = 7;

localparam IC_IRQ1_ENABLESET  = 8;
localparam IC_IRQ1_ENABLECLR  = 9;
localparam IC_IRQ1_RAWSTAT    = 10;
localparam IC_IRQ1_STATUS     = 11;

localparam IC_FIRQ1_ENABLESET = 12;
localparam IC_FIRQ1_ENABLECLR = 13;
localparam IC_FIRQ1_RAWSTAT   = 14;
localparam IC_FIRQ1_STATUS    = 15;

localparam IC_INT_SOFTSET     = 16;
localparam IC_INT_SOFTCLEAR   = 17;


// Wishbone registers
reg  [31:0]     irq0_enable_reg  = 'd0;
reg  [31:0]     firq0_enable_reg = 'd0;
reg  [31:0]     irq1_enable_reg  = 'd0;
reg  [31:0]     firq1_enable_reg = 'd0;
reg  [15:0]		softint_reg = 0;

wire [31:0]     raw_interrupts;
reg [31:0]     irq0_interrupts;
reg [31:0]     firq0_interrupts;
reg [31:0]     irq1_interrupts;
reg [31:0]     firq1_interrupts;

wire            irq_0;
wire            firq_0;
wire            irq_1;
wire            firq_1;

// Wishbone interface
reg  [31:0]     wb_rdata32 = 'd0;
wire            wb_start_write;
wire            wb_start_read;
reg             wb_start_read_d1 = 'd0;
wire [31:0]     wb_wdata32;


// ======================================================
// Wishbone Interface
// ======================================================

// Can't start a write while a read is completing. The ack for the read cycle
// needs to be sent first
assign wb_start_write = i_wb_stb && i_wb_we && !wb_start_read_d1;
assign wb_start_read  = i_wb_stb && !i_wb_we && !o_wb_ack;

always @( posedge i_clk )
    wb_start_read_d1 <= wb_start_read;


assign o_wb_err = 1'd0;
assign o_wb_ack = i_wb_stb && ( wb_start_write || wb_start_read_d1 );

assign wb_wdata32  = i_wb_dat;
assign o_wb_dat    = wb_rdata32;


// ======================================
// Interrupts
// ======================================
assign raw_interrupts = {i_interrupts, softint_reg};

always @(posedge i_clk) begin
	irq0_interrupts  <= raw_interrupts & irq0_enable_reg;
	firq0_interrupts <= raw_interrupts & firq0_enable_reg;
	irq1_interrupts  <= raw_interrupts & irq1_enable_reg;
	firq1_interrupts <= raw_interrupts & firq1_enable_reg;
	
	o_irq <= (|irq0_interrupts) | (|irq1_interrupts);
	o_firq <= (|firq0_interrupts) | (|firq1_interrupts);
end

// ========================================================
// Register Writes
// ========================================================
always @( posedge i_clk )
    if ( wb_start_write )
        case ( i_wb_adr[11:2] )
            IC_IRQ0_ENABLESET:  irq0_enable_reg  <=  irq0_enable_reg  | ( i_wb_dat);
            IC_IRQ0_ENABLECLR:  irq0_enable_reg  <=  irq0_enable_reg  & (~i_wb_dat);
            IC_FIRQ0_ENABLESET: firq0_enable_reg <=  firq0_enable_reg | ( i_wb_dat);
            IC_FIRQ0_ENABLECLR: firq0_enable_reg <=  firq0_enable_reg & (~i_wb_dat);

            IC_INT_SOFTSET:     softint_reg      <=  softint_reg      | ( i_wb_dat[15:0]);
            IC_INT_SOFTCLEAR:   softint_reg      <=  softint_reg      & (~i_wb_dat[15:0]);

            IC_IRQ1_ENABLESET:  irq1_enable_reg  <=  irq1_enable_reg  | ( i_wb_dat);
            IC_IRQ1_ENABLECLR:  irq1_enable_reg  <=  irq1_enable_reg  & (~i_wb_dat);
            IC_FIRQ1_ENABLESET: firq1_enable_reg <=  firq1_enable_reg | ( i_wb_dat);
            IC_FIRQ1_ENABLECLR: firq1_enable_reg <=  firq1_enable_reg & (~i_wb_dat);

        endcase


// ========================================================
// Register Reads
// ========================================================
always @( posedge i_clk )
    if ( wb_start_read )
        case ( i_wb_adr[11:2] )

            IC_IRQ0_ENABLESET:    wb_rdata32 <= irq0_enable_reg;
            IC_FIRQ0_ENABLESET:   wb_rdata32 <= firq0_enable_reg;
            IC_IRQ0_RAWSTAT:      wb_rdata32 <= raw_interrupts;
            IC_IRQ0_STATUS:       wb_rdata32 <= irq0_interrupts;
            IC_FIRQ0_RAWSTAT:     wb_rdata32 <= raw_interrupts;
            IC_FIRQ0_STATUS:      wb_rdata32 <= firq0_interrupts;

            IC_INT_SOFTSET:       wb_rdata32 <= {15'd0, softint_reg};
            IC_INT_SOFTCLEAR:     wb_rdata32 <= {15'd0, softint_reg};

            IC_IRQ1_ENABLESET:    wb_rdata32 <= irq1_enable_reg;
            IC_FIRQ1_ENABLESET:   wb_rdata32 <= firq1_enable_reg;
            IC_IRQ1_RAWSTAT:      wb_rdata32 <= raw_interrupts;
            IC_IRQ1_STATUS:       wb_rdata32 <= irq1_interrupts;
            IC_FIRQ1_RAWSTAT:     wb_rdata32 <= raw_interrupts;
            IC_FIRQ1_STATUS:      wb_rdata32 <= firq1_interrupts;

            default:                    wb_rdata32 <= 32'h22334455;

        endcase



// =======================================================================================
// =======================================================================================
// =======================================================================================
// Non-synthesizable debug code
// =======================================================================================


//synopsys translate_off
`ifdef AMBER_IC_DEBUG

wire wb_read_ack = i_wb_stb && ( wb_start_write || wb_start_read_d1 );

// -----------------------------------------------
// Report Interrupt Controller Register accesses
// -----------------------------------------------
always @(posedge i_clk)
    if ( wb_read_ack || wb_start_write )
        begin
        `TB_DEBUG_MESSAGE

        if ( wb_start_write )
            $write("Write 0x%08x to   ", i_wb_dat);
        else
            $write("Read  0x%08x from ", o_wb_dat);

        case ( i_wb_adr[15:0] )
            AMBER_IC_IRQ0_STATUS:
                $write(" Interrupt Controller module IRQ0 Status");
            AMBER_IC_IRQ0_RAWSTAT:
                $write(" Interrupt Controller module IRQ0 Raw Status");
            AMBER_IC_IRQ0_ENABLESET:
                $write(" Interrupt Controller module IRQ0 Enable Set");
            AMBER_IC_IRQ0_ENABLECLR:
                $write(" Interrupt Controller module IRQ0 Enable Clear");
            AMBER_IC_FIRQ0_STATUS:
                $write(" Interrupt Controller module FIRQ0 Status");
            AMBER_IC_FIRQ0_RAWSTAT:
                $write(" Interrupt Controller module FIRQ0 Raw Status");
            AMBER_IC_FIRQ0_ENABLESET:
                $write(" Interrupt Controller module FIRQ0 Enable set");
            AMBER_IC_FIRQ0_ENABLECLR:
                $write(" Interrupt Controller module FIRQ0 Enable Clear");
            AMBER_IC_INT_SOFTSET_0:
                $write(" Interrupt Controller module SoftInt 0 Set");
            AMBER_IC_INT_SOFTCLEAR_0:
                $write(" Interrupt Controller module SoftInt 0 Clear");
            AMBER_IC_IRQ1_STATUS:
                $write(" Interrupt Controller module IRQ1 Status");
            AMBER_IC_IRQ1_RAWSTAT:
                $write(" Interrupt Controller module IRQ1 Raw Status");
            AMBER_IC_IRQ1_ENABLESET:
                $write(" Interrupt Controller module IRQ1 Enable Set");
            AMBER_IC_IRQ1_ENABLECLR:
                $write(" Interrupt Controller module IRQ1 Enable Clear");
            AMBER_IC_FIRQ1_STATUS:
                $write(" Interrupt Controller module FIRQ1 Status");
            AMBER_IC_FIRQ1_RAWSTAT:
                $write(" Interrupt Controller module FIRQ1 Raw Status");
            AMBER_IC_FIRQ1_ENABLESET:
                $write(" Interrupt Controller module FIRQ1 Enable set");
            AMBER_IC_FIRQ1_ENABLECLR:
                $write(" Interrupt Controller module FIRQ1 Enable Clear");
            AMBER_IC_INT_SOFTSET_1:
                $write(" Interrupt Controller module SoftInt 1 Set");
            AMBER_IC_INT_SOFTCLEAR_1:
                $write(" Interrupt Controller module SoftInt 1 Clear");

            default:
                begin
                $write(" unknown Amber IC Register region");
                $write(", Address 0x%08h\n", i_wb_adr);
                `TB_ERROR_MESSAGE
                end
        endcase

        $write(", Address 0x%08h\n", i_wb_adr);
        end
`endif

//synopsys translate_on


endmodule

