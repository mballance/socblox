/****************************************************************************
 * altor32_w.sv
 ****************************************************************************/

/**
 * Module: altor32_w
 * 
 * TODO: Add module documentation
 */
module altor32_w #(
		parameter BOOT_VECTOR 			= 32'h1000_0000,
		parameter ISR_VECTOR 			= 32'h1000_0000,
		parameter REGISTER_FILE_TYPE 	= "SIMULATION",
		parameter ENABLE_ICACHE			= "ENABLED",
		parameter ENABLE_DCACHE			= "ENABLED",
//		parameter ENABLE_ICACHE			= "DISABLED",
//		parameter ENABLE_DCACHE			= "DISABLED",
		parameter SUPPORT_32REGS		= "ENABLED",
		parameter PIPELINED_FETCH		= "ENABLED"
		) (
		input				clk,
		input				rstn,
		input				intr_i,
		input				nmi_i,
		wb_if.master		imem,
		wb_if.master		dmem
		);
	
	wire fault_o;
	wire break_o;
	
	assign imem.WE = 1'b0;
	assign imem.DAT_W = 'b0;
	
	wire i_stall;
	assign i_stall = (imem.CYC & imem.STB && !imem.ACK);
	wire d_stall;
	assign d_stall = (dmem.CYC & dmem.STB && !dmem.ACK);
	
	cpu #(
			.BOOT_VECTOR(BOOT_VECTOR),
			.ISR_VECTOR(ISR_VECTOR),
			.REGISTER_FILE_TYPE(REGISTER_FILE_TYPE),
			.ENABLE_ICACHE(ENABLE_ICACHE),
			.ENABLE_DCACHE(ENABLE_DCACHE),
			.SUPPORT_32REGS(SUPPORT_32REGS),
			.PIPELINED_FETCH(PIPELINED_FETCH)
		) u_cpu (
		.clk_i         (clk			), 
		.rst_i         (~rstn        ), 
		.intr_i        (intr_i       ), 
		.nmi_i         (nmi_i        ), 
		.fault_o       (fault_o      ), 
		.break_o       (break_o      ), 
		.imem_addr_o   (imem.ADR  ), 
		.imem_dat_i    (imem.DAT_R   ), 
		.imem_cti_o    (imem.CTI   ), 
		.imem_cyc_o    (imem.CYC   ), 
		.imem_stb_o    (imem.STB   ), 
		.imem_stall_i  (i_stall		), 
		.imem_ack_i    (imem.ACK   ), 
		
		.dmem_addr_o   (dmem.ADR  ), 
		.dmem_dat_o    (dmem.DAT_W   ), 
		.dmem_dat_i    (dmem.DAT_R   ), 
		.dmem_sel_o    (dmem.SEL   ), 
		.dmem_cti_o    (dmem.CTI   ), 
		.dmem_cyc_o    (dmem.CYC   ), 
		.dmem_we_o     (dmem.WE    ), 
		.dmem_stb_o    (dmem.STB   ), 
		.dmem_stall_i  (d_stall		), 
		.dmem_ack_i    (dmem.ACK   ));


endmodule


