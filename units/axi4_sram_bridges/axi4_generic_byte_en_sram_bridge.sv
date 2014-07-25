/****************************************************************************
 * axi4_generic_byte_en_sram_bridge.sv
 ****************************************************************************/

/**
 * Module: axi4_generic_byte_en_sram_bridge
 * 
 * TODO: Add module documentation
 */
module axi4_generic_byte_en_sram_bridge #(
			parameter int MEM_ADDR_BITS=10,
			parameter int AXI_ADDRESS_WIDTH=32,
			parameter int AXI_DATA_WIDTH=1024,
			parameter int AXI_ID_WIDTH=4,
			parameter bit[MEM_ADDR_BITS-1:0]    MEM_ADDR_OFFSET=0
		) (
			input									clk,
			input									rst_n,
			axi4_if.slave							axi_if,
			generic_sram_byte_en_if.sram_client		sram_if
		);
	assign axi_if.RRESP = {2{1'b0}};
	assign axi_if.BRESP = {2{1'b0}};
    
	reg[2:0] 						write_state;
	reg[MEM_ADDR_BITS-1:4]			write_addr;
	wire[MEM_ADDR_BITS-1:0]			write_addr_w;
	reg[3:0]						write_offset;
	reg[3:0]						write_count;
	reg[AXI_ID_WIDTH-1:0]			write_id;
	reg[1:0]						write_burst;
	reg[3:0]						write_wrap_mask;
	reg[AXI_DATA_WIDTH-1:0]			write_data;
	reg[2:0] 						read_state;
	reg[MEM_ADDR_BITS-1:4]			read_addr;
	wire[MEM_ADDR_BITS-1:0]			read_addr_w;
	reg[3:0]						read_offset;
	reg[3:0]						read_count;
	reg[3:0]						read_length;
	reg[AXI_ID_WIDTH-1:0]			read_id;
	reg[1:0]						read_burst;
	reg[3:0]						read_wrap_mask;
	reg[1:0]						sram_owner = 0;
	wire[MEM_ADDR_BITS-1:0]			sram_addr;

	always @(posedge clk)
	begin
		if (!rst_n) begin
			write_state <= 2'b00;
			write_offset <= 0;
			write_id <= 0;
			write_burst <= 0;
			write_wrap_mask <= 0;
			write_addr <= 0;
			write_count <= 4'b0000;
    		
			read_state <= 2'b00;
			read_addr <= 0;
			read_offset <= 0;
			read_count <= 4'b0000;
			read_length <= 4'b0000;
			read_id <= 0;
			read_burst <= 0;
			read_wrap_mask <= 0;
			sram_owner <= 0;
    		
		end else begin
//			write_data <= axi_if.WDATA;
			case (write_state) 
				2'b00: begin // Wait Address state
					if (axi_if.AWVALID == 1'b1 && axi_if.AWREADY == 1'b1) begin
						write_addr <= axi_if.AWADDR[MEM_ADDR_BITS+2:6];
						write_offset <= axi_if.AWADDR[5:2];
    					
						write_id <= axi_if.AWID;
						write_count <= 0;
						write_state <= 1;
						sram_owner <= 0;
    				
						case (axi_if.AWBURST)
							2: begin
								case (axi_if.AWLEN)
									0,1: write_wrap_mask <= 1;
									2,3: write_wrap_mask <= 3;
									4,5,6,7: write_wrap_mask <= 7;
									default: write_wrap_mask <= 15;
								endcase
							end
	    					
							default: write_wrap_mask <= 'hf;
						endcase
					end
				end
    			
				2'b01: begin // Wait for write data
					if (axi_if.WVALID == 1'b1 && axi_if.WREADY == 1'b1) begin
						if (axi_if.WLAST == 1'b1) begin
							write_state <= 2;
						end else begin
							write_count <= write_count + 1;
						end
    				
						case (write_burst)
							2: begin
								write_offset <= (write_offset & ~write_wrap_mask) |
									((write_offset + 1) & write_wrap_mask);
							end
    						
							default: begin
								if (write_offset == 'hf) begin
									write_addr <= write_addr + 1;
								end
								write_offset <= write_offset + 1;
							end
						endcase
					end
				end
    			
				2'b10: begin  // Send write response
					if (axi_if.BVALID == 1'b1 && axi_if.BREADY == 1'b1) begin
						write_state <= 2'b00;
					end
				end
    			
				default: begin
				end
			endcase
		end
	end
	
	reg[AXI_DATA_WIDTH-1:0]			read_data;
    		
	always @(posedge clk) begin
		if (rst_n == 0) begin
			read_state <= 0;
		end else begin
			case (read_state)
				2'b00: begin // Wait address state
					if (axi_if.ARVALID && axi_if.ARREADY) begin
						read_addr <= axi_if.ARADDR[MEM_ADDR_BITS+2:6];
						read_offset <= axi_if.ARADDR[5:2];
						read_length <= axi_if.ARLEN;
						read_burst <= axi_if.ARBURST;
						read_count <= 0;
						read_state <= 1;
						read_id <= axi_if.ARID;
						sram_owner <= 1;
    					
						case (axi_if.ARBURST) 
							2: begin
								case (axi_if.ARLEN) 
									0,1: read_wrap_mask <= 1;
									2,3: read_wrap_mask <= 3;
									4,5,6,7: read_wrap_mask <= 7;
									default: read_wrap_mask <= 15;
								endcase
							end
    						
							default: read_wrap_mask <= 'hf;
						endcase
					end
				end
    		
				// Propagate address to data
				1: read_state <= 2;
    		
					// Propagate address to data
				2: begin
					read_data <= sram_if.read_data;
					read_state <= 3;
				end
    			
				3: begin 
					if (axi_if.RVALID && axi_if.RREADY) begin
						if (read_count == read_length) begin
							read_state <= 1'b0;
						end else begin
							read_count <= read_count + 1;
							read_state <= 4;
						end
    					
						case (read_burst) 
							2: begin
								read_offset <= (read_offset & ~read_wrap_mask) |
									((read_offset + 1) & read_wrap_mask);
							end
    						
							default: begin
								if (read_offset == 'hf) begin
									read_addr <= read_addr + 1;
								end
								read_offset <= read_offset + 1;
							end
						endcase
					end
				end
    			
				4: read_state <= 2;
    			
				default: read_state <= 0;
			endcase
		end
	end
    
	assign read_addr_w = {read_addr,read_offset};
	assign write_addr_w = {write_addr, write_offset};
	
	assign sram_if.addr = sram_addr;
	assign sram_if.write_en = (axi_if.WVALID & axi_if.WREADY);
	assign sram_if.byte_en = axi_if.WSTRB;
//	assign sram_if.write_data = write_data;
	assign sram_if.write_data = axi_if.WDATA;
	
	assign axi_if.RDATA = read_data;
	
	assign sram_if.read_en = 1;
    
	assign sram_addr = (sram_owner == 0)?(write_addr_w-MEM_ADDR_OFFSET):
			(read_addr_w-MEM_ADDR_OFFSET);
   
	assign axi_if.AWREADY = (write_state == 0 && 
			((sram_owner == 1 && axi_if.AWVALID) || !axi_if.ARVALID));
	assign axi_if.WREADY = (write_state == 1);
    
	assign axi_if.BVALID = (write_state == 2);
	assign axi_if.BID = (write_state == 2)?write_id:0;
    
	assign axi_if.ARREADY = (read_state == 1'b0 && 
			((sram_owner == 0 && axi_if.ARVALID) || !axi_if.AWVALID));

	assign axi_if.RVALID = (read_state == 3);
	assign axi_if.RLAST = (read_state == 3 && read_count == read_length)?1'b1:1'b0;
	assign axi_if.RID = (read_state == 3)?read_id:0;	

endmodule
