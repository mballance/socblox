/****************************************************************************
 * a23_unicore_sys.sv
 ****************************************************************************/
 
`ifndef BOOT_ROM_FILE
`define BOOT_ROM_FILE "rom.hex"
`endif
 

/**
 * Module: a23_unicore_sys
 * 
 * TODO: Add module documentation
 */
module a23_unicore_sys(
		input			brdclk,
		input			brdrstn,
		uart_if.dte		u
		);
	
	localparam MASTER_ID_WIDTH = 5;
	localparam SLAVE_ID_WIDTH = 6;
	localparam bit[31:0] PERIPH_BASE_ADDR = 'hf0000000;
	
	wire clk, rstn;
	
	assign clk = brdclk;
	assign rstn = brdrstn;
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (MASTER_ID_WIDTH)
		) core2ic (
		.ACLK                (clk		), 
		.ARESETn             (rstn		));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH    )
		) ic2rom (
		.ACLK                (clk               ), 
		.ARESETn             (rstn            ));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH    )
		) ic2ram (
		.ACLK                (clk               ), 
		.ARESETn             (rstn            ));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH    )
		) ic2uart (
		.ACLK                (clk               ), 
		.ARESETn             (rstn            ));
	
	a23_unicore_subsys #(
			PERIPH_BASE_ADDR + (4096*0)
		) a23_subsys_0 (
		.clk        (clk       ),
		.rstn       (rstn      ),
		.master		(core2ic.master));

	axi4_interconnect_1x3 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (MASTER_ID_WIDTH),
		.SLAVE0_ADDR_BASE    ('h00000000  ), 
		.SLAVE0_ADDR_LIMIT   ('h00003fff  ),
		.SLAVE1_ADDR_BASE    ('h20000000  ),
		.SLAVE1_ADDR_LIMIT   ('h20003fff  ),
		.SLAVE2_ADDR_BASE    (PERIPH_BASE_ADDR + (4096*1)    ), 
		.SLAVE2_ADDR_LIMIT   (PERIPH_BASE_ADDR + (4096*3)-1  ) 
		) axi4_interconnect_1x1 (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (core2ic.slave      ), 
		.s0                  (ic2rom.master      ),
		.s1                  (ic2ram.master		),
		.s2                  (ic2uart.master	));
	
	axi4_rom #(
		.MEM_ADDR_BITS      (12 ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32 ), 
		.AXI_ID_WIDTH       (SLAVE_ID_WIDTH), 
		.INIT_FILE          (`BOOT_ROM_FILE)
		) boot_rom (
		.ACLK               (clk            ), 
		.ARESETn            (rstn           ), 
		.s                  (ic2rom.slave   ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (12     ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (SLAVE_ID_WIDTH )
		) ram (
		.ACLK               (clk            ), 
		.ARESETn            (rstn           ), 
		.s                  (ic2ram.slave   ));

	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) br2wbic ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) wbic2uart ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) wbic2timer ();
	
	axi4_wb_bridge #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH), 
		.WB_ADDRESS_WIDTH    (32   ), 
		.WB_DATA_WIDTH       (32      )
		) ic2wb (
		.axi_clk             (clk                ), 
		.rstn                (rstn               ), 
		.axi_i               (ic2uart.slave      ), 
		.wb_o                (br2wbic.master     ));

	wb_interconnect_1x2 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   ('hf0001000  ), 
		.SLAVE0_ADDR_LIMIT  ('hf0001fff  ),
		.SLAVE1_ADDR_BASE	('hf0002000	 ),
		.SLAVE1_ADDR_LIMIT  ('hf0002fff  )
		) wbic (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (br2wbic.slave     ), 
		.s0                 (wbic2uart.master  ),
		.s1					(wbic2timer.master ));

	wire o_uart_int;
	wire o_timer_int;
	
	wb_uart #(
		.WB_DWIDTH   (32      ), 
		.WB_SWIDTH   (32      ), 
		.CLK_PERIOD  (10      ), 
//		.UART_BAUD   (230400  )
//		.UART_BAUD   (921600  )
//		.UART_BAUD   (3686400 )
		.UART_BAUD   (7372800 )
		) u_uart (
		.i_clk       (clk            ), 
		.slave       (wbic2uart.slave), 
		.o_uart_int  (o_uart_int     ), 
		.u           (u)
		);
	
	timer_module #(
		.WB_DWIDTH    (32   )
		) u_timer (
		.i_clk        (clk       		), 
		.slave        (wbic2timer.slave  ), 
		.o_timer_int  (o_timer_int 		));
	

`ifdef UNDEFINED
	reg [7:0]		data;
	reg [31:0]		bit_cnt = 'h19;
	reg [31:0]		bit_cnt2;
	reg [3:0]		bit_cnt3;
	reg	[3:0]		bit_state;

	always @(posedge brdclk) begin
		if (rstn == 0) begin
//			bit_cnt <= 0;
			data <= 0;
			bit_state <= 0;
		end else begin
			case (bit_state)
				0: begin
//					bit_cnt <= 0;
					if (u.txd == 0) begin
						bit_cnt2 <= 0;
						bit_state <= 1;
					end 
				end
				
				1: begin
					if (bit_cnt2 >= bit_cnt) begin
						bit_cnt2 <= 0;
						bit_cnt3 <= 0;
						bit_state <= 2;
					end else begin
						bit_cnt2 <= bit_cnt2 + 1;
					end
				end
				
				2: begin
					if (bit_cnt2 >= bit_cnt[31:1]) begin
						data <= {u.txd, data[7:1]};
						bit_state <= 3;
					end else begin
						bit_cnt2 <= bit_cnt2 + 1;
					end
				end
				
				3: begin
					if (bit_cnt2 >= bit_cnt) begin
						if (bit_cnt3 == 7) begin
							bit_state <= 4;
						end else begin
							bit_state <= 2;
							bit_cnt2 <= 0;
							bit_cnt3 <= bit_cnt3 + 1;
						end
					end else begin
						bit_cnt2 <= bit_cnt2 + 1;
					end
				end
				
				4: begin
					if (u.txd == 1) begin
						bit_state <= 0;
					end
				end
			endcase
		end
	end	
`endif	

endmodule

