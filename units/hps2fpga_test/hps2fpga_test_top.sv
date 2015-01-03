/****************************************************************************
 * hps2fpga_test_top.sv
 ****************************************************************************/
`include "axi4_if_macros.svh"
/**
 * Module: hps2fpga_test_top
 * 
 * TODO: Add module documentation
 */
module hps2fpga_test_top(
		input		clk_i,
		input		memory_oct_rzqin,
		output		led3,
		output		led2,
		output		led1,
		output		led0
		);
	reg [3:0]       cnt = 0;
	reg             rst_n = 0;
	reg [31:0]		led = 0;
	
	assign led0 = led[0];
	assign led1 = led[1];
	assign led2 = led[2];
	assign led3 = led[3];
	
	always @(posedge clk_i) begin
		if (cnt == 'hf) begin
			rst_n <= 1;
		end else begin
			cnt <= cnt + 1;
		end
	end

	axi4_if #(
			.AXI4_ADDRESS_WIDTH(30),
			.AXI4_DATA_WIDTH(21),
			.AXI4_ID_WIDTH(12)
		) u_axi_if();
	
	wire reset_reset_n = 1;
//	wire memory_oct_rzqin = 0;
	wire hps_0_h2f_mpu_events_eventi = 0;
	wire [31:0] hps_0_f2h_irq0_irq = 0;
	wire [31:0] hps_0_f2h_irq1_irq = 0;
	
	hps_master u_hps (
		.clk_clk(clk_i),
		.reset_reset_n(reset_reset_n),
//		output wire [12:0] memory_mem_a,                    //               memory.mem_a
//		output wire [2:0]  memory_mem_ba,                   //                     .mem_ba
//		output wire        memory_mem_ck,                   //                     .mem_ck
//		output wire        memory_mem_ck_n,                 //                     .mem_ck_n
//		output wire        memory_mem_cke,                  //                     .mem_cke
//		output wire        memory_mem_cs_n,                 //                     .mem_cs_n
//		output wire        memory_mem_ras_n,                //                     .mem_ras_n
//		output wire        memory_mem_cas_n,                //                     .mem_cas_n
//		output wire        memory_mem_we_n,                 //                     .mem_we_n
//		output wire        memory_mem_reset_n,              //                     .mem_reset_n
//		inout  wire [7:0]  memory_mem_dq,                   //                     .mem_dq
//		inout  wire        memory_mem_dqs,                  //                     .mem_dqs
//		inout  wire        memory_mem_dqs_n,                //                     .mem_dqs_n
//		output wire        memory_mem_odt,                  //                     .mem_odt
//		output wire        memory_mem_dm,                   //                     .mem_dm
		.memory_oct_rzqin(memory_oct_rzqin),                //                     .oct_rzqin
		.hps_0_h2f_mpu_events_eventi(hps_0_h2f_mpu_events_eventi),     // hps_0_h2f_mpu_events.eventi
//		output wire        hps_0_h2f_mpu_events_evento,     //                     .evento
//		output wire [1:0]  hps_0_h2f_mpu_events_standbywfe, //                     .standbywfe
//		output wire [1:0]  hps_0_h2f_mpu_events_standbywfi, //                     .standbywfi
		`AXI4_IF_PORTMAP_LOWER_NO_REGION_QOS(hps_0_h2f_lw_axi_master, u_axi_if),
		.hps_0_f2h_irq0_irq(hps_0_f2h_irq0_irq),              //       hps_0_f2h_irq0.irq
		.hps_0_f2h_irq1_irq(hps_0_f2h_irq1_irq)               //       hps_0_f2h_irq1.irq
	);

	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (21 ), 
		.NUM_DATA_BITS  (32 )
		) u_sram_if (
		);
	
	axi4_generic_line_en_sram_bridge #(
		.MEM_ADDR_BITS      (21     ), 
		.AXI_ADDRESS_WIDTH  (21 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (12      ), 
		.MEM_ADDR_OFFSET    (0   )
		) u_sram_bridge (
		.clk                (clk_i                     ), 
		.rst_n              (rst_n                     ), 
		.axi_if             (u_axi_if.slave            ), 
		.sram_if            (u_sram_if.sram_client     ));

	always @(posedge clk_i) begin
		if (u_sram_if.write_en) begin
			led <= u_sram_if.write_data;
		end
	end
	
	assign u_sram_if.read_data = 0;
	

endmodule

