/****************************************************************************
 * a23_dualcore_sys.sv
 ****************************************************************************/
 
module dummy_slave(axi4_if.slave slave);
endmodule

// `define SMALL
// `define MICRO

/**
 * Module: a23_dualcore_sys
 * 
 * TODO: Add module documentation
 */
module a23_dualcore_sys(
		input		clk_i,
		input		sw1,
		input		sw2,
		input		sw3,
		input		sw4,
		output		led0,
		output		led1,
		output		led2,
		output		led3
		);

//	reg[31:0]			clk_cnt = 0;
	reg[1:0]			clk_cnt = 0;
	reg[31:0]			cnt = 0;
	reg[3:0]			state = 0;
	reg					rst_n;
	wire				irq;
	wire				firq;
//	reg[31:0]			idle = 20000000;
	/*
	reg[31:0]			idle   = 200000;
	reg[31:0]			active = 20000000;
	 */
`ifdef FPGA
	reg[31:0]			idle = 20000;
	reg[31:0]			active = 2000000;
`else
	reg[31:0]			idle = 200;
//	reg[31:0]			active = 100000;
	reg[31:0]			active = 0;
`endif
	/*
	 */
	
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
	localparam AXI_COREINFO_ADDR_BASE    = ('hF100_0000 + 0*'h1000);
	localparam AXI_COREINFO_ADDR_LIMIT   = ('hF100_0000 + (1*'h1000)-1);

	localparam IC_SLAVE_ID_WIDTH = 5;

	wire	core_clk;
	reg		core_clk_r = 0;
	
	assign core_clk = core_clk_r;
//	assign core_clk = clk_i;
	
	
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
				if (active != 0 && cnt == active) begin
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
		) core02ic ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) core12ic ();
	
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) core02ic_monitor(
			.clk(core_clk),
			.rst_n(rst_n),
			.monitor(core02ic.monitor)
		);
	
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) core12ic_monitor(
			.clk(core_clk),
			.rst_n(rst_n),
			.monitor(core12ic.monitor)
		);
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2rom ();

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
		) ic2ram ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (IC_SLAVE_ID_WIDTH)
		) ic2gbl ();

	/*
	axi4_monitor #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (4  )
		) ic2ram_monitor(
			.clk(core_clk),
			.rst_n(rst_n),
			.monitor(ic2ram.monitor)
		);
		
		 */

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

	axi4_a23_core #(
		.A23_CACHE_WAYS  (4)
		) u_a23_0 (
		.i_clk           (core_clk       ),
		.i_rstn          (rst_n          ),
		.i_irq           (irq            ),
		.i_firq          (firq           ),
		.master          (core02ic.master));
	
	axi4_a23_core #(
		.A23_CACHE_WAYS  (4)
		) u_a23_1 (
		.i_clk           (core_clk       ),
		.i_rstn          (1'b0          ),
		.i_irq           (irq            ),
		.i_firq          (firq           ),
		.master          (core12ic.master));

	axi4_interconnect_2x6 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE0_ADDR_BASE    ('h0000_0000  ),
		.SLAVE0_ADDR_LIMIT   ('h0000_FFFF  ),
		.SLAVE1_ADDR_BASE    ('h2000_0000  ),
		.SLAVE1_ADDR_LIMIT   ('h2000_FFFF  ),
		.SLAVE2_ADDR_BASE    ('h8000_0000  ),
		.SLAVE2_ADDR_LIMIT   ('h8FFF_FFFF  ),
		.SLAVE3_ADDR_BASE    (WB_PERIPH_ADDR_BASE ),
		.SLAVE3_ADDR_LIMIT   (WB_PERIPH_ADDR_LIMIT),
		.SLAVE4_ADDR_BASE    (AXI_COREINFO_ADDR_BASE),
		.SLAVE4_ADDR_LIMIT   (AXI_COREINFO_ADDR_LIMIT),
		.SLAVE5_ADDR_BASE    ('h3000_0000  ),
		.SLAVE5_ADDR_LIMIT   ('h3000_FFFF  )
		) u_ic1 (
		.clk                 (core_clk           ), 
		.rstn                (rst_n              ), 
		.m0                  (core02ic.slave     ), 
		.m1                  (core12ic.slave     ), 
		.s0                  (ic2rom.master      ),
		.s1                  (ic2ram.master      ),
		.s2                  (ic2sys.master      ),
		.s3                  (ic2wb.master       ),
		.s4                  (ic2coreinfo.master ),
		.s5                  (ic2gbl.master      ));
	
	axi4_rom #(
		.MEM_ADDR_BITS      (12     ), 
		.AXI_ADDRESS_WIDTH  (32     ), 
		.AXI_DATA_WIDTH     (32     ), 
		.AXI_ID_WIDTH       (5      ), 
		.INIT_FILE          (INIT_FILE         )
		) u_rom (
		.ACLK               (core_clk          ), 
		.ARESETn            (rst_n             ), 
		.s                  (ic2rom.slave      ));

	axi4_sram #(
		.MEM_ADDR_BITS      (12     ),
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
			.CORE1_AXI_ID(1),
			.CORE1_ID(1)
			) u_coreinfo(
				.clk_i(core_clk),
				.rst_n(rst_n),
				.s(ic2coreinfo.slave)
			);

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


	wb_interconnect_1x2 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   (WB_TIMER_ADDR_BASE		), 
		.SLAVE0_ADDR_LIMIT  (WB_TIMER_ADDR_LIMIT	),
		.SLAVE1_ADDR_BASE	(WB_INTC_ADDR_BASE		),
		.SLAVE1_ADDR_LIMIT	(WB_INTC_ADDR_LIMIT		)
		) u_wbic (
		.clk                (core_clk          ), 
		.rstn               (rst_n             ), 
		.m0                 (axi4wb2wbic.slave ), 
		.s0                 (wbic2timer.master ),
		.s1					(wbic2intc.master  ));
	
	wire[2:0]			o_timer_int;
	wire[15:0]			i_interrupts;
	
//	assign irq = o_timer_int[0];

	assign i_interrupts[2:0] = o_timer_int;
	assign i_interrupts[15:3] = 0;

	timer_module #(
		.WB_DWIDTH    (32   )
		) u_timer (
		.i_clk        (core_clk         ), 
		.slave        (wbic2timer.slave ), 
		.o_timer_int  (o_timer_int      ));

	interrupt_controller u_itc (
		.i_clk         (core_clk          ), 
		.slave         (wbic2intc.slave   ), 
		.o_irq         (irq               ), 
		.o_firq        (firq              ), 
		.i_interrupts  (i_interrupts      ));
	
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
	assign led0 = write_data[3];
	assign led1 = write_data[2];
	assign led2 = write_data[1];
	assign led3 = write_data[0];
	/*
	 */

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
						write_data <= ic2sys.WDATA;
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

