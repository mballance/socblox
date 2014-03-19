/****************************************************************************
 * a23_unicore_cyclone_v_top.sv
 ****************************************************************************/

/**
 * Module: a23_unicore_cyclone_v_top
 * 
 * TODO: Add module documentation
 */
module a23_unicore_cyclone_v_top (
		input				brdclk,
		input				brdrstn,
		output				led0,
		output				led1,
		output				led2,
		output				led3,
		output				led4,
		output				led5,
		output				led6,
		output				led7
		);
	
	reg clk_int = 0;
	
	always @(posedge brdclk) begin
		clk_int <= ~clk_int;
	end

	reg rstn = 0;
	reg [15:0] rstn_cnt = 0;
	
	always @(posedge brdclk) begin
		if (rstn_cnt == 100) begin
			rstn <= 1;
		end else begin
			rstn_cnt <= rstn_cnt + 1;
		end
	end
	
	uart_if u ();
	
	a23_unicore_sys u_sys (
		.brdclk(clk_int),
		.brdrstn(rstn),
		.u(u.dte)
		);

	reg [7:0]		data_t;
	reg [7:0]		data;
	reg [31:0]		bit_cnt = 'h19;
	reg [31:0]		bit_cnt2;
	reg [3:0]		bit_cnt3;
	reg	[3:0]		bit_state;
	
	assign led0 = data_t[0];
	assign led1 = data_t[1];
	assign led2 = data_t[2];
	assign led3 = data_t[3];
	assign led4 = data_t[4];
	assign led5 = data_t[5];
	assign led6 = data_t[6];
	assign led7 = data_t[7];

	always @(posedge clk_int) begin
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
						data_t <= data;
						bit_state <= 0;
					end
				end
			endcase
		end
	end	
	
endmodule

