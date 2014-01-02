/****************************************************************************
 * axi4_sram.sv
 ****************************************************************************/

/**
 * Module: axi4_svm_sram
 * 
 * TODO: Add module documentation
 */
module axi4_svm_sram #(
			parameter MEM_ADDR_BITS=10,
			parameter AXI_ADDRESS_WIDTH=32,
			parameter AXI_DATA_WIDTH=1024,
			parameter AXI_ID_WIDTH=4
		) (
			input				ACLK,
			input				ARESETn,
			axi4_if.slave		s
		);
	
    bit [(AXI_DATA_WIDTH-1):0] ram[1<<MEM_ADDR_BITS];
    
    task axi4_svm_sram_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	bit[AXI_DATA_WIDTH-1:0] tmp = ram[offset >> 2];
    	tmp &= ~('hff << offset[2:0]);
    	tmp |= (data << offset[2:0]);
    	ram[offset] = tmp;
    endtask
    export "DPI-C" task axi4_svm_sram_write8;
    
    task axi4_svm_sram_write16(
    	longint unsigned 	offset,
    	int unsigned 		data);
    	ram[offset] = data;
    endtask
    export "DPI-C" task axi4_svm_sram_write16;
    
    task axi4_svm_sram_write32(
    	longint unsigned	offset,
    	int unsigned 		data);
    	ram[offset[(AXI_ADDRESS_WIDTH-1):2]] = data;
    endtask
    export "DPI-C" task axi4_svm_sram_write32;
	
    task axi4_svm_sram_read32(
    	longint unsigned	offset,
    	output int unsigned data);
    	data = ram[offset[(AXI_ADDRESS_WIDTH-1):2]];
    endtask
    export "DPI-C" task axi4_svm_sram_read32;
    
    task axi4_svm_sram_read16(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = ram[offset];
    endtask
    export "DPI-C" task axi4_svm_sram_read16;
    
    task axi4_svm_sram_read8(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = ram[offset];
    endtask
    export "DPI-C" task axi4_svm_sram_read8;
    
    import "DPI-C" context task axi4_svm_sram_register();
    
    initial begin
    	axi4_svm_sram_register();
    end
    
    assign s.RRESP = {2{1'b0}};
    assign s.BRESP = {2{1'b0}};
    
    reg[1:0] 						write_state;
    reg[MEM_ADDR_BITS-1:0]			write_addr;
    reg[3:0]						write_count;
    reg[AXI_ID_WIDTH-1:0]			write_id;
    reg[1:0] 						read_state;
    reg[MEM_ADDR_BITS-1:0]			read_addr;
    reg[3:0]						read_count;
    reg[3:0]						read_length;
    reg[AXI_ID_WIDTH-1:0]			read_id;

    always @(posedge ACLK)
    begin
    	if (!ARESETn) begin
    		write_state <= 2'b00;
    		read_state <= 2'b00;
    		write_addr <= {MEM_ADDR_BITS{1'b0}};
    		write_addr <= 0;
    		write_count <= 4'b0000;
    		read_addr <= {MEM_ADDR_BITS{1'b0}};
    		read_addr <= 0;
    		read_count <= 4'b0000;
    		read_length <= 4'b0000;
    	end else begin
    		case (write_state) 
    			2'b00: begin // Wait Address state
    				if (s.AWVALID == 1'b1 && s.AWREADY == 1'b1) begin
    					write_addr <= s.AWADDR[MEM_ADDR_BITS+1:2];
    					write_id <= s.AWID;
    					write_count <= 0;
    					write_state <= 1;
    				end
    			end
    			
    			2'b01: begin // Wait for write data
    				if (s.WVALID == 1'b1 && s.WREADY == 1'b1) begin
    					$display("%m: write 'h%08h='h%08h", (write_addr+write_count), s.WDATA);
    					ram[write_addr + write_count] <= s.WDATA;
    					if (s.WLAST == 1'b1) begin
    						write_state <= 2;
    					end else begin
    						write_count <= write_count + 1;
    					end
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
    		
    		case (read_state)
    			2'b00: begin // Wait address state
    				if (s.ARVALID && s.ARREADY) begin
    					read_addr <= s.ARADDR[MEM_ADDR_BITS+1:2];
    					read_length <= s.ARLEN;
    					read_count <= 0;
    					read_state <= 1;
    					read_id <= s.ARID;
    				end
    			end
    			
    			2'b01: begin 
    				if (s.RVALID && s.RREADY) begin
    					$display("%m: read 'h%08h='h%08h", (read_addr+read_count), ram[read_addr+read_count]);
    					if (read_count == read_length) begin
    						read_state <= 1'b0;
    					end else begin
    						read_count <= read_count + 1;
    					end
    				end
    			end
    		endcase
    		
    		// Read state machine
//    		case (read_state)
//    		endcase
    	end
    end
    
    assign s.AWREADY = (write_state == 0);
    assign s.WREADY = (write_state == 1);
    
    assign s.BVALID = (write_state == 2);
    assign s.BID = (write_state == 2)?write_id:0;
    
    assign s.ARREADY = (read_state == 1'b0);
    assign s.RVALID = (read_state == 1'b1);

    assign s.RDATA = ram[read_addr + read_count];
    assign s.RLAST = (read_state == 1'b01 && read_count == read_length)?1'b1:1'b0;
    assign s.RID = (read_state == 1)?read_id:0;

endmodule

