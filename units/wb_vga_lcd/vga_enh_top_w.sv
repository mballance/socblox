
module vga_enh_top_w(
		input			clk,
		input			rstn,
		wb_if.slave		slave,
		wb_if.master	master,
		clk_p_i,
		`ifdef VGA_12BIT_DVI
		dvi_pclk_p_o, dvi_pclk_m_o, dvi_hsync_o, dvi_vsync_o, dvi_de_o, dvi_d_o,
		`endif
		clk_p_o, hsync_pad_o, vsync_pad_o, csync_pad_o, blank_pad_o, r_pad_o, g_pad_o, b_pad_o		
		);
	
	
endmodule
