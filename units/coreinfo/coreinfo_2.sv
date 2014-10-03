/****************************************************************************
 * coreinfo_2.sv
 ****************************************************************************/

/**
 * Module: coreinfo_2
 * 
 * TODO: Add module documentation
 * 
 * Address Map:
 * 0x0000:		N_CORES
 * 0x0004:		CORE_ID
 * 0x0008:		SET_RST	-- write core ID for which to set rst_n
 * 0x000C:		CLR_RST -- write core ID for which to clear rst_n
 */
module coreinfo_2 #(
		parameter int AXI_ID_WIDTH=4,
		parameter bit[31:0] CORE0_AXI_ID=0,
		parameter bit[31:0] CORE0_ID=0,
		parameter bit[31:0] CORE1_AXI_ID=0,
		parameter bit[31:0] CORE1_ID=0
		) (
		input			clk_i,
		input			rst_n,
		axi4_if.slave	s,
		output reg		rst_n_1 = 0
		);

	localparam N_CORES=2;
	localparam N_ID_BITS=$clog2(N_CORES);
	
	localparam ADDR_N_CORES = 'h0;
	localparam ADDR_CORE_ID = 'h1;
	localparam ADDR_SET_RST = 'h2;
	localparam ADDR_CLR_RST = 'h3;

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
	
	reg[31:0]			read_data = 0;
	
	always @* begin
		case (read_addr[1:0])
			ADDR_N_CORES: read_data = N_CORES;
			ADDR_CORE_ID: read_data = core_id;
			default: read_data = 0;
		endcase
	end

    assign s.ARREADY = (read_state == 1'b0);
    assign s.RVALID = (read_state == 2);
    
    assign s.RDATA = read_data;
    assign s.RLAST = (read_state == 2 && read_count == read_length)?1'b1:1'b0;
    assign s.RID   = (read_state == 2)?read_id:0;
    
    
	// Write portion

    reg[2:0] 						write_state;
    reg[1:0]						write_addr;
    reg[AXI_ID_WIDTH-1:0]			write_id;
    reg[31:0]						write_data;    
   
   	always @(posedge clk_i) begin
		if (!rst_n) begin
			write_state <= 2'b00;
			write_id <= 0;
			write_addr <= 0;
		end else begin
			case (write_state) 
				2'b00: begin // Wait Address state
					if (s.AWVALID == 1'b1 && s.AWREADY == 1'b1) begin
						write_addr <= s.AWADDR[11:2];
    					
						write_id <= s.AWID;
						write_state <= 1;
					end
				end
    			
				2'b01: begin // Wait for write data
					if (s.WVALID == 1'b1 && s.WREADY == 1'b1) begin
						if (s.WLAST == 1'b1) begin
							write_state <= 2;
						end

						$display("write_addr[1:0] = 'h%0h", write_addr[1:0]);
						case (write_addr[1:0]) 
							ADDR_SET_RST: begin
								if (s.WDATA == CORE1_AXI_ID) begin
									rst_n_1 <= 0;
								end
							end
							ADDR_CLR_RST: begin
								if (s.WDATA == CORE1_AXI_ID) begin
									rst_n_1 <= 1;
								end
							end
						endcase
					end
				end
    			
				2'b10: begin  // Send write response
					if (s.BVALID == 1'b1 && s.BREADY == 1'b1) begin
						write_state <= 2'b00;
					end
				end
    			
				default: begin
				end
			endcase
		end
	end

	assign s.AWREADY = (write_state == 0);
	assign s.WREADY = (write_state == 1);
    
	assign s.BVALID = (write_state == 2);
	assign s.BID = (write_state == 2)?write_id:0;
	
endmodule

