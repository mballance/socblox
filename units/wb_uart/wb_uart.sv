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
//  However the UART standard provides for a 10% margin on       //
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

// Normally UART_REG_BAUD is defined in the system_config_defines.v file.
`ifndef UART_REG_BAUD
`define UART_REG_BAUD 230400
`endif

module wb_uart  #(
		parameter int WB_DWIDTH  = 32,
		parameter int WB_SWIDTH  = 4,
		parameter int CLK_PERIOD = 2,
		parameter int UART_BAUD = 230400
	) (
		input                       i_clk,

		wb_if.slave					slave,

		output                      o_uart_int,

		uart_if.dte					u
	);
	
	wire                       i_uart_cts_n;   // Clear To Send
	assign i_uart_cts_n = u.cts;
	wire                       o_uart_txd;     // Transmit data
	assign u.txd = o_uart_txd;
	wire                       o_uart_rts_n;   // Request to Send
	assign u.rts = o_uart_rts_n;
	wire                       i_uart_rxd;     // Receive data
	assign i_uart_rxd = u.rxd;

	wire       [31:0]          i_wb_adr;
	assign i_wb_adr = slave.ADR;
	wire       [WB_SWIDTH-1:0] i_wb_sel;
	assign i_wb_sel = slave.SEL;
	wire                       i_wb_we;
	assign i_wb_we = slave.WE;
	wire      [WB_DWIDTH-1:0] o_wb_dat;
	assign slave.DAT_R = o_wb_dat;
	wire       [WB_DWIDTH-1:0] i_wb_dat;
	assign i_wb_dat = slave.DAT_W;
	wire                       i_wb_cyc;
	assign i_wb_cyc = slave.CYC;
	wire                       i_wb_stb;
	assign i_wb_stb = slave.STB;
	wire                      o_wb_ack;
	assign slave.ACK = o_wb_ack;
	wire                      o_wb_err;
	assign slave.ERR = o_wb_err;

// `include "register_addresses.v"
	localparam UART_REG_PID0         =  16'h0fe0;
	localparam UART_REG_PID1         =  16'h0fe4;
	localparam UART_REG_PID2         =  16'h0fe8;
	localparam UART_REG_PID3         =  16'h0fec;
	localparam UART_REG_CID0         =  16'h0ff0;
	localparam UART_REG_CID1         =  16'h0ff4;
	localparam UART_REG_CID2         =  16'h0ff8;
	localparam UART_REG_CID3         =  16'h0ffc;
	localparam UART_REG_DR           =  16'h0000;
	localparam UART_REG_RSR          =  16'h0004;
	localparam UART_REG_LCRH         =  16'h0008;
	localparam UART_REG_LCRM         =  16'h000c;
	localparam UART_REG_LCRL         =  16'h0010;
	localparam UART_REG_CR           =  16'h0014;
	localparam UART_REG_FR           =  16'h0018;
	localparam UART_REG_IIR          =  16'h001c;
	localparam UART_REG_ICR          =  16'h001c;


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

`ifndef Veritak

/*
`ifdef XILINX_VIRTEX6_FPGA
localparam real CLK_FREQ          = 1200.0 / `AMBER_CLK_DIVIDER ; // MHz
`else
localparam real CLK_FREQ          = 800.0 / `AMBER_CLK_DIVIDER ; // MHz
`endif
 */

localparam real UART_BIT_PERIOD   = 1000000000 / UART_BAUD;      // nS
localparam real UART_WORD_PERIOD  = ( UART_BIT_PERIOD * 12 );    // nS
//localparam real CLK_PERIOD        = 1000 / CLK_FREQ;             // nS
localparam real CLKS_PER_WORD     = UART_WORD_PERIOD / CLK_PERIOD;
localparam real CLKS_PER_BIT      = CLKS_PER_WORD / 12;

initial begin
	$display("CLKS_PER_BIT=%d", int'(CLKS_PER_BIT));
end

// These are rounded to the nearest whole number
// i.e. 29.485960 -> 29
//      29.566303 -> 30    
localparam [9:0] TX_BITPULSE_COUNT         = int'(CLKS_PER_BIT);
localparam [9:0] TX_CLKS_PER_WORD          = int'(CLKS_PER_WORD);
`else
localparam [9:0] TX_BITPULSE_COUNT         = 30;
localparam [9:0] TX_CLKS_PER_WORD          = 360;
`endif

localparam [9:0] TX_BITADJUST_COUNT        = TX_CLKS_PER_WORD - 11*TX_BITPULSE_COUNT;

localparam [9:0] RX_BITPULSE_COUNT         = TX_BITPULSE_COUNT-2;
localparam [9:0] RX_HALFPULSE_COUNT        = TX_BITPULSE_COUNT/2 - 4;


// -------------------------------------------------------------------------

reg             tx_interrupt = 'd0;
reg             rx_interrupt = 'd0;
reg   [23:0]    rx_int_timer = 'd0;

wire            fifo_enable;

reg   [7:0]     tx_fifo    [0:15];
wire            tx_fifo_full;
wire            tx_fifo_empty;
wire            tx_fifo_half_or_less_full;
wire            tx_fifo_push;
wire            tx_fifo_push_not_full;
wire            tx_fifo_pop_not_empty;
reg   [4:0]     tx_fifo_wp = 'd0;
reg   [4:0]     tx_fifo_rp = 'd0;
reg   [4:0]     tx_fifo_count = 'd0;   // number of entries in the fifo
reg             tx_fifo_full_flag = 'd0;

reg   [7:0]     rx_fifo    [0:15];
reg             rx_fifo_empty = 1'd1;
reg             rx_fifo_full = 1'd0;
wire            rx_fifo_half_or_more;     // true when half full or greater
reg   [4:0]     rx_fifo_count = 'd0;   // number of entries in the fifo
wire            rx_fifo_push;
wire            rx_fifo_push_not_full;
wire            rx_fifo_pop;
wire            rx_fifo_pop_not_empty;
reg   [4:0]     rx_fifo_wp = 'd0;
reg   [4:0]     rx_fifo_rp = 'd0;

wire  [7:0]     tx_byte;
reg   [3:0]     txd_state = TXD_IDLE;
reg             txd = 1'd1;
reg             tx_bit_pulse = 'd0;
reg   [9:0]     tx_bit_pulse_count = 'd0;

reg   [7:0]     rx_byte = 'd0;
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
// Wishbone Interface
// ======================================================

// Can't start a write while a read is completing. The ack for the read cycle
// needs to be sent first
assign wb_start_write = i_wb_stb &&  i_wb_we && !wb_start_read_d1;
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

        
// ======================================================
// UART 0 Receive FIFO
// ======================================================    
                       
assign rx_fifo_pop           = wb_start_read && i_wb_adr[11:0] == UART_REG_DR;
assign rx_fifo_push_not_full = rx_fifo_push && !rx_fifo_full;
assign rx_fifo_pop_not_empty = rx_fifo_pop && !rx_fifo_empty;
assign rx_fifo_half_or_more  = rx_fifo_count >= 5'd8;


always @ ( posedge i_clk ) 
    begin
    if ( fifo_enable )
        begin
        // RX FIFO Push
        if ( rx_fifo_push_not_full )
            begin
            rx_fifo[rx_fifo_wp[3:0]]    <= rx_byte;                
            rx_fifo_wp                  <= rx_fifo_wp + 1'd1;
            end

        if ( rx_fifo_pop_not_empty )
            begin
            rx_fifo_rp                  <= rx_fifo_rp + 1'd1;
            end
            
        if ( rx_fifo_push_not_full && !rx_fifo_pop_not_empty )
            rx_fifo_count <= rx_fifo_count + 1'd1;
        else if ( rx_fifo_pop_not_empty  && !rx_fifo_push_not_full )
            rx_fifo_count <= rx_fifo_count - 1'd1;
        
        rx_fifo_full  <= rx_fifo_wp == {~rx_fifo_rp[4], rx_fifo_rp[3:0]};
        rx_fifo_empty <= rx_fifo_wp == rx_fifo_rp;
        
        if ( rx_fifo_empty || rx_fifo_pop )
            rx_int_timer     <= 'd0;
        else if ( rx_int_timer != RX_INTERRUPT_COUNT )
            rx_int_timer     <= rx_int_timer + 1'd1;
        
            
        end
    else    // No FIFO    
        begin
        rx_int_timer     <= 'd0;
        
        if ( rx_fifo_push )
            begin
            rx_fifo[0]         <= rx_byte;
            rx_fifo_empty      <= 1'd0;
            rx_fifo_full       <= 1'd1;
            end
        else if ( rx_fifo_pop )
            begin
            rx_fifo_empty      <= 1'd1;
            rx_fifo_full       <= 1'd0;
            end
        end
    end


// ======================================================
// Transmit Interrupts
// ======================================================    


// UART 0 Transmit Interrupt    
always @ ( posedge i_clk )
    begin 
    // Clear the interrupt
    if ( wb_start_write && i_wb_adr[11:0] == UART_REG_ICR )
        tx_interrupt <= 1'd0;

    // Set the interrupt    
    else if  ( fifo_enable ) 
        // This interrupt clears automatically as bytes are pushed into the tx fifo
        // cr bit 5 is Transmit Interrupt Enable
        tx_interrupt <= tx_fifo_half_or_less_full && uart_cr_reg[5];
    else 
        // This interrupt clears automatically when a byte is written to tx
        // cr bit 5 is Transmit Interrupt Enable
        tx_interrupt <= tx_fifo_empty && uart_cr_reg[5];
    end


// ======================================================
// Receive Interrupts
// ======================================================    

always @ ( posedge i_clk )
    if (fifo_enable)
        rx_interrupt <=  rx_fifo_half_or_more || rx_int_timer == RX_INTERRUPT_COUNT;
    else    
        rx_interrupt <=  rx_fifo_full;


assign o_uart_int   = ( tx_interrupt & uart_cr_reg[5] )  |  // UART transmit interrupt w/ enable
                      ( rx_interrupt & uart_cr_reg[4] )  ;  // UART receive  interrupt w/ enable

assign fifo_enable = uart_lcrh_reg[4];


       
// ========================================================
// UART Transmit
// ========================================================

assign   o_uart_txd                 = txd;

assign   tx_fifo_full               = fifo_enable ? tx_fifo_count >= 5'd16 :  tx_fifo_full_flag;
assign   tx_fifo_empty              = fifo_enable ? tx_fifo_count == 5'd00 : !tx_fifo_full_flag;
assign   tx_fifo_half_or_less_full  =               tx_fifo_count <= 5'd8;
assign   tx_byte                    = fifo_enable ? tx_fifo[tx_fifo_rp[3:0]] : tx_fifo[0] ;

assign   tx_fifo_push               = wb_start_write && i_wb_adr[11:0] == UART_REG_DR;
assign   tx_fifo_push_not_full      = tx_fifo_push && !tx_fifo_full;
assign   tx_fifo_pop_not_empty      = txd_state == TXD_STOP3 && tx_bit_pulse == 1'd1 && !tx_fifo_empty;

        
// Transmit FIFO
always @( posedge i_clk )
    begin      
    // Use 8-entry FIFO
    if ( fifo_enable )
        begin
        // Push
        if ( tx_fifo_push_not_full )
            begin
            tx_fifo[tx_fifo_wp[3:0]] <= wb_wdata32[7:0];
            tx_fifo_wp <= tx_fifo_wp + 1'd1;
            end
        
            
        // Pop    
        if ( tx_fifo_pop_not_empty )
            tx_fifo_rp <= tx_fifo_rp + 1'd1;
            
        // Count up 
        if (tx_fifo_push_not_full && !tx_fifo_pop_not_empty)
            tx_fifo_count <= tx_fifo_count + 1'd1;
            
        // Count down 
        else if (tx_fifo_pop_not_empty  && !tx_fifo_push_not_full)
            tx_fifo_count <= tx_fifo_count - 1'd1;
        end
        
    // Do not use 8-entry FIFO, single entry register instead
    else  
        begin
        // Clear FIFO values
        tx_fifo_wp    <= 'd0;
        tx_fifo_rp    <= 'd0;
        tx_fifo_count <= 'd0;
        
        // Push
        if ( tx_fifo_push_not_full )
            begin
            tx_fifo[0]          <= wb_wdata32[7:0];
            tx_fifo_full_flag   <= 1'd1;
            end
        // Pop    
        else if ( tx_fifo_pop_not_empty )
            tx_fifo_full_flag   <= 1'd0;

        end        
    end


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
                
                if ( uart0_cts_n_d[3:1] == 3'b000 && !tx_fifo_empty )
                    txd_state <= TXD_START;
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
    rxd_d[4:0] <= {rxd_d[3:0], i_uart_rxd};

assign rx_start = rxd_d[4:3] == 2'b11 && rxd_d[1:0] == 2'b00;


// ========================================================
// Receive state machine
// ========================================================

always @( posedge i_clk )
    case ( rxd_state )
    
        RXD_IDLE :
            if ( rx_fifo_full )
                rxen                    <= 1'd0;
            else
                begin
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
                rx_byte[0]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA1 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA2;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[1]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA2 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA3;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[2]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA3 :
            if ( rx_bit_pulse_count == RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA4;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[3]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA4 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA5;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[4]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA5 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA6;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[5]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA6 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_DATA7;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[6]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_DATA7 :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )
                begin
                rxd_state               <= RXD_STOP;
                restart_rx_bit_count    <= 1'd1;
                rx_byte[7]              <= i_uart_rxd;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        RXD_STOP :
            if ( rx_bit_pulse_count ==  RX_BITPULSE_COUNT )  // half way through stop bit 
                begin
                rxd_state               <= RXD_IDLE;
                restart_rx_bit_count    <= 1'd1;
                end
            else    
                restart_rx_bit_count    <= 1'd0;
            
        default :
            begin
            rxd_state       <= RXD_IDLE;
            end
            
    endcase

        
// ========================================================
// Register Writes
// ========================================================
always @( posedge i_clk )
    if ( wb_start_write )
        case ( i_wb_adr[11:0] )
            // Receive status, (Write) Error Clear
            UART_REG_RSR:  uart_rsr_reg      <= wb_wdata32[7:0];
            // Line Control High Byte    
            UART_REG_LCRH: uart_lcrh_reg     <= wb_wdata32[7:0];
            // Line Control Middle Byte    
            UART_REG_LCRM: uart_lcrm_reg     <= wb_wdata32[7:0];
            // Line Control Low Byte    
            UART_REG_LCRL: uart_lcrl_reg     <= wb_wdata32[7:0];
            // Control Register    
            UART_REG_CR:   uart_cr_reg       <= wb_wdata32[7:0];
        endcase


// ========================================================
// Register Reads
// ========================================================
always @( posedge i_clk )
    if ( wb_start_read )
        case ( i_wb_adr[11:0] )
        
            UART_REG_CID0:    wb_rdata32 <= 32'h0d;
            UART_REG_CID1:    wb_rdata32 <= 32'hf0;
            UART_REG_CID2:    wb_rdata32 <= 32'h05;
            UART_REG_CID3:    wb_rdata32 <= 32'hb1;
            UART_REG_PID0:    wb_rdata32 <= 32'h10;
            UART_REG_PID1:    wb_rdata32 <= 32'h10;
            UART_REG_PID2:    wb_rdata32 <= 32'h04;
            UART_REG_PID3:    wb_rdata32 <= 32'h00;
            
            UART_REG_DR:      // Rx data   
                    if ( fifo_enable )
                        wb_rdata32 <= {24'd0, rx_fifo[rx_fifo_rp[3:0]]};
                    else    
                        wb_rdata32 <= {24'd0, rx_fifo[0]};
                                      
            UART_REG_RSR:     wb_rdata32 <= uart_rsr_reg;          // Receive status, (Write) Error Clear
            UART_REG_LCRH:    wb_rdata32 <= uart_lcrh_reg;         // Line Control High Byte
            UART_REG_LCRM:    wb_rdata32 <= uart_lcrm_reg;         // Line Control Middle Byte
            UART_REG_LCRL:    wb_rdata32 <= uart_lcrl_reg;         // Line Control Low Byte
            UART_REG_CR:      wb_rdata32 <= uart_cr_reg;           // Control Register
            
            // UART Tx/Rx Status
            UART_REG_FR:      wb_rdata32 <= {tx_fifo_empty,       // tx fifo empty
                                             rx_fifo_full,        // rx fifo full
                                             tx_fifo_full,        // tx fifo full
                                             rx_fifo_empty,       // rx fifo empty
                                             !tx_fifo_empty,      // uart busy
                                             1'd1,                 // !Data Carrier Detect
                                             1'd1,                 // !Data Set Ready
                                             !uart0_cts_n_d[3]     // !Clear to Send
                                             };                    // Flag Register
            
            // Interrupt Status                                                    
            UART_REG_IIR:     wb_rdata32 <= {5'd0, 
                                             1'd0,                 // RTIS  - receive timeout interrupt
                                             tx_interrupt,         // TIS   - transmit interrupt status
                                             rx_interrupt,         // RIS   - receive interrupt status
                                             1'd0                  // Modem interrupt status
                                            };                     // (Write) Clear Int
                                            
            default:            wb_rdata32 <= 32'h00c0ffee;
            
        endcase

        


// =======================================================================================
// =======================================================================================
// =======================================================================================
// Non-synthesizable debug code
// =======================================================================================


//synopsys translate_off

// ========================================================
// Report UART Register accesses
// ========================================================
initial begin
	$display("%m: TX_BITPULSE_COUNT=%0d", TX_BITPULSE_COUNT);
end

`ifdef UNDEFINED    
`ifndef Veritak
// Check in case UART approximate period
// is too far off
initial
    begin
    if ((( TX_BITPULSE_COUNT * CLK_PERIOD ) > (UART_BIT_PERIOD * 1.03) ) ||
        (( TX_BITPULSE_COUNT * CLK_PERIOD ) < (UART_BIT_PERIOD * 0.97) ) )
        begin
        `TB_ERROR_MESSAGE
        $display("UART TX bit period, %.1f, is too big. UART will not work!", TX_BITPULSE_COUNT * CLK_PERIOD);
        $display("Baud rate is %f, and baud bit period is %.1f", UART_BAUD, UART_BIT_PERIOD);
        $display("Either reduce the baud rate, or increase the system clock frequency");
        $display("------");
        end
    end
`endif
`endif
    

`ifdef UART_REG_DEBUG
wire            wb_read_ack;
reg             uart0_rx_int_d1 = 'd0;

assign wb_read_ack = i_wb_stb && !i_wb_we &&  o_wb_ack;

`ifndef Veritak
initial
    begin
    $display("%m UART period = %f nS, want %f nS, %d, %d", 
             (TX_BITPULSE_COUNT*11 + TX_BITADJUST_COUNT) * CLK_PERIOD,
             UART_WORD_PERIOD,
             TX_BITPULSE_COUNT, TX_BITADJUST_COUNT);
    end
`endif


// Transmit Interrupts
always @ ( posedge i_clk )
    if ( wb_start_write && i_wb_adr[11:0] == UART_REG_ICR )
            ;
    else if ( fifo_enable ) 
        begin
        if (tx_interrupt == 1'd0 && tx_fifo_half_or_less_full && uart_cr_reg[5])
            $display("%m: tx_interrupt Interrupt Set with FIFO enabled");
        if (tx_interrupt == 1'd1 && !(tx_fifo_half_or_less_full && uart_cr_reg[5]))
            $display("%m: tx_interrupt Interrupt Cleared with FIFO enabled");
        end
    else
        begin
        if (tx_interrupt == 1'd0 && tx_fifo_empty && uart_cr_reg[5])
            $display("%m: tx_interrupt Interrupt Set with FIFO disabled");
        if (tx_interrupt == 1'd1 && !(tx_fifo_empty && uart_cr_reg[5]))
            $display("%m: tx_interrupt Interrupt Cleared with FIFO disabled");
        end


// Receive Interrupts
always @ ( posedge i_clk )
    begin
    uart0_rx_int_d1 <= rx_interrupt;

    if ( rx_interrupt && !uart0_rx_int_d1 )
        begin
        `TB_DEBUG_MESSAGE
        $display("rx_interrupt Interrupt fifo_enable %d, rx_fifo_full %d", 
                 fifo_enable, rx_fifo_full);
        $display("rx_fifo_half_or_more %d, rx_int_timer 0x%08h, rx_fifo_count %d", 
                 rx_fifo_half_or_more, rx_int_timer, rx_fifo_count);
        end
        
    if ( !rx_interrupt && uart0_rx_int_d1 )
        begin
        `TB_DEBUG_MESSAGE
        $display("rx_interrupt Interrupt Cleared fifo_enable %d, rx_fifo_full %d", 
                 fifo_enable, rx_fifo_full);
        $display("    rx_fifo_half_or_more %d, rx_int_timer 0x%08h, rx_fifo_count %d", 
                 rx_fifo_half_or_more, rx_int_timer, rx_fifo_count);
        end
    end


always @( posedge i_clk )
    if ( wb_read_ack || wb_start_write )
        begin
        `TB_DEBUG_MESSAGE
        
        if ( wb_start_write )
            $write("Write 0x%08x to   ", wb_wdata32);
        else
            $write("Read  0x%08x from ", o_wb_dat);
            
        case ( i_wb_adr[11:0] )
            UART_REG_PID0:    $write("UART PID0 register"); 
            UART_REG_PID1:    $write("UART PID1 register"); 
            UART_REG_PID2:    $write("UART PID2 register"); 
            UART_REG_PID3:    $write("UART PID3 register"); 
            UART_REG_CID0:    $write("UART CID0 register"); 
            UART_REG_CID1:    $write("UART CID1 register"); 
            UART_REG_CID2:    $write("UART CID2 register"); 
            UART_REG_CID3:    $write("UART CID3 register"); 
            UART_REG_DR:      $write("UART Tx/Rx char %c", wb_start_write ? wb_wdata32[7:0] : o_wb_dat[7:0] );
            UART_REG_RSR:     $write("UART (Read) Receive status, (Write) Error Clear");
            UART_REG_LCRH:    $write("UART Line Control High Byte");
            UART_REG_LCRM:    $write("UART Line Control Middle Byte");
            UART_REG_LCRL:    $write("UART Line Control Low Byte");
            UART_REG_CR:      $write("UART Control Register");
            UART_REG_FR:      $write("UART Flag Register");
            UART_REG_IIR:     $write("UART (Read) Interrupt Identification Register");

            default:
                begin
                `TB_ERROR_MESSAGE
                $write("Unknown UART Register region");
                end
        endcase
        
        $write(", Address 0x%08h\n", i_wb_adr); 
        end
`endif


// ========================================================
// Assertions
// ========================================================
`ifdef UNDEFINED
always @ ( posedge i_clk )
    begin
    if ( rx_fifo_pop  && !rx_fifo_push && rx_fifo_empty )
        begin
        `TB_WARNING_MESSAGE
        $write("UART rx FIFO underflow\n");
        end
    if ( !rx_fifo_pop  && rx_fifo_push && rx_fifo_full )
        begin
        `TB_WARNING_MESSAGE
        $write("UART rx FIFO overflow\n");
        end

    if ( tx_fifo_push && tx_fifo_full )
        begin
        `TB_WARNING_MESSAGE
        $display("UART tx FIFO overflow - char = %c", wb_wdata32[7:0]);
        end
    end
`endif    


// ========================================================
// Debug State Machines
// ========================================================

wire    [(10*8)-1:0]    xTXD_STATE;
wire    [(14*8)-1:0]    xRXD_STATE;

 
assign xTXD_STATE      = txd_state == TXD_IDLE       ? "TXD_IDLE"   :
                         txd_state == TXD_START      ? "TXD_START"  :
                         txd_state == TXD_DATA0      ? "TXD_DATA0"  :
                         txd_state == TXD_DATA1      ? "TXD_DATA1"  :
                         txd_state == TXD_DATA2      ? "TXD_DATA2"  :
                         txd_state == TXD_DATA3      ? "TXD_DATA3"  :
                         txd_state == TXD_DATA4      ? "TXD_DATA4"  :
                         txd_state == TXD_DATA5      ? "TXD_DATA5"  :
                         txd_state == TXD_DATA6      ? "TXD_DATA6"  :
                         txd_state == TXD_DATA7      ? "TXD_DATA7"  :
                         txd_state == TXD_STOP1      ? "TXD_STOP1"  :
                         txd_state == TXD_STOP2      ? "TXD_STOP2"  :
                         txd_state == TXD_STOP3      ? "TXD_STOP3"  :
                                                       "UNKNOWN"    ;

assign xRXD_STATE      = rxd_state == RXD_IDLE       ? "RXD_IDLE"      :
                         rxd_state == RXD_START      ? "RXD_START"     :
                         rxd_state == RXD_START_MID1 ? "RXD_START_MID1":
                         rxd_state == RXD_START_MID  ? "RXD_START_MID" :
                         rxd_state == RXD_DATA0      ? "RXD_DATA0"     :
                         rxd_state == RXD_DATA1      ? "RXD_DATA1"     :
                         rxd_state == RXD_DATA2      ? "RXD_DATA2"     :
                         rxd_state == RXD_DATA3      ? "RXD_DATA3"     :
                         rxd_state == RXD_DATA4      ? "RXD_DATA4"     :
                         rxd_state == RXD_DATA5      ? "RXD_DATA5"     :
                         rxd_state == RXD_DATA6      ? "RXD_DATA6"     :
                         rxd_state == RXD_DATA7      ? "RXD_DATA7"     :
                         rxd_state == RXD_STOP       ? "RXD_STOP"      :
                                                       "UNKNOWN"       ;

//synopsys translate_on


endmodule

