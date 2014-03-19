/****************************************************************************
 * rtc.sv
 ****************************************************************************/

/**
 * Module: rtc
 * 
 * TODO: Add module documentation
 */
module rtc (
		// WISHBONE Interface
		input               wb_clk_i,   // Clock
		input               wb_rst_i,   // Reset
		wb_if.slave			slave,
		/*
		input               wb_cyc_i,   // cycle valid input
		input [4:0]         wb_adr_i,   // address bus inputs
		input [31:0]        wb_dat_i,   // input data bus
		input [3:0]         wb_sel_i,   // byte select inputs
		input               wb_we_i,    // indicates write transfer
		input               wb_stb_i,   // strobe input
		output logic [31:0] wb_dat_o,   // output data bus
		output logic        wb_ack_o,   // normal termination
		output logic        wb_err_o,   // termination error
		 */
		// Internal Interface
		output logic        rtc_int_o,
		// External xtal Inout
		input               xtal,       // xtal input
		output logic        extal       // xtal output
		);
	
	wire 			wb_cyc_i;
	wire[4:0]		wb_adr_i;
	wire[31:0]		wb_dat_i;
	wire[31:0]		wb_dat_o;
	wire[3:0]		wb_sel_i;
	wire			wb_stb_i;
	wire			wb_ack_o;
	wire			wb_err_o;
	
	assign wb_cyc_i = slave.CYC;
	assign wb_adr_i = slave.ADR;
	assign wb_dat_i = slave.DAT_W;
	assign slave.DAT_R = wb_dat_o;
	assign wb_sel_i = slave.SEL;
	assign wb_stb_i = slave.STB;
	assign slave.ACK = wb_ack_o;
	assign slave.ERR = wb_err_o;

	// Local Wires and Registers
	logic [15:0]  bcdyear;    // The BCD data of year
	logic [4:0]   bcdmon;     // The BCD data of month
	logic [5:0]   bcddate;    // The BCD data of date
	logic [3:0]   bcdday;     // The BCD data of day
	logic [5:0]   bcdhour;    // The BCD data of hour
	logic [6:0]   bcdmin;     // The BCD data of minute
	logic [6:0]   bcdsec;     // The BCD data of second

	logic [6:0]   rtc_inte;   // Interrupt Enable Register
	logic [6:0]   int_mask;   // Interrupt Mask Register
	logic [31:0]  fred_cnt;   // Frequency Division counter
	logic [31:0]  inicount;   // Initial counter value register
	logic [6:0]   rtc_con;    // RTC contrl register

	logic [15:0]  preyear;    // The predetermining data of year
	logic [4:0]   premon;     // The predetermining data of month
	logic [5:0]   predate;    // The predetermining data of date
	logic [3:0]   preday;     // The predetermining data of day
	logic [5:0]   prehour;    // The predetermining data of hour
	logic [6:0]   premin;     // The predetermining data of minute
	logic [6:0]   presec;     // The predetermining data of second

	logic         preyear_sel;
	logic         premon_sel;
	logic         predate_sel;
	logic         preday_sel;
	logic         prehour_sel;
	logic         premin_sel;
	logic         presec_sel;
	logic         mask_sel;
	logic         inte_sel;
	logic         fredcnt_sel;
	logic         count_sel;
	logic         con_sel;
	logic         year_sel;
	logic         mon_sel;
	logic         date_sel;
	logic         day_sel;
	logic         hour_sel;
	logic         min_sel;
	logic         sec_sel;

	logic         wb_ack;
	logic         wb_err;
	logic [31:0]  wb_data;
	logic         dig_clk;
	logic         clk_rtc;
	logic         fred_full;
	logic         leapyear;
	logic         sec_int;
	logic         min_int;
	logic         hour_int;
	logic         date_int;
	logic         week_int;
	logic         mon_int;
	logic         equ_int;
	logic         equsec;
	logic         equmin;
	logic         equhour;
	logic         equday;
	logic         equdate;
	logic         equmon;
	logic         equyear;
	logic         rtc_int;
	logic         rtc_int_r;


	always_comb
		wb_ack = wb_cyc_i && wb_stb_i && !wb_err_o;

	always_ff @(posedge wb_clk_i or posedge wb_rst_i)
		if (wb_rst_i) begin
			wb_ack_o <= 1'b0;
		end
		else begin
			wb_ack_o <= wb_ack && !wb_ack_o;
		end

		// Wishbone Error
	always_comb
		wb_err = wb_cyc_i && wb_stb_i && ((wb_adr_i[4:0] == 5'h19) & (wb_sel_i != 4'b0011) |
			(wb_adr_i[4:0] == 5'h18) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h17) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h16) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h15) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h14) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h13) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h12) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h11) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h0d) & (wb_sel_i != 4'b1111) |
			(wb_adr_i[4:0] == 5'h09) & (wb_sel_i != 4'b1111) |
			(wb_adr_i[4:0] == 5'h08) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h06) & (wb_sel_i != 4'b0011) |
			(wb_adr_i[4:0] == 5'h05) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h04) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h03) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h02) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h01) & (wb_sel_i != 4'b0001) |
			(wb_adr_i[4:0] == 5'h00) & (wb_sel_i != 4'b0001));

	always_ff @(posedge wb_clk_i or posedge wb_rst_i)
		if (wb_rst_i) begin
			wb_err_o <= 1'b0;
		end
		else begin
			wb_err_o <= wb_err && !wb_err_o;
		end

		// Write select logic
	always_comb
	begin
		preyear_sel = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h19) && (wb_sel_i == 4'b0011) && rtc_con[5];
		premon_sel  = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h18) && (wb_sel_i == 4'b0001) && rtc_con[5];
		predate_sel = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h17) && (wb_sel_i == 4'b0001) && rtc_con[5];
		preday_sel  = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h16) && (wb_sel_i == 4'b0001) && rtc_con[5];
		prehour_sel = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h15) && (wb_sel_i == 4'b0001) && rtc_con[5];
		premin_sel  = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h14) && (wb_sel_i == 4'b0001) && rtc_con[5];
		presec_sel  = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h13) && (wb_sel_i == 4'b0001) && rtc_con[5];
		mask_sel    = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h12) && (wb_sel_i == 4'b0001);
		inte_sel    = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h11) && (wb_sel_i == 4'b0001);
		fredcnt_sel = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h0d) && (wb_sel_i == 4'b1111);
		count_sel   = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h09) && (wb_sel_i == 4'b1111);
		con_sel     = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h08) && (wb_sel_i == 4'b0001);
		year_sel    = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h06) && (wb_sel_i == 4'b0011) && rtc_con[0];
		mon_sel     = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h05) && (wb_sel_i == 4'b0001) && rtc_con[0];
		date_sel    = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h04) && (wb_sel_i == 4'b0001) && rtc_con[0];
		day_sel     = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h03) && (wb_sel_i == 4'b0001) && rtc_con[0];
		hour_sel    = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h02) && (wb_sel_i == 4'b0001) && rtc_con[0];
		min_sel     = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h01) && (wb_sel_i == 4'b0001) && rtc_con[0];
		sec_sel     = wb_cyc_i && wb_stb_i && (wb_adr_i[4:0] == 5'h00) && (wb_sel_i == 4'b0001) && rtc_con[0];
	end

	// Write to predetermining Second Register
	always_ff @(posedge wb_clk_i)
		if (presec_sel && wb_we_i) begin
			presec <= wb_dat_i[6:0];
		end

		// Write to predetermining Minute Register
	always_ff @(posedge wb_clk_i)
		if (premin_sel && wb_we_i) begin
			premin <= wb_dat_i[6:0];
		end

		// Write to predetermining Hour Register
	always_ff @(posedge wb_clk_i)
		if (prehour_sel && wb_we_i) begin
			prehour <= wb_dat_i[5:0];
		end

		// Write to predetermining Day Register
	always_ff @(posedge wb_clk_i)
		if (preday_sel && wb_we_i) begin
			preday <= wb_dat_i[3:0];
		end

		// Write to predetermining Date Register
	always_ff @(posedge wb_clk_i)
		if (predate_sel && wb_we_i) begin
			predate <= wb_dat_i[5:0];
		end

		// Write to predetermining Month Register
	always_ff @(posedge wb_clk_i)
		if (premon_sel && wb_we_i) begin
			premon <= wb_dat_i[4:0];
		end

		// Write to predetermining Year Register
	always_ff @(posedge wb_clk_i)
		if (preyear_sel && wb_we_i) begin
			preyear <= wb_dat_i[15:0];
		end

		// Write to INT MASK Register
	always_ff @(posedge wb_clk_i)
		if (mask_sel && wb_we_i) begin
			int_mask <= wb_dat_i[6:0];
		end

		// Write to INT ENABLE Register
	always_ff @(posedge wb_clk_i)
		if (inte_sel && wb_we_i) begin
			rtc_inte <= wb_dat_i[6:0];
		end

		// Write to INICOUNT Register
	always_ff @(posedge wb_clk_i)
		if (count_sel && wb_we_i) begin
			inicount <= wb_dat_i;
		end

		// Write to CONTROL Register
	always_ff @(posedge wb_clk_i)
		if (con_sel && wb_we_i) begin
			rtc_con <= wb_dat_i[6:0];
		end

		// Mux of Reading Registers
	always_comb
		case (wb_adr_i[4:0])
			5'h00: begin
				wb_data[6:0] = bcdsec;
				wb_data[31:7] = 25'b0;
			end
			5'h01: begin
				wb_data[6:0] = bcdmin;
				wb_data[31:7] = 25'b0;
			end
			5'h02: begin
				wb_data[5:0] = bcdhour;
				wb_data[31:6] = 26'b0;
			end
			5'h03: begin
				wb_data[3:0] = bcdday;
				wb_data[31:4] = 28'b0;
			end
			5'h04: begin
				wb_data[5:0] = bcddate;
				wb_data[31:6] = 26'b0;
			end
			5'h05: begin
				wb_data[4:0] = bcdmon;
				wb_data[31:5] = 27'b0;
			end
			5'h06: begin
				wb_data[15:0] = bcdyear;
				wb_data[31:16] = 16'b0;
			end
			5'h08:begin
				wb_data[6:0] = rtc_con;
				wb_data[31:7] = 25'b0;
			end
			5'h09: begin
				wb_data = inicount;
			end
			5'h0d: begin
				wb_data = fred_cnt;
			end
			5'h11: begin
				wb_data[6:0] = rtc_inte;
				wb_data[31:7] = 25'b0;
			end
			5'h12: begin
				wb_data[6:0] = int_mask;
				wb_data[31:7] = 25'b0;
			end
			5'h13: begin
				wb_data[6:0] = presec;
				wb_data[31:7] = 25'b0;
			end
			5'h14: begin
				wb_data[6:0] = premin;
				wb_data[31:7] = 25'b0;
			end
			5'h15: begin
				wb_data[5:0] = prehour;
				wb_data[31:6] = 26'b0;
			end
			5'h16: begin
				wb_data[3:0] = preday;
				wb_data[31:4] = 28'b0;
			end
			5'h17: begin
				wb_data[5:0] = predate;
				wb_data[31:6] = 26'b0;
			end
			5'h18: begin
				wb_data[4:0] = premon;
				wb_data[31:5] = 27'b0;
			end
			5'h19: begin
				wb_data[15:0] = preyear;
				wb_data[31:16] = 16'b0;
			end
			default: begin
				wb_data = 32'b0;
			end
		endcase

		// Wishbone data output
	always_ff @(posedge wb_clk_i or posedge wb_rst_i)
		if (wb_rst_i) begin
			wb_dat_o <= 32'b0;
		end
		else begin
			wb_dat_o <= wb_data;
		end

		// Convert Analog clk to Digital clk and Frequency Division
	always_comb
	begin
		dig_clk = ~xtal;
		clk_rtc = ~dig_clk;
		extal   = clk_rtc;
	end

	// Frequency Division and Calendar Generate Logic
	// The frequency division factor is inicount,
	// Calendar includes year, month, date, hour, minute, second
	always_ff @(posedge clk_rtc or posedge wb_rst_i)
		if (wb_rst_i) begin
			bcdsec   <= 7'h0;
			bcdmin   <= 7'h0;
			bcdhour  <= 6'h0;
			bcdday   <= 4'h0;
			bcddate  <= 6'h0;
			bcdmon   <= 5'h0;
			bcdyear  <= 16'h0000;
			fred_cnt <= 32'b0;
		end
		else begin
			if (sec_sel && wb_we_i) begin
				bcdsec <= wb_dat_i[6:0];
			end

			if (min_sel && wb_we_i) begin
				bcdmin <= wb_dat_i[6:0];
			end

			if (hour_sel && wb_we_i) begin
				bcdhour <= wb_dat_i[5:0];
			end

			if (day_sel && wb_we_i) begin
				bcdday <= wb_dat_i[3:0];
			end

			if (date_sel && wb_we_i) begin
				bcddate <= wb_dat_i[5:0];
			end

			if (mon_sel && wb_we_i) begin
				bcdmon <= wb_dat_i[4:0];
			end

			if (year_sel && wb_we_i) begin
				bcdyear <= wb_dat_i[15:0];
			end

			if (fredcnt_sel && wb_we_i) begin
				fred_cnt <= wb_dat_i;
			end
			else begin
				// Frequency Division Logic
				if (fred_full) begin
					fred_cnt <= 32'b1;
					// Second Generate Logic
					if ((bcdsec[3:0] == 4'h9) && (bcdsec[6:4] == 3'h5)) begin
						bcdsec[3:0] <= 4'h0;
						bcdsec[6:4] <= 3'h0;
						// Minute Generate Logic
						if ((bcdmin[3:0] == 4'h9) && (bcdmin[6:4] == 3'h5)) begin
							bcdmin[3:0] <= 4'h0;
							bcdmin[6:4] <= 3'h0;
							// Hour Generate Logic
							if ((bcdhour[3:0] == 4'h3) && (bcdhour[5:4] == 2'h2)) begin
								bcdhour[3:0] <= 4'h0;
								bcdhour[5:4] <= 2'h0;
								// Day Generate Logic
								if (bcdday == 4'h7) begin
									bcdday <= 4'h1;
								end
								else begin
									bcdday <= bcdday + 4'h1;
								end
								// Date Generate Logic
								if (((bcddate == 6'h29) && (bcdmon == 5'h02) && leapyear) |
										((bcddate == 6'h28) && (bcdmon == 5'h02) && !leapyear) |
										((bcddate == 6'h30) &&
											((bcdmon == 5'h04) | (bcdmon == 5'h06) | (bcdmon == 5'h09) | (bcdmon == 5'h11))) |
										((bcddate == 6'h31) &&
											((bcdmon == 5'h01) | (bcdmon == 5'h03) | (bcdmon == 5'h05) | (bcdmon == 5'h07) |
												(bcdmon == 5'h08) | (bcdmon == 5'h10) | (bcdmon == 5'h12)))) begin
									bcddate[3:0] <= 4'h1;
									bcddate[5:4] <= 2'h0;
									// Month Generate Logic
									if ((bcdmon[4] == 4'h1) && (bcdmon[3:0] == 4'h2)) begin
										bcdmon[3:0] <= 4'h1;
										bcdmon[4] <= !bcdmon[4];
										// Year Generate Logic
										if (bcdyear[11:0] == 12'h999) begin
											bcdyear[11:0] <= 12'h0;
											bcdyear[15:12] <= bcdyear[15:12] + 4'h1;
										end
										else begin
											if ((bcdyear[7:4] == 4'h9) && (bcdyear[3:0] == 4'h9)) begin
												bcdyear[7:0] <= 8'h0;
												bcdyear[11:8] <= bcdyear[11:8] + 4'h1;
											end
											else begin
												if (bcdyear[3:0] == 4'h9) begin
													bcdyear[3:0] <= 4'h0;
													bcdyear[7:4] <= bcdyear[7:4] + 4'h1;
												end
												else begin
													bcdyear[3:0] <= bcdyear[3:0] + 4'h1;
												end
												// Year Generate Logic
											end
										end
									end
									else begin
										if (bcdmon[3:0] == 4'h9) begin
											bcdmon[3:0] <= 4'h0;
											bcdmon[4] <= !bcdmon[4];
										end
										else begin
											bcdmon[3:0] <= bcdmon[3:0] + 4'h1;
										end
									end
									// Month Generate Logic
								end
								else begin
									if (bcddate[3:0] == 4'h9) begin
										bcddate[3:0] <= 4'h0;
										bcddate[5:4] <= bcddate[5:4] + 2'h1;
									end
									else begin
										bcddate[3:0] <= bcddate[3:0] + 4'h1;
									end
								end
								// Date Generate Logic
							end
							else begin
								if (bcdhour[3:0] == 4'h9) begin
									bcdhour[3:0] <= 4'h0;
									bcdhour[5:4] <= bcdhour[5:4] + 2'h1;
								end
								else begin
									bcdhour[3:0] <= bcdhour[3:0] + 4'h1;
								end
							end
							// Hour Generate Logic
						end
						else begin
							if (bcdmin[3:0] == 4'h9) begin
								bcdmin[3:0] <= 4'h0;
								bcdmin[6:4] <= bcdmin[6:4] + 3'h1;
							end
							else begin
								bcdmin[3:0] <= bcdmin[3:0] + 4'h1;
							end
						end
						// Minute Generate Logic
					end
					else begin
						if (bcdsec[3:0] == 4'h9)begin
							bcdsec[3:0] <= 4'h0;
							bcdsec[6:4] <= bcdsec[6:4] + 3'h1;
						end
						else begin
							bcdsec[3:0] <= bcdsec[3:0] + 4'h1;
						end
					end
					// Second Generate Logic
				end
				else begin
					fred_cnt <= fred_cnt + 32'b1;
				end
				// Frequency Division Logic
			end
		end

	always_comb
		fred_full = rtc_con[1] ? (fred_cnt == 32'h1) : (fred_cnt == inicount);

		// Whether is leap year or not
	always_comb
		if (bcdyear[9:0] == 10'h0) begin
			leapyear = 1'b1;
		end
		else begin
			if (bcdyear[7:0] == 8'h0) begin
				leapyear = 1'b0;
			end
			else begin
				if (bcdyear[1:0] == 2'b00) begin
					leapyear = 1'b1;
				end
				else begin
					leapyear = 1'b0;
				end
			end
		end

		//  RTC Interrupt Request Generate Logic
		// Generate interrupt request per second
	always_ff @(posedge wb_clk_i)
		if (rtc_inte[0] && fred_full) begin
			sec_int <= 1'b1;
		end
		else begin
			sec_int <= 1'b0;
		end

		// Generate interrupt request per minute
	always_ff @(posedge wb_clk_i)
		if (rtc_inte[1] && bcdsec == 7'h0) begin
			min_int <= 1'b1;
		end
		else begin
			min_int <= 1'b0;
		end

		// Generate interrupt request per hour
	always_ff @(posedge wb_clk_i)
		if (rtc_inte[2] && bcdmin == 7'h0) begin
			hour_int <= 1'b1;
		end
		else begin
			hour_int <= 1'b0;
		end

		// Generate interrupt request per day
	always_ff @(posedge wb_clk_i)
		if (rtc_inte[3] && bcdhour == 6'h0) begin
			date_int <= 1'b1;
		end
		else begin
			date_int <= 1'b0;
		end

		// Generate interrupt request per week
	always_ff @(posedge wb_clk_i)
		if (rtc_inte[4] && bcdday == 4'h1) begin
			week_int <= 1'b1;
		end
		else begin
			week_int <= 1'b0;
		end

		// Generate interrupt request per month
	always_ff @(posedge wb_clk_i)
		if (rtc_inte[5] && bcddate == 6'h1) begin
			mon_int <= 1'b1;
		end
		else begin
			mon_int <= 1'b0;
		end

		// predetermine
		// Whether the year equals predetermining year
	always_ff @(posedge wb_clk_i)
		if (int_mask[6]) begin
			if (bcdyear == preyear) begin
				equyear <= 1'b1;
			end
			else begin
				equyear <= 1'b0;
			end
		end
		else begin
			equyear <= 1'b1;
		end

		// Whether the month equals predetermining month
	always_ff @(posedge wb_clk_i)
		if (int_mask[5]) begin
			if (bcdmon == premon) begin
				equmon <= 1'b1;
			end
			else begin
				equmon <= 1'b0;
			end
		end
		else begin
			equmon <= 1'b1;
		end

		// Whether the date equals predetermining date
	always_ff @(posedge wb_clk_i)
		if (int_mask[4]) begin
			if (bcddate == predate) begin
				equdate <= 1'b1;
			end
			else begin
				equdate <= 1'b0;
			end
		end
		else begin
			equdate <= 1'b1;
		end

		// Whether the day equals predetermining day
	always_ff @(posedge wb_clk_i)
		if (int_mask[3]) begin
			if (bcdday == preday) begin
				equday <= 1'b1;
			end
			else begin
				equday <= 1'b0;
			end
		end
		else begin
			equday <= 1'b1;
		end

		// Whether the hour equals predetermining hour
	always_ff @(posedge wb_clk_i)
		if (int_mask[2]) begin
			if (bcdhour == prehour) begin
				equhour <= 1'b1;
			end
			else begin
				equhour <= 1'b0;
			end
		end
		else begin
			equhour <= 1'b1;
		end

		// Whether the minute equals predetermining minute
	always_ff @(posedge wb_clk_i)
		if (int_mask[1]) begin
			if (bcdmin == premin) begin
				equmin <= 1'b1;
			end
			else begin
				equmin <= 1'b0;
			end
		end
		else begin
			equmin <= 1'b1;
		end

		// Whether the second equals predetermining second
	always_ff @(posedge wb_clk_i)
		if (int_mask[0]) begin
			if (bcdsec == presec) begin
				equsec <= 1'b1;
			end
			else begin
				equsec <= 1'b0;
			end
		end
		else begin
			equsec <= 1'b1;
		end

	always_comb
		equ_int = rtc_inte[6] ? equyear & equmon & equdate & equday & equhour & equmin & equsec : 1'b0;

		// RTC Interrupt Request
	always_ff @(posedge wb_clk_i or posedge wb_rst_i)
		if (wb_rst_i) begin
			rtc_int <= 1'b0;
		end
		else begin
			rtc_int <= rtc_int_r;
		end

	always_comb
		rtc_int_o = rtc_con[6] ? rtc_int : 1'b0;

	always_comb
		case (rtc_con[4:2])
			3'h0: begin
				rtc_int_r = equ_int;
			end
			3'h1: begin
				rtc_int_r = sec_int;
			end
			3'h2: begin
				rtc_int_r = min_int;
			end
			3'h3: begin
				rtc_int_r = hour_int;
			end
			3'h4: begin
				rtc_int_r = date_int;
			end
			3'h5: begin
				rtc_int_r = week_int;
			end
			3'h6: begin
				rtc_int_r = mon_int;
			end
			3'h7: begin
				rtc_int_r = 1'b0;
			end
		endcase

endmodule
 
