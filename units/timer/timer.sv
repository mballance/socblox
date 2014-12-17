//////////////////////////////////////////////////////////////////
//                                                              //
//  Timer Module                                                //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Contains 3 configurable timers. Each timer can generate     //
//  either one-shot or cyclical interrupts                      //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//      - Matthew Ballance, matt.ballance@gmail.com             //
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
//`include "global_defines.v"

module timer_module  #(
	parameter int WB_DWIDTH = 32
	)(
		input                       i_clk,
		input						i_rstn,
		wb_if.slave					slave,
		output      [2:0]           o_timer_int
	);

wire [31:0]          		i_wb_adr;
wire [WB_DWIDTH/8-1:0] 		i_wb_sel;
wire i_wb_we;
wire [WB_DWIDTH-1:0] 		o_wb_dat;
wire [WB_DWIDTH-1:0] 		i_wb_dat;
wire                       i_wb_cyc;
wire                       i_wb_stb;
wire                       o_wb_ack;
wire                       o_wb_err;

assign i_wb_adr = slave.ADR;
assign i_wb_sel = slave.SEL;
assign i_wb_we  = slave.WE;
assign slave.DAT_R = o_wb_dat;
assign i_wb_dat = slave.DAT_W;
assign i_wb_cyc = slave.CYC;
assign i_wb_stb = slave.STB;
assign slave.ACK = o_wb_ack;
assign slave.ERR = o_wb_err;

localparam AMBER_TM_TIMER0_LOAD    =  16'h0000;
localparam AMBER_TM_TIMER0_VALUE   =  16'h0004;
localparam AMBER_TM_TIMER0_CTRL    =  16'h0008;
localparam AMBER_TM_TIMER0_CLR     =  16'h000c;
localparam AMBER_TM_TIMER1_LOAD    =  16'h0100;
localparam AMBER_TM_TIMER1_VALUE   =  16'h0104;
localparam AMBER_TM_TIMER1_CTRL    =  16'h0108;
localparam AMBER_TM_TIMER1_CLR     =  16'h010c;
localparam AMBER_TM_TIMER2_LOAD    =  16'h0200;
localparam AMBER_TM_TIMER2_VALUE   =  16'h0204;
localparam AMBER_TM_TIMER2_CTRL    =  16'h0208;
localparam AMBER_TM_TIMER2_CLR     =  16'h020c;

// Wishbone registers
reg  [15:0]     timer0_load_reg = 'd0;   // initial count value
reg  [15:0]     timer1_load_reg = 'd0;   // initial count value
reg  [15:0]     timer2_load_reg = 'd0;   // initial count value
reg  [23:0]     timer0_value_reg = 24'hffffff;  // current count value
reg  [23:0]     timer1_value_reg = 24'hffffff;  // current count value
reg  [23:0]     timer2_value_reg = 24'hffffff;  // current count value
reg  [7:0]      timer0_ctrl_reg = 'd0;   // control bits
reg  [7:0]      timer1_ctrl_reg = 'd0;   // control bits
reg  [7:0]      timer2_ctrl_reg = 'd0;   // control bits
reg             timer0_int_reg = 'd0;    // interrupt flag
reg             timer1_int_reg = 'd0;    // interrupt flag 
reg             timer2_int_reg = 'd0;    // interrupt flag

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

generate
if (WB_DWIDTH == 128) 
    begin : wb128
    assign wb_wdata32   = i_wb_adr[3:2] == 2'd3 ? i_wb_dat[127:96] :
                          i_wb_adr[3:2] == 2'd2 ? i_wb_dat[ 95:64] :
                          i_wb_adr[3:2] == 2'd1 ? i_wb_dat[ 63:32] :
                                                  i_wb_dat[ 31: 0] ;
                                                                                                                                            
    assign o_wb_dat    = {4{wb_rdata32}};
    end
else
    begin : wb32
    assign wb_wdata32  = i_wb_dat;
    assign o_wb_dat    = wb_rdata32;
    end
endgenerate

// ========================================================
// Timer Interrupt Outputs
// ========================================================
assign o_timer_int = { timer2_int_reg,
                       timer1_int_reg,
                       timer0_int_reg };


// ========================================================
// Register Writes
// ========================================================
always @( posedge i_clk )
    begin
   	if (i_rstn == 0) begin
   		timer0_load_reg <= 0;
   		timer1_load_reg <= 0;
   		timer2_load_reg <= 0;
   		timer0_value_reg <= 'hffffff;
   		timer1_value_reg <= 'hffffff;
   		timer2_value_reg <= 'hffffff;
   		timer0_ctrl_reg <= 0;
   		timer1_ctrl_reg <= 0;
   		timer2_ctrl_reg <= 0;
   		timer0_int_reg <= 0;
   		timer1_int_reg <= 0;
   		timer2_int_reg <= 0;
   	end else if ( wb_start_write )
        case ( i_wb_adr[11:0] )
            // write to timer control registers
            AMBER_TM_TIMER0_CTRL: timer0_ctrl_reg <= i_wb_dat[7:0];
            AMBER_TM_TIMER1_CTRL: timer1_ctrl_reg <= i_wb_dat[7:0];
            AMBER_TM_TIMER2_CTRL: timer2_ctrl_reg <= i_wb_dat[7:0];
        endcase

    // -------------------------------  
    // Timer 0
    // -------------------------------  
    if ( wb_start_write && i_wb_adr[11:0] == AMBER_TM_TIMER0_LOAD )
        begin
        timer0_value_reg <= {i_wb_dat[15:0], 8'd0};
        timer0_load_reg  <= i_wb_dat[15:0];
        end
    else if ( timer0_ctrl_reg[7] ) // Timer Enabled
        begin
        if ( timer0_value_reg == 24'd0 )
            begin
            if ( timer0_ctrl_reg[6] )  // periodic
                timer0_value_reg <= {timer0_load_reg, 8'd0};
            else    
                timer0_value_reg <= 24'hffffff;
            end
        else 
            case ( timer0_ctrl_reg[3:2] )
                2'b00:  timer0_value_reg <= (timer0_value_reg & 24'hffff00) - 9'd256;
                2'b01:  timer0_value_reg <= (timer0_value_reg & 24'hfffff0) - 9'd16;
                2'b10:  timer0_value_reg <=  timer0_value_reg               - 1'd1;
                default: 
                    begin
                    //synopsys translate_off
`ifdef UNDEFINED                    	
                    `TB_ERROR_MESSAGE
                    $write("unknown Timer Module Prescale Value %d for Timer 0", 
                           timer0_ctrl_reg[3:2]);
`endif                           
                    //synopsys translate_on
                    end
            endcase
        end

    
    // -------------------------------  
    // Timer 1
    // -------------------------------  
    if ( wb_start_write && i_wb_adr[11:0] == AMBER_TM_TIMER1_LOAD )
        begin
        timer1_value_reg <= {i_wb_dat[15:0], 8'd0};
        timer1_load_reg  <= i_wb_dat[15:0];
        end
    else if ( timer1_ctrl_reg[7] ) // Timer Enabled
        begin
        if ( timer1_value_reg == 24'd0 )
            begin
            if ( timer1_ctrl_reg[6] )  // periodic
                timer1_value_reg <= {timer1_load_reg, 8'd0};
            else    
                timer1_value_reg <= 24'hffffff;
            end
        else
            case ( timer1_ctrl_reg[3:2] )
                2'b00:  timer1_value_reg <= (timer1_value_reg & 24'hffff00) - 9'd256;
                2'b01:  timer1_value_reg <= (timer1_value_reg & 24'hfffff0) - 9'd16;
                2'b10:  timer1_value_reg <=  timer1_value_reg - 1'd1;
                default: 
                    begin
                    //synopsys translate_off
`ifdef UNDEFINED                    	
                    `TB_ERROR_MESSAGE
                    $write("unknown Timer Module Prescale Value %d for Timer 1", 
                           timer1_ctrl_reg[3:2]);
`endif                           
                    //synopsys translate_on
                    end
            endcase
        end
            


    // -------------------------------  
    // Timer 2
    // -------------------------------  
    if ( wb_start_write && i_wb_adr[11:0] == AMBER_TM_TIMER2_LOAD )
        begin
        timer2_value_reg <= {i_wb_dat[15:0], 8'd0};
        timer2_load_reg  <= i_wb_dat[15:0];
        end
    else if ( timer2_ctrl_reg[7] ) // Timer Enabled
        begin
        if ( timer2_value_reg == 24'd0 )
            begin
            if ( timer2_ctrl_reg[6] )  // periodic
                timer2_value_reg <= {timer2_load_reg, 8'd0};
            else    
                timer2_value_reg <= 24'hffffff;
            end
        else
            case ( timer2_ctrl_reg[3:2] )
                2'b00:  timer2_value_reg <= (timer2_value_reg & 24'hffff00) - 9'd256;
                2'b01:  timer2_value_reg <= (timer2_value_reg & 24'hfffff0) - 9'd16;
                2'b10:  timer2_value_reg <=  timer2_value_reg - 1'd1;
                default: 
                    begin
                    //synopsys translate_off
`ifdef UNDEFINED                    	
                    `TB_ERROR_MESSAGE
                    $write("unknown Timer Module Prescale Value %d for Timer 2", 
                           timer2_ctrl_reg[3:2]);
`endif                           
                    //synopsys translate_on
                    end
            endcase
        end
        
        
    // -------------------------------  
    // Timer generated Interrupt Flags    
    // -------------------------------  
    if ( wb_start_write && i_wb_adr[11:0] == AMBER_TM_TIMER0_CLR )
        timer0_int_reg <= 1'd0;
    else if ( timer0_value_reg == 24'd0 )
        // stays asserted until cleared
        timer0_int_reg <= 1'd1;

    if ( wb_start_write && i_wb_adr[11:0] == AMBER_TM_TIMER1_CLR)
        timer1_int_reg <= 1'd0;
    else if ( timer1_value_reg == 24'd0 )
        // stays asserted until cleared
        timer1_int_reg <= 1'd1;

    if ( wb_start_write && i_wb_adr[11:0] == AMBER_TM_TIMER2_CLR)
        timer2_int_reg <= 1'd0;
    else if ( timer2_value_reg == 24'd0 )
        // stays asserted until cleared
        timer2_int_reg <= 1'd1;
        
    end


// ========================================================
// Register Reads
// ========================================================
always @( posedge i_clk )
	if (i_rstn == 0) begin
		wb_rdata32 <= 0;
	end else begin
    if ( wb_start_read )
        case ( i_wb_adr[11:0] )
            AMBER_TM_TIMER0_LOAD: wb_rdata32 <= {16'd0, timer0_load_reg};
            AMBER_TM_TIMER1_LOAD: wb_rdata32 <= {16'd0, timer1_load_reg};
            AMBER_TM_TIMER2_LOAD: wb_rdata32 <= {16'd0, timer2_load_reg};
            AMBER_TM_TIMER0_CTRL: wb_rdata32 <= {24'd0, 
                                               timer0_ctrl_reg[7:6], 
                                               2'd0, 
                                               timer0_ctrl_reg[3:2],
                                               2'd0 
                                              };
            AMBER_TM_TIMER1_CTRL: wb_rdata32 <= {24'd0, 
                                               timer1_ctrl_reg[7:6], 
                                               2'd0, 
                                               timer1_ctrl_reg[3:2],
                                               2'd0 
                                              };
            AMBER_TM_TIMER2_CTRL: wb_rdata32 <= {24'd0, 
                                               timer2_ctrl_reg[7:6], 
                                               2'd0, 
                                               timer2_ctrl_reg[3:2],
                                               2'd0 
                                              };
            AMBER_TM_TIMER0_VALUE: wb_rdata32 <= {16'd0, timer0_value_reg[23:8]};
            AMBER_TM_TIMER1_VALUE: wb_rdata32 <= {16'd0, timer1_value_reg[23:8]};
            AMBER_TM_TIMER2_VALUE: wb_rdata32 <= {16'd0, timer2_value_reg[23:8]};
        
            default:               wb_rdata32 <= 32'h66778899;
            
        endcase
	end



// =======================================================================================
// =======================================================================================
// =======================================================================================
// Non-synthesizable debug code
// =======================================================================================


//synopsys translate_off

`ifdef AMBER_CT_DEBUG            

reg  timer0_int_reg_d1;
reg  timer1_int_reg_d1;
reg  timer2_int_reg_d1;
wire wb_read_ack = i_wb_stb && !i_wb_we &&  o_wb_ack;

// -----------------------------------------------
// Report Timer Module Register accesses
// -----------------------------------------------  
always @(posedge i_clk)
    if ( wb_read_ack || wb_start_write )
        begin
        `TB_DEBUG_MESSAGE
        
        if ( wb_start_write )
            $write("Write 0x%08x to   ", i_wb_dat);
        else
            $write("Read  0x%08x from ", o_wb_dat);
            
        case ( i_wb_adr[11:0] )
            AMBER_TM_TIMER0_LOAD:
                $write(" Timer Module Timer 0 Load"); 
            AMBER_TM_TIMER1_LOAD:
                $write(" Timer Module Timer 1 Load"); 
            AMBER_TM_TIMER2_LOAD:
                $write(" Timer Module Timer 2 Load"); 
            AMBER_TM_TIMER0_CTRL:
                $write(" Timer Module Timer 0 Control"); 
            AMBER_TM_TIMER1_CTRL:
                $write(" Timer Module Timer 1 Control"); 
            AMBER_TM_TIMER2_CTRL:
                $write(" Timer Module Timer 2 Control"); 
            AMBER_TM_TIMER0_VALUE:
                $write(" Timer Module Timer 0 Value"); 
            AMBER_TM_TIMER1_VALUE:
                $write(" Timer Module Timer 1 Value"); 
            AMBER_TM_TIMER2_VALUE:
                $write(" Timer Module Timer 2 Value"); 
            AMBER_TM_TIMER0_CLR:    
                $write(" Timer Module Timer 0 Clear"); 
            AMBER_TM_TIMER1_CLR:         
                $write(" Timer Module Timer 1 Clear"); 
            AMBER_TM_TIMER2_CLR:           
                $write(" Timer Module Timer 2 Clear"); 

            default:
                begin
                $write(" unknown Amber IC Register region");
                $write(", Address 0x%08h\n", i_wb_adr); 
                `TB_ERROR_MESSAGE
                end
        endcase
        
        $write(", Address 0x%08h\n", i_wb_adr); 
        end

always @(posedge i_clk)
    begin
    timer0_int_reg_d1 <= timer0_int_reg;
    timer1_int_reg_d1 <= timer1_int_reg;
    timer2_int_reg_d1 <= timer2_int_reg;
    
    if ( timer0_int_reg && !timer0_int_reg_d1 )
        begin
        `TB_DEBUG_MESSAGE
        $display("Timer Module Timer 0 Interrupt"); 
        end
    if ( timer1_int_reg && !timer1_int_reg_d1 )
        begin
        `TB_DEBUG_MESSAGE
        $display("Timer Module Timer 1 Interrupt"); 
        end
    if ( timer2_int_reg && !timer2_int_reg_d1 )
        begin
        `TB_DEBUG_MESSAGE
        $display("Timer Module Timer 2 Interrupt"); 
        end
    end        

`endif

//synopsys translate_on


endmodule

