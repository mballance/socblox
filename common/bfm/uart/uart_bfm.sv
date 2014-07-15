//////////////////////////////////////////////////////////////////
//                                                              //
//  UART                                                        //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  This is a synchronous UART meaning it uses the system       //
//  clock rather than having its own clock. This means the      //
//  standard UART Baud rates are approximated and not exact.    //
//  However the UART tandard provides for a 10% margin on       //
//  baud rates and this module is much more accurate than that. //
//                                                              //
//  The Baud rate must be set before synthesis and is not       //
//  programmable. This keeps the UART small.                    //
//                                                              //
//  The UART uses 8 data bits, 1 stop bit and no parity bits.   //
//                                                              //
//  The UART has a 16-byte transmit and a 16-byte receive FIFO  //
//  These FIFOs are implemented in flipflops - FPGAs have lots  //
//  of flipflops!                                               //
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

//`include "system_config_defines.v"
//`include "global_defines.v"

// Normally UART_REG_BAUD is defined in the system_config_defines.v file.
`ifndef UART_REG_BAUD
`define UART_REG_BAUD 230400
`endif

module uart_bfm  #(
		parameter int CLK_PERIOD = 2,
		parameter int UART_BAUD = 230400
	) (
		input                       i_clk,
		uart_if.dce					u
	);
	
	wire                       o_uart_int;
	wire                       i_uart_cts_n;   // Clear To Send
//	assign i_uart_cts_n = u.cts;
	wire                       o_uart_rts_n;   // Request to Send
//	assign u.rts = o_uart_rts_n;
	assign u.cts = 0;

localparam int WB_SWIDTH  = 4;
localparam int WB_DWIDTH  = 32;
localparam [3:0] TXD_IDLE  = 4'd0,
                 TXD_START = 4'd1,
                 TXD_DATA0 = 4'd2,
                 TXD_DATA1 = 4'd3,
                 TXD_DATA2 = 4'd4,
                 TXD_DATA3 = 4'd5,
                 TXD_DATA4 = 4'd6,
                 TXD_DATA5 = 4'd7,
                 TXD_DATA6 = 4'd8,
                 TXD_DATA7 = 4'd9,
                 TXD_STOP1 = 4'd10,
                 TXD_STOP2 = 4'd11,
                 TXD_STOP3 = 4'd12;
                 
localparam [3:0] RXD_IDLE       = 4'd0,
                 RXD_START      = 4'd1,
                 RXD_START_MID  = 4'd2,
                 RXD_START_MID1 = 4'd3,
                 RXD_DATA0      = 4'd4,
                 RXD_DATA1      = 4'd5,
                 RXD_DATA2      = 4'd6,
                 RXD_DATA3      = 4'd7,
                 RXD_DATA4      = 4'd8,
                 RXD_DATA5      = 4'd9,
                 RXD_DATA6      = 4'd10,
                 RXD_DATA7      = 4'd11,
                 RXD_STOP       = 4'd12;


localparam RX_INTERRUPT_COUNT = 24'h3fffff; 


// -------------------------------------------------------------------------
// Baud Rate Configuration
// -------------------------------------------------------------------------

localparam real UART_BIT_PERIOD   = 1000000000 / UART_BAUD;      // nS
localparam real UART_WORD_PERIOD  = ( UART_BIT_PERIOD * 12 );    // nS
localparam real CLKS_PER_WORD     = UART_WORD_PERIOD / CLK_PERIOD;
localparam real CLKS_PER_BIT      = CLKS_PER_WORD / 12;

// These are rounded to the nearest whole number
// i.e. 29.485960 -> 29
//      29.566303 -> 30    
localparam [9:0] TX_BITPULSE_COUNT         = int'(CLKS_PER_BIT);
localparam [9:0] TX_CLKS_PER_WORD          = int'(CLKS_PER_WORD);

localparam [9:0] TX_BITADJUST_COUNT        = TX_CLKS_PER_WORD - 11*TX_BITPULSE_COUNT;

localparam [9:0] RX_BITPULSE_COUNT         = TX_BITPULSE_COUNT-2;
localparam [9:0] RX_HALFPULSE_COUNT        = TX_BITPULSE_COUNT/2 - 4;


// -------------------------------------------------------------------------

reg             tx_interrupt = 'd0;
reg             rx_interrupt = 'd0;
reg   [23:0]    rx_int_timer = 'd0;

reg   [7:0]     tx_byte;
reg				tx_byte_valid = 0;
reg   [3:0]     txd_state = TXD_IDLE;
reg             txd = 1'd1;
reg             tx_bit_pulse = 'd0;
reg   [9:0]     tx_bit_pulse_count = 'd0;

reg   [7:0]     rx_byte = 'd0;
reg				rx_byte_valid = 0;
reg   [3:0]     rxd_state = RXD_IDLE;
wire            rx_start;
reg             rxen = 'd0;
reg   [9:0]     rx_bit_pulse_count = 'd0;
reg             restart_rx_bit_count = 'd0;
reg   [4:0]     rxd_d = 5'h1f;
reg   [3:0]     uart0_cts_n_d = 4'hf;

// Wishbone registers
reg  [7:0]      uart_rsr_reg = 'd0;       // Receive status, (Write) Error Clear
reg  [7:0]      uart_lcrh_reg = 'd0;      // Line Control High Byte
reg  [7:0]      uart_lcrm_reg = 'd0;      // Line Control Middle Byte
reg  [7:0]      uart_lcrl_reg = 'd0;      // Line Control Low Byte
reg  [7:0]      uart_cr_reg = 'd0;        // Control Register

// Wishbone interface
reg  [31:0]     wb_rdata32 = 'd0;
wire            wb_start_write;
wire            wb_start_read;
reg             wb_start_read_d1 = 'd0;
wire [31:0]     wb_wdata32;

integer         i;

// ======================================================
// BFM task interface
// ======================================================

task uart_bfm_tx_start(byte unsigned ch);
	tx_byte = ch;
	tx_byte_valid = 1;
endtask
export "DPI-C" task uart_bfm_tx_start;

import "DPI-C" context task uart_bfm_tx_done();

import "DPI-C" context task uart_bfm_rx_done(byte unsigned ch);


// ========================================================
// UART Transmit
// ========================================================

assign	u.rxd = txd;

// ========================================================
// Register Clear to Send Input
// ========================================================
always @( posedge i_clk )
    uart0_cts_n_d <= {uart0_cts_n_d[2:0], i_uart_cts_n};
                                            

// ========================================================
// Transmit Pulse generater - matches baud rate      
// ========================================================
always @( posedge i_clk )
    if (( tx_bit_pulse_count == (TX_BITADJUST_COUNT-1) && txd_state == TXD_STOP2 ) ||
        ( tx_bit_pulse_count == (TX_BITPULSE_COUNT-1)  && txd_state != TXD_STOP2 )  )
        begin
        tx_bit_pulse_count <= 'd0;
        tx_bit_pulse       <= 1'd1;
        end
    else
        begin
        tx_bit_pulse_count <= tx_bit_pulse_count + 1'd1;
        tx_bit_pulse       <= 1'd0;
        end


// ========================================================
// Byte Transmitted
// ========================================================
    // Idle state, txd = 1
    // start bit, txd = 0
    // Data x 8, lsb first
    // stop bit, txd = 1
    
     
    // X = 0x58  = 01011000
always @( posedge i_clk )
    if ( tx_bit_pulse )
    
        case ( txd_state )
        
            TXD_IDLE :
                begin
                txd       <= 1'd1;
                
                if ( uart0_cts_n_d[3:1] == 3'b000 && tx_byte_valid )
                    txd_state <= TXD_START;
	                tx_byte_valid = 0;
                end
                
            TXD_START :
                begin
                txd       <= 1'd0;
                txd_state <= TXD_DATA0;
                end
                
            TXD_DATA0 :
                begin
                txd       <= tx_byte[0];
                txd_state <= TXD_DATA1;
                end
                
            TXD_DATA1 :
                begin
                txd       <= tx_byte[1];
                txd_state <= TXD_DATA2;
                end
                
            TXD_DATA2 :
                begin
                txd       <= tx_byte[2];
                txd_state <= TXD_DATA3;
                end
                
            TXD_DATA3 :
                begin
                txd       <= tx_byte[3];
                txd_state <= TXD_DATA4;
                end
                
            TXD_DATA4 :
                begin
                txd       <= tx_byte[4];
                txd_state <= TXD_DATA5;
                end
                
            TXD_DATA5 :
                begin
                txd       <= tx_byte[5];
                txd_state <= TXD_DATA6;
                end
                
            TXD_DATA6 :
                begin
                txd       <= tx_byte[6];
                txd_state <= TXD_DATA7;
                end
                
            TXD_DATA7 :
                begin
                txd       <= tx_byte[7];
                txd_state <= TXD_STOP1;
                end
                
            TXD_STOP1 :
                begin
                txd       <= 1'd1;
                txd_state <= TXD_STOP2;
                end

            TXD_STOP2 :
                begin
                txd       <= 1'd1;
                txd_state <= TXD_STOP3;
                end
                
            TXD_STOP3 :
                begin
                txd       <= 1'd1;
                txd_state <= TXD_IDLE;
                uart_bfm_tx_done();
                end
                
            default :
                begin
                txd       <= 1'd1;
                end
                
        endcase




// ========================================================
// UART Receive
// ========================================================

assign o_uart_rts_n  = ~rxen;

assign rx_fifo_push  = rxd_state == RXD_STOP && rx_bit_pulse_count == 10'd0;

// ========================================================
// Receive bit pulse
// ========================================================
// Pulse generater - matches baud rate      
always @( posedge i_clk )
    if ( restart_rx_bit_count )
        rx_bit_pulse_count <= 'd0;
    else
        rx_bit_pulse_count <= rx_bit_pulse_count + 1'd1;


// ========================================================
// Detect 1->0 transition. Filter out glitches and jaggedy transitions
// ========================================================
always @( posedge i_clk )
    rxd_d[4:0] <= {rxd_d[3:0], u.txd};

assign rx_start = rxd_d[4:3] == 2'b11 && rxd_d[1:0] == 2'b00;


// ========================================================
// Receive state machine
// ========================================================

always @( posedge i_clk )
    case ( rxd_state )
    
        RXD_IDLE : begin
	        rxd_state               <= RXD_START;
            rxen                    <= 1'd1;
            restart_rx_bit_count    <= 1'd1;
            rx_byte                 <= 'd0;
            end
            
        RXD_START : 
            // Filter out glitches and jaggedy transitions
            if ( rx_start ) 
                begin
                rxd_state               <= RXD_START_MID1;
                restart_rx_bit_count    <= 1'd1;
                end
            else    
                restart_rx_bit_count    <= 1'd0;

        // This state just delays the check on the
        // rx_bit_pulse_count value by 1 clock cycle to
        // give it time to reset
        RXD_START_MID1 :
            rxd_state               <= RXD_START_MID;
            
        RXD_START_MID :
            if ( rx_bit_pulse_count == RX_HALFPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA0;
                restart_rx_bit_count    <= 1'd1;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA0 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA1;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[0]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA1 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA2;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[1]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA2 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA3;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[2]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA3 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA4;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[3]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA4 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA5;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[4]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA5 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA6;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[5]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA6 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA7;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[6]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA7 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_STOP;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[7]              <= u.txd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_STOP :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )  // half way through stop bit 
                begin
                rxd_state               <= RXD_IDLE;
                restart_rx_bit_count    <= 1'd1;
                uart_bfm_rx_done(rx_byte);
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        default :
            begin
            rxd_state       <= RXD_IDLE;
            end
            
    endcase

    import "DPI-C" context task uart_bfm_register();
    initial begin
    	uart_bfm_register();
    end
endmodule

