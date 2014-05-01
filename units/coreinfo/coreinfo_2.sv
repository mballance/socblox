/****************************************************************************
 * coreinfo_2.sv
 ****************************************************************************/

/**
 * Module: coreinfo_2
 * 
 * TODO: Add module documentation
 * 
 * Address Map:
 * 0x0000:		CORE_ID
 */
module coreinfo_2 #(
		parameter int AXI_ID_WIDTH=4,
		parameter bit[31:0] CORE0_AXI_ID=0,
		parameter bit[31:0] CORE0_ID=0,
		parameter bit[31:0] CORE1_AXI_ID=0,
		parameter bit[31:0] CORE1_ID=0,
		) (
		input			clk_i,
		input			rst_n,
		axi4_if.slave	slave
		);

	localparam N_CORES=2;
	localparam N_ID_BITS=$clog2(N_CORES);

	reg[31:0]				core_id;
	reg[N_ID_BITS-1:0]		arid;

	always @(posedge clk_i) begin
		if (arid == CORE0_AXI_ID) begin
			core_id <= CORE0_ID;
		end else if (arid == CORE1_AXI_ID) begin
			core_id <= CORE1_ID;
		end else begin
			core_id <= {32{1'b1}};
		end
	end

	reg[1:0] 						read_state;
	reg[9:0]						read_addr;
	reg[AXI_ID_WIDTH-1:0]			read_id;
    reg[3:0]						read_count;
    reg[3:0]						read_length;

	always @(posedge clk_i) begin
		if (rst_n == 0) begin
			read_state <= 2'b00;
			read_addr <= {10{1'b0}};
		end else begin
			case (read_state)
				2'b00: begin // Wait address state
					if (s.ARVALID && s.ARREADY) begin
						read_addr <= s.ARADDR[11:2];
						read_length <= s.ARLEN;
						read_count <= 0;
						read_state <= 1;
						read_id <= s.ARID;
						arid <= s.ARID[AXI_ID_WIDTH-1:AXI_ID_WIDTH-N_ID_BITS];
					end
				end
    			
				1: begin
					read_state <= 2;
				end
    			
				2: begin 
					if (s.RVALID && s.RREADY) begin
						if (read_count == read_length) begin
							read_state <= 1'b0;
						end else begin
							read_count <= read_count + 1;
						end
					end
				end
				
				default: begin
					read_state <= 0;
				end
			endcase
		end
	end	

    assign s.ARREADY = (read_state == 1'b0);
    assign s.RVALID = (read_state == 2);

    assign s.RDATA = (read_addr == 0)?core_id:{32{1'b1}};
    assign s.RLAST = (read_state == 2 && read_count == read_length)?1'b1:1'b0;
    assign s.RID   = (read_state == 2)?read_id:0;
	
endmodule

