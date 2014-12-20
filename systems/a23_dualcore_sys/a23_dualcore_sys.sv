/****************************************************************************
 * a23_dualcore_sys.sv
 ***************************************************************************/
 
module dummy_slave(axi4_if.slave slave);
endmodule

// `define SMALL
// `define MICRO

/**
 * Module: a23_dualcore_sys
 * 
 * TODO: Add module documentation
 */
module a23_dualcore_sys #(
		parameter int CLK_PERIOD = 10,
		parameter int UART_BAUD = 7372800
		) (
		input			clk_i,
		input			sw1,
		input			sw2,
		input			sw3,
		input			sw4,
		output			led0,
		output			led1,
		output			led2,
		output			led3,
		uart_if.dte		uart_dte
		);

//	reg[31:0]			clk_cnt = 0;
	reg[1:0]			clk_cnt = 0;
	reg[31:0]			cnt = 0;
	reg[3:0]			state = 0;
	reg[31:0]			scratch = 0;
	reg					rst_n = 0;
	reg					rst_req = 0;
	wire				rst_n_1;
	wire				irq;
	wire				firq;
//	reg[31:0]			idle = 20000000;
	/*
	reg[31:0]			idle   = 200000;
	reg[31:0]			active = 20000000;
	 */
`ifdef FPGA
	reg[31:0]			idle = 200;
//	reg[31:0]			active = 20000000;
	reg[31:0]			active = 0;
`else
	reg[31:0]			idle = 200;
//	reg[31:0]			active = 100000;
	reg[31:0]			active = 0;
`endif
	 
	
//	assign core_clk = clk_cnt[4];

`ifdef FPGA	
	localparam INIT_FILE = "rom.hex";
`else	
	localparam INIT_FILE = "";
`endif
	
	localparam WB_PERIPH_ADDR_BASE  = 'hF000_0000;
	localparam WB_PERIPH_ADDR_LIMIT = 'hF000_FFFF;
	
	localparam WB_TIMER_ADDR_BASE        = (WB_PERIPH_ADDR_BASE + 0*'h1000);
	localparam WB_TIMER_ADDR_LIMIT       = (WB_PERIPH_ADDR_BASE + (1*'h1000)-1);
	localparam WB_INTC_ADDR_BASE         = (WB_PERIPH_ADDR_BASE + 1*'h1000);
	localparam WB_INTC_ADDR_LIMIT        = (WB_PERIPH_ADDR_BASE + (2*'h1000)-1);
	localparam WB_UART_ADDR_BASE         = (WB_PERIPH_ADDR_BASE + 2*'h1000);
	localparam WB_UART_ADDR_LIMIT        = (WB_PERIPH_ADDR_BASE + (3*'h1000)-1);
	localparam AXI_COREINFO_ADDR_BASE    = ('hF100_0000 + 0*'h1000);
	localparam AXI_COREINFO_ADDR_LIMIT   = ('hF100_0000 + (1*'h1000)-1);
	localparam AXI_MSGQUEUE_0_BASE       = ('hF100_0000 + 1*'h1000);
	localparam AXI_MSGQUEUE_0_LIMIT      = ('hF100_0000 + (3*'h1000)-1);
	localparam AXI_MSGQUEUE_1_BASE       = ('hF100_0000 + 3*'h1000);
	localparam AXI_MSGQUEUE_1_LIMIT      = ('hF100_0000 + (5*'h1000)-1);

	localparam IC_SLAVE_ID_WIDTH = 5;

	wire	core_clk;
	reg		core_clk_r = 0;
	
//	assign core_clk = core_clk_r;
	assign core_clk = clk_i;
	
	
	always @(posedge clk_i) begin
		clk_cnt <= clk_cnt + 1;

		/*
		case (clk_cnt)
			0, 1: core_clk_r <= 0;
			2, 3: core_clk_r <= 1;
		endcase
		 */
		case (clk_cnt[0])
			0: core_clk_r <= 0;
			1: core_clk_r <= 1;
		endcase
	end

	always @(posedge core_clk) begin
		case (state) 
			0: begin
				// reset
				rst_n <= 0;
				if (cnt == idle) begin
					cnt <= 0;
					state <= 1;
				end else begin
					cnt <= cnt + 1;
				end
			end
		
			// Active
			1: begin
				rst_n <= 1;
				if (rst_req == 1) begin
					cnt <= 0;
					state <= 0;
				end else if (active != 0 && cnt == active) begin
					cnt <= 0;
					state <= 0;
				end else begin
					cnt <= cnt + 1;
				end
			end
		endcase
	end
	
//	assign rst_n = (state != 0);

	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) core2ic ();
	
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) core2ic_monitor(
			.clk(core_clk),
			.rst_n(rst_n),
			.monitor(core2ic.monitor)
		);
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2rom () /* synthesis keep */;

	/*
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) ic2rom_monitor(
			.clk(core_clk),
			.rst_n(rst_n),
			.monitor(ic2rom.monitor)
		);
		 */

	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2ram () /* synthesis keep */;
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2gbl ();

	/*
		 */
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) ic2ram_monitor(
			.clk(core_clk),
			.rst_n(rst_n),
			.monitor(ic2ram.monitor)
		);

	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2wb();
		
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2sys ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2coreinfo ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (5      )
		) ic2msgq_0_bridge ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (5      )
		) ic2msgq_1_bridge ();

	axi4_a23_dual #(
		.AXI4_ID_WIDTH(4)
		) u_core (
		.i_clk     (core_clk    ), 
		.i_rstn    (rst_n   ), 
		.i_rstn_1  (rst_n_1 ), 
		.i_irq_0   (irq  ), 
		.i_firq_0  (firq ), 
		.i_irq_1   (irq  ), 
		.i_firq_1  (firq ), 
		.master    (core2ic.master   ));

	axi4_interconnect_1x8 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE0_ADDR_BASE    ('h0000_0000  ), // ROM
		.SLAVE0_ADDR_LIMIT   ('h000F_FFFF  ),
		.SLAVE1_ADDR_BASE    ('h2000_0000  ), // RAM
		.SLAVE1_ADDR_LIMIT   ('h200F_FFFF  ),
		.SLAVE2_ADDR_BASE    ('h8000_0000  ),
		.SLAVE2_ADDR_LIMIT   ('h8FFF_FFFF  ),
		.SLAVE3_ADDR_BASE    (WB_PERIPH_ADDR_BASE ),
		.SLAVE3_ADDR_LIMIT   (WB_PERIPH_ADDR_LIMIT),
		.SLAVE4_ADDR_BASE    (AXI_COREINFO_ADDR_BASE),
		.SLAVE4_ADDR_LIMIT   (AXI_COREINFO_ADDR_LIMIT),
		.SLAVE5_ADDR_BASE    ('h3000_0000  ),
		.SLAVE5_ADDR_LIMIT   ('h3000_FFFF  ),
		.SLAVE6_ADDR_BASE    (AXI_MSGQUEUE_0_BASE),
		.SLAVE6_ADDR_LIMIT   (AXI_MSGQUEUE_0_LIMIT),
		.SLAVE7_ADDR_BASE    (AXI_MSGQUEUE_1_BASE),
		.SLAVE7_ADDR_LIMIT   (AXI_MSGQUEUE_1_LIMIT)
//		.SLAVE8_ADDR_BASE    (HPS_BASE),
//		.SLAVE8_ADDR_LIMIT   (HPS_LIMIT)
		) u_ic1 (
		.clk                 (core_clk           ), 
		.rstn                (rst_n              ), 
		.m0                  (core2ic.slave     ), 
		.s0                  (ic2rom.master      ),
		.s1                  (ic2ram.master      ),
		.s2                  (ic2sys.master      ),
		.s3                  (ic2wb.master       ),
		.s4                  (ic2coreinfo.master ),
		.s5                  (ic2gbl.master      ),
		.s6                  (ic2msgq_0_bridge.master),
		.s7                  (ic2msgq_1_bridge.master)
		);
	
	axi4_rom #(
		.MEM_ADDR_BITS      ((16-2) ), 
		.AXI_ADDRESS_WIDTH  (32     ), 
		.AXI_DATA_WIDTH     (32     ), 
		.AXI_ID_WIDTH       (5      ), 
		.INIT_FILE          (INIT_FILE         )
		) u_rom (
		.ACLK               (core_clk          ), 
		.ARESETn            (rst_n             ), 
		.s                  (ic2rom.slave      ));

	axi4_sram #(
		.MEM_ADDR_BITS      ((16-2) ),
		.AXI_ADDRESS_WIDTH  (32     ),
		.AXI_DATA_WIDTH     (32     ),
		.AXI_ID_WIDTH       (5      )
		) u_ram (
		.ACLK               (core_clk        ), 
		.ARESETn            (rst_n           ), 
		.s                  (ic2ram.slave    ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (12     ),
		.AXI_ADDRESS_WIDTH  (32     ),
		.AXI_DATA_WIDTH     (32     ),
		.AXI_ID_WIDTH       (5      )
		) u_gbl (
		.ACLK               (core_clk        ), 
		.ARESETn            (rst_n           ), 
		.s                  (ic2gbl.slave    ));
	
	coreinfo_2 #(
			.AXI_ID_WIDTH(IC_SLAVE_ID_WIDTH),
			.CORE0_AXI_ID(0),
			.CORE0_ID(0),
			.CORE1_AXI_ID(8),
			.CORE1_ID(1)
			) u_coreinfo(
				.clk_i(core_clk),
				.rst_n(rst_n),
				.s(ic2coreinfo.slave),
				.rst_n_1(rst_n_1)
			);

	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (12 ), 
		.NUM_DATA_BITS  (32 )
		) bridge2msgq_0 (
		);
	
	axi4_generic_line_en_sram_bridge #(
		.MEM_ADDR_BITS      (12      ), 
		.AXI_ADDRESS_WIDTH  (32     ), 
		.AXI_DATA_WIDTH     (32     ), 
		.AXI_ID_WIDTH       (5      ),
		.MEM_ADDR_OFFSET    ('h400  )
		) axi4_bridge2msgqueue0 (
		.clk                (core_clk                 ),
		.rst_n              (rst_n                    ),
		.axi_if             (ic2msgq_0_bridge.slave   ),
		.sram_if            (bridge2msgq_0.sram_client));
	
	bidi_message_queue_if queue_0_if ();
	bidi_message_queue_if queue_1_if ();
	
//	assign queue_0_if.msg_q_client.inbound_data = 0;
//	assign queue_0_if.msg_q_client.inbound_valid = 0;
//	assign queue_0_if.msg_q_client.outbound_ready = 0;
//	
//	assign queue_1_if.msg_q_client.inbound_data = 0;
//	assign queue_1_if.msg_q_client.inbound_valid = 0;
//	assign queue_1_if.msg_q_client.outbound_ready = 0;

	assign queue_0_if.inbound_data = 0;
	assign queue_0_if.inbound_valid = 0;
	assign queue_0_if.outbound_ready = 0;
	
	assign queue_1_if.inbound_data = 0;
	assign queue_1_if.inbound_valid = 0;
	assign queue_1_if.outbound_ready = 0;
	
	wire irq_queue_0;
	
	bidi_message_queue #(
		.QUEUE_ADDR_BITS  (8)
		) u_msg_queue_0	 (
		.clk              (core_clk          ), 
		.rst_n            (rst_n             ), 
		.mem_if           (bridge2msgq_0.sram), 
		.queue_if         (queue_0_if.msg_q  ), 
		.irq              (irq_queue_0       ));
	
	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (10 ), 
		.NUM_DATA_BITS  (32 )
		) bridge2msgq_1 (
		);
	
	axi4_generic_line_en_sram_bridge #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (32     ), 
		.AXI_DATA_WIDTH     (32     ), 
		.AXI_ID_WIDTH       (5      )
		) axi4_bridge2msgqueue1 (
		.clk                (core_clk                 ),
		.rst_n              (rst_n                    ),
		.axi_if             (ic2msgq_1_bridge.slave   ),
		.sram_if            (bridge2msgq_1.sram_client));

	wire irq_queue_1;
	
	bidi_message_queue #(
		.QUEUE_ADDR_BITS  (8)
		) u_msg_queue_1	 (
		.clk              (core_clk          ), 
		.rst_n            (rst_n             ), 
		.mem_if           (bridge2msgq_1.sram), 
		.queue_if         (queue_1_if.msg_q  ), 
		.irq              (irq_queue_1       ));


	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) axi4wb2wbic ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) wbic2timer();

	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) wbic2intc();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) wbic2uart();

	axi4_wb_bridge #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (5      ), 
		.WB_ADDRESS_WIDTH    (32   ), 
		.WB_DATA_WIDTH       (32      )
		) u_axi4wb (
		.axi_clk             (core_clk           ), 
		.rstn                (rst_n              ), 
		.axi_i               (ic2wb.slave        ), 
		.wb_o                (axi4wb2wbic.master ));	


	wb_interconnect_1x3 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   (WB_TIMER_ADDR_BASE		), 
		.SLAVE0_ADDR_LIMIT  (WB_TIMER_ADDR_LIMIT	),
		.SLAVE1_ADDR_BASE	(WB_INTC_ADDR_BASE		),
		.SLAVE1_ADDR_LIMIT	(WB_INTC_ADDR_LIMIT		),
		.SLAVE2_ADDR_BASE	(WB_UART_ADDR_BASE		),
		.SLAVE2_ADDR_LIMIT	(WB_UART_ADDR_LIMIT		)
		) u_wbic (
		.clk                (core_clk          ), 
		.rstn               (rst_n             ), 
		.m0                 (axi4wb2wbic.slave ), 
		.s0                 (wbic2timer.master ),
		.s1					(wbic2intc.master  ),
		.s2					(wbic2uart.master  ));
	
	wire[2:0]			o_timer_int;
	wire[15:0]			i_interrupts;
	
//	assign irq = o_timer_int[0];

	assign i_interrupts[2:0] = o_timer_int;
	assign i_interrupts[15:3] = 0;

	timer_module #(
		.WB_DWIDTH    (32   )
		) u_timer (
		.i_clk        (core_clk         ), 
		.i_rstn       (rst_n			),
		.slave        (wbic2timer.slave ), 
		.o_timer_int  (o_timer_int      ));

	interrupt_controller u_itc (
		.i_clk         (core_clk          ), 
		.i_rstn        (rst_n             ),
		.slave         (wbic2intc.slave   ), 
		.o_irq         (irq               ), 
		.o_firq        (firq              ), 
		.i_interrupts  (i_interrupts      ));

	wire uart_irq;

	wb_uart #(
		.WB_DWIDTH   (32	  	   ), 
		.CLK_PERIOD  (2*CLK_PERIOD ), 
		.UART_BAUD   (UART_BAUD    )
		) u_uart (
		.i_clk       (core_clk      	),
		.slave       (wbic2uart.slave	), 
		.o_uart_int  (uart_irq 			), 
		.u           (uart_dte			));
	
	// read handling
	reg[3:0]		read_state;
	reg[31:0]		read_addr = 0;
	reg[31:0]		read_data;
	assign ic2sys.ARREADY = (read_state == 0);
	assign ic2sys.RVALID = (read_state == 1);
	assign ic2sys.RDATA = read_data;
	assign ic2sys.RRESP = 0;
	assign ic2sys.RLAST = 1;
	always @(posedge core_clk) begin
		if (rst_n == 0) begin
			read_state <= 0;
			read_addr <= 0;
		end else begin
			case (read_state)
				0: begin
					if (ic2sys.ARVALID == 1) begin
						read_addr <= ic2sys.ARADDR;
						read_state <= 1;
					end
				end
				
				1: begin
					if (ic2sys.RREADY == 1) begin
						read_state <= 0;
					end
				end
				
				default: begin
					read_state <= 0;
				end
			endcase
		end
	end

	reg[3:0]			write_state;
	reg[31:0]			write_addr;
	reg[31:0]			write_data = 0;
	reg[4:0]			write_id;
	reg[3:0]			led_r;
	
	always @(posedge core_clk) begin
		led_r <= read_addr[5:2];
	end

	/*
	assign led0 = led_r[0];
	assign led1 = led_r[1];
	assign led2 = led_r[2];
	assign led3 = led_r[3];
	 */
	
	/*
	assign led0 = read_addr[3];
	assign led1 = read_addr[2];
	assign led2 = read_addr[1];
	assign led3 = read_addr[0];
	 */
	/*
	assign led0 = ic2rom.ARADDR[5];
	assign led1 = ic2rom.ARADDR[4];
	assign led2 = ic2rom.ARADDR[3];
	assign led3 = ic2rom.ARADDR[2];
	 */
	/*
	assign led0 = write_data[3];
	assign led1 = write_data[2];
	assign led2 = write_data[1];
	assign led3 = write_data[0];
	 */
//	assign led0 = write_data[19];
//	assign led1 = write_data[18];
//	assign led2 = write_data[17];
//	assign led3 = write_data[16];
`ifdef FPGA
	assign led0 = write_data[7];
	assign led1 = write_data[6];
	assign led2 = write_data[5];
	assign led3 = write_data[4];
`else
	assign led0 = write_data[3];
	assign led1 = write_data[2];
	assign led2 = write_data[1];
	assign led3 = write_data[0];
`endif

	/*
	assign led0 = clk_cnt[16];
	assign led1 = clk_cnt[15];
	assign led2 = clk_cnt[14];
	assign led3 = clk_cnt[13];
	 */
	
	assign ic2sys.AWREADY = (write_state == 0);
	assign ic2sys.WREADY = (write_state == 1);
	assign ic2sys.BVALID = (write_state == 2);
	assign ic2sys.BID = write_id;
	always @(posedge core_clk) begin
		if (rst_n == 0) begin
			write_state <= 0;
			write_data <= 0;
			rst_req <= 0;
		end else begin
			case (write_state)
				0: begin
					if (ic2sys.AWVALID == 1) begin
						write_addr <= ic2sys.AWADDR;
						write_id <= ic2sys.AWID;
						write_state <= 1;
					end
				end

				1: begin
					// 
					if (ic2sys.WVALID == 1) begin
						if (write_addr[3:2] == 0) begin // 0: LED
							write_data <= ic2sys.WDATA;
						end else if (write_addr[3:2] == 1) begin // 4: ACTIVE
							active <= ic2sys.WDATA;
						end else if (write_addr[3:2] == 2) begin // 8: IDLE
							idle <= ic2sys.WDATA;
						end else if (write_addr[3:2] == 3) begin // C: RESET
							rst_req <= 1;
						end
							
						write_state <= 2;
					end
				end
				
				2: begin
					if (ic2sys.BREADY == 1) begin
						write_state <= 0;
					end
				end
				
				default: begin
					write_state <= 0;
				end
			endcase
		end
	end

endmodule

