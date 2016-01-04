
module vga_enh_top_w(
		input			clk,
		input			rstn,
		wb_if.slave		slave,
		wb_if.master	master,
		output			wb_inta_o,
		input			clk_p_i,
		`ifdef VGA_12BIT_DVI
		dvi_pclk_p_o, dvi_pclk_m_o, dvi_hsync_o, dvi_vsync_o, dvi_de_o, dvi_d_o,
		`endif
		vga_if.framebuf	framebuf
		);
	
	wire wbs_rty_o;
	
	vga_enh_top u_vga (
		.wb_clk_i     (clk				), 
		.wb_rst_i     (!rstn			), 
		.rst_i        (!rstn			), 
		.wb_inta_o    (wb_inta_o		), 
		.wbs_adr_i    (slave.ADR   		), 
		.wbs_dat_i    (slave.DAT_W		), 
		.wbs_dat_o    (slave.DAT_R		), 
		.wbs_sel_i    (slave.SEL		), 
		.wbs_we_i     (slave.WE			), 
		.wbs_stb_i    (slave.STB		), 
		.wbs_cyc_i    (slave.CYC		), 
		.wbs_ack_o    (slave.ACK		), 
		.wbs_rty_o    (wbs_rty_o		), 
		.wbs_err_o    (slave.ERR		), 
		.wbm_adr_o    (master.ADR		), 
		.wbm_dat_i    (master.DAT_R		), 
		.wbm_cti_o    (master.CTI		), 
		.wbm_bte_o    (master.BTE		), 
		.wbm_sel_o    (master.SEL		), 
		.wbm_we_o     (master.WE		), 
		.wbm_stb_o    (master.STB		), 
		.wbm_cyc_o    (master.CYC		), 
		.wbm_ack_i    (master.ACK		), 
		.wbm_err_i    (master.ERR		), 
		.clk_p_i      (clk_p_i     ), 
		.clk_p_o      (framebuf.clk_p	), 
		.hsync_pad_o  (framebuf.hsync	), 
		.vsync_pad_o  (framebuf.vsync	), 
		.csync_pad_o  (framebuf.csync	), 
		.blank_pad_o  (framebuf.blank	), 
		.r_pad_o      (framebuf.r		), 
		.g_pad_o      (framebuf.g		), 
		.b_pad_o      (framebuf.b		));
	
	
endmodule
