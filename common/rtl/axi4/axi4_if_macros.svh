
`define AXI4_IF_MASTER_PORTS(prefix, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH) \
			output[AXI4_ID_WIDTH-1:0] 		prefix``_AWID, \
			output[AXI4_ADDRESS_WIDTH-1:0]	prefix``_AWADDR, \
			output[7:0]						prefix``_AWLEN, \
			output[2:0]						prefix``_AWSIZE, \
			output[1:0]						prefix``_AWBURST, \
			output							prefix``_AWLOCK, \
			output[3:0]						prefix``_AWCACHE, \
			output[2:0]						prefix``_AWPROT, \
			output[3:0]						prefix``_AWQOS, \
			output[3:0]						prefix``_AWREGION, \
			output 							prefix``_AWVALID, \
			input							prefix``_AWREADY, \
			\
			output[AXI4_DATA_WIDTH-1:0]		prefix``_WDATA,   \
			output[(AXI4_DATA_WIDTH/8)-1:0]	prefix``_WSTRB,   \
			output 							prefix``_WLAST,   \
			output 							prefix``_WVALID,  \
			input 							prefix``_WREADY,  \
			\
			input[AXI4_ID_WIDTH-1:0]		prefix``_BID,    \
			input[1:0]						prefix``_BRESP,  \
			input 							prefix``_BVALID, \
			output 							prefix``_BREADY, \
			\
			output[AXI4_ID_WIDTH-1:0]			prefix``_ARID, \
			output[AXI4_ADDRESS_WIDTH-1:0]	prefix``_ARADDR, \
			output[7:0]						prefix``_ARLEN, \
			output[2:0]						prefix``_ARSIZE, \
			output[1:0]						prefix``_ARBURST, \
			output 							prefix``_ARLOCK, \
			output[3:0]						prefix``_ARCACHE, \
			output[2:0]						prefix``_ARPROT, \
			output[3:0]						prefix``_ARQOS, \
			output[3:0]						prefix``_ARREGION, \
			output 							prefix``_ARVALID, \
			input 							prefix``_ARREADY, \
			\
			input[AXI4_ID_WIDTH-1:0]		prefix``_RID, \
			input[AXI4_DATA_WIDTH-1:0]		prefix``_RDATA, \
			input[1:0]						prefix``_RRESP, \
			input 							prefix``_RLAST, \
			input 							prefix``_RVALID, \
			output 							prefix``_RREADY

`define AXI4_IF_MONITOR_PORTS(prefix, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH) \
			output[AXI4_ID_WIDTH-1:0] 		prefix``_AWID, \
			output[AXI4_ADDRESS_WIDTH-1:0]	prefix``_AWADDR, \
			output[7:0]						prefix``_AWLEN, \
			output[2:0]						prefix``_AWSIZE, \
			output[1:0]						prefix``_AWBURST, \
			output							prefix``_AWLOCK, \
			output[3:0]						prefix``_AWCACHE, \
			output[2:0]						prefix``_AWPROT, \
			output[3:0]						prefix``_AWQOS, \
			output[3:0]						prefix``_AWREGION, \
			output 							prefix``_AWVALID, \
			output							prefix``_AWREADY, \
			\
			output[AXI4_DATA_WIDTH-1:0]		prefix``_WDATA,   \
			output[(AXI4_DATA_WIDTH/8)-1:0]	prefix``_WSTRB,   \
			output 							prefix``_WLAST,   \
			output 							prefix``_WVALID,  \
			output 							prefix``_WREADY,  \
			\
			output[AXI4_ID_WIDTH-1:0]		prefix``_BID,    \
			output[1:0]						prefix``_BRESP,  \
			output 							prefix``_BVALID, \
			output 							prefix``_BREADY, \
			\
			output[AXI4_ID_WIDTH-1:0]		prefix``_ARID, \
			output[AXI4_ADDRESS_WIDTH-1:0]	prefix``_ARADDR, \
			output[7:0]						prefix``_ARLEN, \
			output[2:0]						prefix``_ARSIZE, \
			output[1:0]						prefix``_ARBURST, \
			output 							prefix``_ARLOCK, \
			output[3:0]						prefix``_ARCACHE, \
			output[2:0]						prefix``_ARPROT, \
			output[3:0]						prefix``_ARQOS, \
			output[3:0]						prefix``_ARREGION, \
			output 							prefix``_ARVALID, \
			output 							prefix``_ARREADY, \
			\
			output[AXI4_ID_WIDTH-1:0]		prefix``_RID, \
			output[AXI4_DATA_WIDTH-1:0]		prefix``_RDATA, \
			output[1:0]						prefix``_RRESP, \
			output 							prefix``_RLAST, \
			output 							prefix``_RVALID, \
			output 							prefix``_RREADY
			
`define AXI4_IF_SLAVE_PORTS(prefix, AXI4_ADDRESS_WIDTH, AXI4_DATA_WIDTH, AXI4_ID_WIDTH) \
			input[AXI4_ID_WIDTH-1:0] 		prefix``_AWID, \
			input[AXI4_ADDRESS_WIDTH-1:0]	prefix``_AWADDR, \
			input[7:0]						prefix``_AWLEN, \
			input[2:0]						prefix``_AWSIZE, \
			input[1:0]						prefix``_AWBURST, \
			input							prefix``_AWLOCK, \
			input[3:0]						prefix``_AWCACHE, \
			input[2:0]						prefix``_AWPROT, \
			input[3:0]						prefix``_AWQOS, \
			input[3:0]						prefix``_AWREGION, \
			input 							prefix``_AWVALID, \
			output							prefix``_AWREADY, \
			\
			input[AXI4_DATA_WIDTH-1:0]		prefix``_WDATA,   \
			input[(AXI4_DATA_WIDTH/8)-1:0]	prefix``_WSTRB,   \
			input 							prefix``_WLAST,   \
			input 							prefix``_WVALID,  \
			output 							prefix``_WREADY,  \
			\
			output[AXI4_ID_WIDTH-1:0]		prefix``_BID,    \
			output[1:0]						prefix``_BRESP,  \
			output 							prefix``_BVALID, \
			input 							prefix``_BREADY, \
			\
			input[AXI4_ID_WIDTH-1:0]		prefix``_ARID, \
			input[AXI4_ADDRESS_WIDTH-1:0]	prefix``_ARADDR, \
			input[7:0]						prefix``_ARLEN, \
			input[2:0]						prefix``_ARSIZE, \
			input[1:0]						prefix``_ARBURST, \
			input 							prefix``_ARLOCK, \
			input[3:0]						prefix``_ARCACHE, \
			input[2:0]						prefix``_ARPROT, \
			input[3:0]						prefix``_ARQOS, \
			input[3:0]						prefix``_ARREGION, \
			input 							prefix``_ARVALID, \
			output 							prefix``_ARREADY, \
			\
			output[AXI4_ID_WIDTH-1:0]		prefix``_RID, \
			output[AXI4_DATA_WIDTH-1:0]		prefix``_RDATA, \
			output[1:0]						prefix``_RRESP, \
			output 							prefix``_RLAST, \
			output 							prefix``_RVALID, \
			input 							prefix``_RREADY

`define AXI4_IF_CONNECT_MONITOR_PORTS2IF(prefix, ifc) \
	assign prefix``_AWID = ifc .AWID; \
	assign prefix``_AWADDR = ifc .AWADDR; \
	assign prefix``_AWLEN = ifc .AWLEN; \
	assign prefix``_AWSIZE = ifc .AWSIZE; \
	assign prefix``_AWBURST = ifc .AWBURST; \
	assign prefix``_AWLOCK = ifc .AWLOCK; \
	assign prefix``_AWCACHE = ifc .AWCACHE; \
	assign prefix``_AWPROT = ifc .AWPROT; \
	assign prefix``_AWQOS = ifc .AWQOS; \
	assign prefix``_AWREGION = ifc .AWREGION; \
	assign prefix``_AWVALID = ifc .AWVALID; \
	assign prefix``_AWREADY = ifc .AWREADY; \
	\
	assign prefix``_WDATA = ifc .WDATA; \
	assign prefix``_WSTRB = ifc .WSTRB; \
	assign prefix``_WLAST = ifc .WLAST; \
	assign prefix``_WVALID = ifc .WVALID; \
	assign prefix``_WREADY = ifc .WREADY; \
	\
	assign prefix``_BID = ifc .BID; \
	assign prefix``_BRESP = ifc .BRESP; \
	assign prefix``_BVALID = ifc .BVALID; \
	assign prefix``_BREADY = ifc .BREADY; \
	\
	assign prefix``_ARID = ifc .ARID; \
	assign prefix``_ARADDR = ifc .ARADDR; \
	assign prefix``_ARLEN = ifc .ARLEN; \
	assign prefix``_ARSIZE = ifc .ARSIZE; \
	assign prefix``_ARBURST = ifc .ARBURST; \
	assign prefix``_ARLOCK = ifc .ARLOCK; \
	assign prefix``_ARCACHE = ifc .ARCACHE; \
	assign prefix``_ARPROT = ifc .ARPROT; \
	assign prefix``_ARQOS = ifc .ARQOS; \
	assign prefix``_ARREGION = ifc .ARREGION; \
	assign prefix``_ARVALID = ifc .ARVALID; \
	assign prefix``_ARREADY = ifc .ARREADY; \
	\
	assign prefix``_RID = ifc .RID; \
	assign prefix``_RDATA = ifc .RDATA; \
	assign prefix``_RRESP = ifc .RRESP; \
	assign prefix``_RLAST = ifc .RLAST; \
	assign prefix``_RVALID = ifc .RVALID; \
	assign prefix``_RREADY = ifc .RREADY
	
`define AXI4_IF_CONNECT_MONITOR_IF2IF(dest, src) \
	assign dest .AWID = src .AWID; \
	assign dest .AWADDR = src .AWADDR; \
	assign dest .AWLEN = src .AWLEN; \
	assign dest .AWSIZE = src .AWSIZE; \
	assign dest .AWBURST = src .AWBURST; \
	assign dest .AWLOCK = src .AWLOCK; \
	assign dest .AWCACHE = src .AWCACHE; \
	assign dest .AWPROT = src .AWPROT; \
	assign dest .AWQOS = src .AWQOS; \
	assign dest .AWREGION = src .AWREGION; \
	assign dest .AWVALID = src .AWVALID; \
	assign dest .AWREADY = src .AWREADY; \
	\
	assign dest .WDATA = src .WDATA; \
	assign dest .WSTRB = src .WSTRB; \
	assign dest .WLAST = src .WLAST; \
	assign dest .WVALID = src .WVALID; \
	assign dest .WREADY = src .WREADY; \
	\
	assign dest .BID = src .BID; \
	assign dest .BRESP = src .BRESP; \
	assign dest .BVALID = src .BVALID; \
	assign dest .BREADY = src .BREADY; \
	\
	assign dest .ARID = src .ARID; \
	assign dest .ARADDR = src .ARADDR; \
	assign dest .ARLEN = src .ARLEN; \
	assign dest .ARSIZE = src .ARSIZE; \
	assign dest .ARBURST = src .ARBURST; \
	assign dest .ARLOCK = src .ARLOCK; \
	assign dest .ARCACHE = src .ARCACHE; \
	assign dest .ARPROT = src .ARPROT; \
	assign dest .ARQOS = src .ARQOS; \
	assign dest .ARREGION = src .ARREGION; \
	assign dest .ARVALID = src .ARVALID; \
	assign dest .ARREADY = src .ARREADY; \
	\
	assign dest .RID = src .RID; \
	assign dest .RDATA = src .RDATA; \
	assign dest .RRESP = src .RRESP; \
	assign dest .RLAST = src .RLAST; \
	assign dest .RVALID = src .RVALID; \
	assign dest .RREADY = src .RREADY	
	

`define AXI4_IF_CONNECT_SLAVE_PORTS2IF(prefix, ifc) \
	assign ifc .AWID = prefix``_AWID; \
	assign ifc .AWADDR = prefix``_AWADDR; \
	assign ifc .AWLEN = prefix``_AWLEN; \
	assign ifc .AWSIZE  = prefix``_AWSIZE; \
	assign ifc .AWBURST = prefix``_AWBURST; \
	assign ifc .AWLOCK  = prefix``_AWLOCK; \
	assign ifc .AWCACHE  = prefix``_AWCACHE; \
	assign ifc .AWPROT  = prefix``_AWPROT; \
	assign ifc .AWQOS  = prefix``_AWQOS; \
	assign ifc .AWREGION  = prefix``_AWREGION; \
	assign ifc .AWVALID  = prefix``_AWVALID; \
	assign prefix``_AWREADY = ifc .AWREADY; \
	\
	assign ifc .WDATA = prefix``_WDATA; \
	assign ifc .WSTRB = prefix``_WSTRB; \
	assign ifc .WLAST = prefix``_WLAST; \
	assign ifc .WVALID = prefix``_WVALID; \
	assign prefix``_WREADY = ifc .WREADY; \
	\
	assign prefix``_BID = ifc .BID; \
	assign prefix``_BRESP = ifc .BRESP; \
	assign prefix``_BVALID = ifc .BVALID; \
	assign ifc .BREADY = prefix``_BREADY; \
	\
	assign ifc .ARID = prefix``_ARID; \
	assign ifc .ARADDR = prefix``_ARADDR; \
	assign ifc .ARLEN = prefix``_ARLEN; \
	assign ifc .ARSIZE  = prefix``_ARSIZE; \
	assign ifc .ARBURST = prefix``_ARBURST; \
	assign ifc .ARLOCK  = prefix``_ARLOCK; \
	assign ifc .ARCACHE  = prefix``_ARCACHE; \
	assign ifc .ARPROT  = prefix``_ARPROT; \
	assign ifc .ARQOS  = prefix``_ARQOS; \
	assign ifc .ARREGION  = prefix``_ARREGION; \
	assign ifc .ARVALID  = prefix``_ARVALID; \
	assign prefix``_ARREADY = ifc .ARREADY; \
	\
	assign prefix``_RID = ifc .RID; \
	assign prefix``_RDATA = ifc .RDATA; \
	assign prefix``_RRESP = ifc .RRESP; \
	assign prefix``_RLAST = ifc .RLAST; \
	assign prefix``_RVALID = ifc .RVALID; \
	assign ifc .RREADY = prefix``_RREADY
	
`define AXI4_IF_STUB_SLAVE_IF(ifc) \
	assign ifc .AWID = 0; \
	assign ifc .AWADDR = 0; \
	assign ifc .AWLEN = 0; \
	assign ifc .AWSIZE  = 0; \
	assign ifc .AWBURST = 0; \
	assign ifc .AWLOCK  = 0; \
	assign ifc .AWCACHE  = 0; \
	assign ifc .AWPROT  = 0; \
	assign ifc .AWQOS  = 0; \
	assign ifc .AWREGION  = 0; \
	assign ifc .AWVALID  = 0; \
	\
	assign ifc .WDATA = 0; \
	assign ifc .WSTRB = 0; \
	assign ifc .WLAST = 0; \
	assign ifc .WVALID = 0; \
	\
	assign ifc .BREADY = 0; \
	\
	assign ifc .ARID = 0; \
	assign ifc .ARADDR = 0; \
	assign ifc .ARLEN = 0; \
	assign ifc .ARSIZE  = 0; \
	assign ifc .ARBURST = 0; \
	assign ifc .ARLOCK  = 0; \
	assign ifc .ARCACHE  = 0; \
	assign ifc .ARPROT  = 0; \
	assign ifc .ARQOS  = 0; \
	assign ifc .ARREGION  = 0; \
	assign ifc .ARVALID  = 0; \
	\
	assign ifc .RREADY = 0
	
`define AXI4_IF_CONNECT_MASTER_PORTS2IF(prefix, ifc) \
	assign prefix``_AWID = ifc .AWID; \
	assign prefix``_AWADDR = ifc .AWADDR; \
	assign prefix``_AWLEN = ifc .AWLEN; \
	assign prefix``_AWSIZE = ifc .AWSIZE; \
	assign prefix``_AWBURST = ifc .AWBURST; \
	assign prefix``_AWLOCK = ifc .AWLOCK; \
	assign prefix``_AWCACHE = ifc .AWCACHE; \
	assign prefix``_AWPROT = ifc .AWPROT; \
	assign prefix``_AWQOS = ifc .AWQOS; \
	assign prefix``_AWREGION = ifc .AWREGION; \
	assign prefix``_AWVALID = ifc .AWVALID; \
	assign ifc .AWREADY = prefix``_AWREADY; \
	\
	assign prefix``_WDATA = ifc .WDATA; \
	assign prefix``_WSTRB = ifc .WSTRB; \
	assign prefix``_WLAST = ifc .WLAST; \
	assign prefix``_WVALID = ifc .WVALID; \
	assign ifc .WREADY = prefix``_WREADY; \
	\
	assign ifc .BID = prefix``_BID; \
	assign ifc .BRESP = prefix``_BRESP; \
	assign ifc .BVALID = prefix``_BVALID; \
	assign prefix``_BREADY = ifc .BREADY; \
	\
	assign prefix``_ARID = ifc .ARID; \
	assign prefix``_ARADDR = ifc .ARADDR; \
	assign prefix``_ARLEN = ifc .ARLEN; \
	assign prefix``_ARSIZE = ifc .ARSIZE; \
	assign prefix``_ARBURST = ifc .ARBURST; \
	assign prefix``_ARLOCK = ifc .ARLOCK; \
	assign prefix``_ARCACHE = ifc .ARCACHE; \
	assign prefix``_ARPROT = ifc .ARPROT; \
	assign prefix``_ARQOS = ifc .ARQOS; \
	assign prefix``_ARREGION = ifc .ARREGION; \
	assign prefix``_ARVALID = ifc .ARVALID; \
	assign ifc .ARREADY = prefix``_ARREADY; \
	\
	assign ifc .RID = prefix``_RID; \
	assign ifc .RDATA = prefix``_RDATA; \
	assign ifc .RRESP = prefix``_RRESP; \
	assign ifc .RLAST = prefix``_RLAST; \
	assign ifc .RVALID = prefix``_RVALID; \
	assign prefix``_RREADY = ifc .RREADY

`define AXI4_IF_PORTMAP(prefix, ifc) \
	. prefix``_AWID (ifc .AWID), \
	. prefix``_AWADDR(ifc .AWADDR), \
	. prefix``_AWLEN(ifc .AWLEN), \
	. prefix``_AWSIZE(ifc .AWSIZE), \
	. prefix``_AWBURST(ifc .AWBURST), \
	. prefix``_AWLOCK(ifc .AWLOCK), \
	. prefix``_AWCACHE(ifc .AWCACHE), \
	. prefix``_AWPROT(ifc .AWPROT), \
	. prefix``_AWQOS(ifc .AWQOS), \
	. prefix``_AWREGION(ifc .AWREGION), \
	. prefix``_AWVALID(ifc .AWVALID), \
	. prefix``_AWREADY(ifc .AWREADY), \
	. prefix``_WDATA(ifc .WDATA), \
	. prefix``_WSTRB(ifc .WSTRB), \
	. prefix``_WLAST(ifc .WLAST), \
	. prefix``_WVALID(ifc .WVALID), \
	. prefix``_WREADY(ifc .WREADY), \
	. prefix``_BID(ifc .BID), \
	. prefix``_BRESP(ifc .BRESP), \
	. prefix``_BVALID(ifc .BVALID), \
	. prefix``_BREADY(ifc .BREADY), \
	. prefix``_ARID(ifc .ARID), \
	. prefix``_ARADDR(ifc .ARADDR), \
	. prefix``_ARLEN(ifc .ARLEN), \
	. prefix``_ARSIZE(ifc .ARSIZE), \
	. prefix``_ARBURST(ifc .ARBURST), \
	. prefix``_ARLOCK(ifc .ARLOCK), \
	. prefix``_ARCACHE(ifc .ARCACHE), \
	. prefix``_ARPROT(ifc .ARPROT), \
	. prefix``_ARQOS(ifc .ARQOS), \
	. prefix``_ARREGION(ifc .ARREGION), \
	. prefix``_ARVALID(ifc .ARVALID), \
	. prefix``_ARREADY(ifc .ARREADY), \
	. prefix``_RID(ifc .RID), \
	. prefix``_RDATA(ifc .RDATA), \
	. prefix``_RRESP(ifc .RRESP), \
	. prefix``_RLAST(ifc .RLAST), \
	. prefix``_RVALID(ifc .RVALID), \
	. prefix``_RREADY(ifc .RREADY)

`define AXI4_IF_PORTMAP_LOWER(prefix, ifc) \
	. prefix``_awid (ifc .AWID), \
	. prefix``_awaddr(ifc .AWADDR), \
	. prefix``_awlen(ifc .AWLEN), \
	. prefix``_awsize(ifc .AWSIZE), \
	. prefix``_awburst(ifc .AWBURST), \
	. prefix``_awlock(ifc .AWLOCK), \
	. prefix``_awcache(ifc .AWCACHE), \
	. prefix``_awprot(ifc .AWPROT), \
	. prefix``_awqos(ifc .AWQOS), \
	. prefix``_awregion(ifc .AWREGION), \
	. prefix``_awvalid(ifc .AWVALID), \
	. prefix``_awready(ifc .AWREADY), \
	. prefix``_wdata(ifc .WDATA), \
	. prefix``_wstrb(ifc .WSTRB), \
	. prefix``_wlast(ifc .WLAST), \
	. prefix``_wvalid(ifc .WVALID), \
	. prefix``_wready(ifc .WREADY), \
	. prefix``_bid(ifc .BID), \
	. prefix``_bresp(ifc .BRESP), \
	. prefix``_bvalid(ifc .BVALID), \
	. prefix``_bready(ifc .BREADY), \
	. prefix``_arid(ifc .ARID), \
	. prefix``_araddr(ifc .ARADDR), \
	. prefix``_arlen(ifc .ARLEN), \
	. prefix``_arsize(ifc .ARSIZE), \
	. prefix``_arburst(ifc .ARBURST), \
	. prefix``_arlock(ifc .ARLOCK), \
	. prefix``_arcache(ifc .ARCACHE), \
	. prefix``_arprot(ifc .ARPROT), \
	. prefix``_arqos(ifc .ARQOS), \
	. prefix``_arregion(ifc .ARREGION), \
	. prefix``_arvalid(ifc .ARVALID), \
	. prefix``_arready(ifc .ARREADY), \
	. prefix``_rid(ifc .RID), \
	. prefix``_rdata(ifc .RDATA), \
	. prefix``_rresp(ifc .RRESP), \
	. prefix``_rlast(ifc .RLAST), \
	. prefix``_rvalid(ifc .RVALID), \
	. prefix``_rready(ifc .RREADY)	

`define AXI4_IF_PORTMAP_LOWER_NO_REGION_QOS(prefix, ifc) \
	. prefix``_awid (ifc .AWID), \
	. prefix``_awaddr(ifc .AWADDR), \
	. prefix``_awlen(ifc .AWLEN), \
	. prefix``_awsize(ifc .AWSIZE), \
	. prefix``_awburst(ifc .AWBURST), \
	. prefix``_awlock(ifc .AWLOCK), \
	. prefix``_awcache(ifc .AWCACHE), \
	. prefix``_awprot(ifc .AWPROT), \
	. prefix``_awvalid(ifc .AWVALID), \
	. prefix``_awready(ifc .AWREADY), \
	. prefix``_wdata(ifc .WDATA), \
	. prefix``_wstrb(ifc .WSTRB), \
	. prefix``_wlast(ifc .WLAST), \
	. prefix``_wvalid(ifc .WVALID), \
	. prefix``_wready(ifc .WREADY), \
	. prefix``_bid(ifc .BID), \
	. prefix``_bresp(ifc .BRESP), \
	. prefix``_bvalid(ifc .BVALID), \
	. prefix``_bready(ifc .BREADY), \
	. prefix``_arid(ifc .ARID), \
	. prefix``_araddr(ifc .ARADDR), \
	. prefix``_arlen(ifc .ARLEN), \
	. prefix``_arsize(ifc .ARSIZE), \
	. prefix``_arburst(ifc .ARBURST), \
	. prefix``_arlock(ifc .ARLOCK), \
	. prefix``_arcache(ifc .ARCACHE), \
	. prefix``_arprot(ifc .ARPROT), \
	. prefix``_arvalid(ifc .ARVALID), \
	. prefix``_arready(ifc .ARREADY), \
	. prefix``_rid(ifc .RID), \
	. prefix``_rdata(ifc .RDATA), \
	. prefix``_rresp(ifc .RRESP), \
	. prefix``_rlast(ifc .RLAST), \
	. prefix``_rvalid(ifc .RVALID), \
	. prefix``_rready(ifc .RREADY)	

	