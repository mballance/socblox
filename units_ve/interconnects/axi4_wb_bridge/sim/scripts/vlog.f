
-f ${SOCBLOX}/common/rtl/common_rtl.f
${SOCBLOX}/units/interconnects/axi4/axi4_interconnect_2x2.sv
${SOCBLOX}/units/interconnects/axi4/axi4_wb_bridge.sv
${SOCBLOX}/units/interconnects/wb/wb_interconnect_2x2.sv
${SOCBLOX}/units/timer/timer.sv

+incdir+${SOCBLOX}/common/bfm/wb_svf
${SOCBLOX}/common/bfm/wb_svf/wb_svf_master_bfm.sv
${SOCBLOX}/common/bfm/wb_svf/wb_sram_bfm.sv
+incdir+${SOCBLOX}/common/bfm/axi4_svf
${SOCBLOX}/common/bfm/axi4_svf/axi4_svf_master_bfm.sv
+incdir+${SOCBLOX}/common/bfm/axi4_svf_sram
${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv


${SOCBLOX}/units_ve/interconnects/axi4_wb_bridge/tb/axi4_wb_bridge_tb.sv

