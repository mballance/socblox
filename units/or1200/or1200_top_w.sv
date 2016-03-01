/****************************************************************************
 * or1200_top_w.sv
 ****************************************************************************/

/**
 * Module: or1200_top_w
 * 
 * TODO: Add module documentation
 */
`include "or1200_defines.v"

module or1200_top_w(
		input							clk_i,
		input							rstn_i,
		input[`OR1200_PIC_INTS-1:0]		pic_ints_i,
		input[1:0]						clk_mode_i,
		wb_if.master					iwb,
		input							iwb_clk_i,
		wb_if.master					dwb,
		intput							dwb_clk_i
		);

wire			pm_cpustall_i = 0;
wire	[3:0]		pm_clksd_o;
wire			pm_dc_gate_o;
wire			pm_ic_gate_o;
wire			pm_dmmu_gate_o;
wire			pm_immu_gate_o;
wire			pm_tt_gate_o;
wire			pm_cpu_gate_o;
wire			pm_wakeup_o;
wire			pm_lvolt_o;

wire			dbg_stall_i = 0;	// External Stall wire
wire			dbg_ewt_i = 0;	// External Watchpoint Trigger wire
wire	[3:0]		dbg_lss_o;	// External Load/Store Unit Status
wire	[1:0]		dbg_is_o;	// External Insn Fetch Status
wire	[10:0]		dbg_wp_o;	// Watchpoints wires
wire			dbg_bp_o;	// Breakpoint wire
wire			dbg_stb_i = 0;      // External Address/Data Strobe
wire			dbg_we_i = 0;       // External Write Enable
wire	[aw-1:0]	dbg_adr_i = 0;	// External Address wire
wire	[dw-1:0]	dbg_dat_i = 0;	// External Data wire
wire	[dw-1:0]	dbg_dat_o;	// External Data wire
wire			dbg_ack_o;	// External Data Acknowledge (not WB compatible)


	or1200_top u_core (
		.clk_i           (clk_i          ), 
		.rst_i           (!rst_i         ), 
		.pic_ints_i      (pic_ints_i     ), 
		.clmode_i        (clmode_i       ), 
		.iwb_clk_i       (iwb_clk_i        ), 
		.iwb_rst_i       (!rst_i         ), 
		.iwb_ack_i       (iwb.ACK      ), 
		.iwb_err_i       (iwb.ERR      ), 
		.iwb_rty_i       (iwb_rty_i      ),  //
		.iwb_dat_i       (iwb.DAT_R      ), 
		.iwb_cyc_o       (iwb.CYC      ), 
		.iwb_adr_o       (iwb.ADR      ), 
		.iwb_stb_o       (iwb.STB      ), 
		.iwb_we_o        (iwb.WE       ), 
		.iwb_sel_o       (iwb.SEL      ), 
		.iwb_dat_o       (iwb.DAT_W      ), 
		.iwb_cti_o       (iwb.CTI      ), 
		.iwb_bte_o       (iwb.BTE      ), 
		.dwb_clk_i       (dwb_clk_i      ), 
		.dwb_rst_i       (!rstn_i      ), 
		.dwb_ack_i       (dwb.ACK      ), 
		.dwb_err_i       (dwb.ERR      ), 
		.dwb_rty_i       (dwb_rty_i      ),  //
		.dwb_dat_i       (dwb.DAT_R      ), 
		.dwb_cyc_o       (dwb.CYC      ), 
		.dwb_adr_o       (dwb.ADR      ), 
		.dwb_stb_o       (dwb.STB      ), 
		.dwb_we_o        (dwb.WE       ), 
		.dwb_sel_o       (dwb.SEL      ), 
		.dwb_dat_o       (dwb.DAT_W      ), 
		.dwb_cti_o       (dwb.CTI      ), 
		.dwb_bte_o       (dwb.BTE      ), 
		.dbg_stall_i     (dbg_stall_i    ), 
		.dbg_ewt_i       (dbg_ewt_i      ), 
		.dbg_lss_o       (dbg_lss_o      ), 
		.dbg_is_o        (dbg_is_o       ), 
		.dbg_wp_o        (dbg_wp_o       ), 
		.dbg_bp_o        (dbg_bp_o       ), 
		.dbg_stb_i       (dbg_stb_i      ), 
		.dbg_we_i        (dbg_we_i       ), 
		.dbg_adr_i       (dbg_adr_i      ), 
		.dbg_dat_i       (dbg_dat_i      ), 
		.dbg_dat_o       (dbg_dat_o      ), 
		.dbg_ack_o       (dbg_ack_o      ), 
		.pm_cpustall_i   (pm_cpustall_i  ), 
		.pm_clksd_o      (pm_clksd_o     ), 
		.pm_dc_gate_o    (pm_dc_gate_o   ), 
		.pm_ic_gate_o    (pm_ic_gate_o   ), 
		.pm_dmmu_gate_o  (pm_dmmu_gate_o ), 
		.pm_immu_gate_o  (pm_immu_gate_o ), 
		.pm_tt_gate_o    (pm_tt_gate_o   ), 
		.pm_cpu_gate_o   (pm_cpu_gate_o  ), 
		.pm_wakeup_o     (pm_wakeup_o    ), 
		.pm_lvolt_o      (pm_lvolt_o     ), 
		.sig_tick        (sig_tick       ));

endmodule


