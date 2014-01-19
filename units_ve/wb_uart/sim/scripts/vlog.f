
-f ${SOCBLOX}/common/rtl/common_rtl.f
${SOCBLOX}/units/interconnects/wb/wb_interconnect_1x1.sv
${SOCBLOX}/units/wb_uart/wb_uart.sv

+incdir+${SOCBLOX}/common/bfm/wb_svf
${SOCBLOX}/common/bfm/wb_svf/wb_svf_master_bfm.sv
+incdir+${SOCBLOX}/common/bfm/uart
${SOCBLOX}/common/bfm/uart/uart_bfm.sv

${SOCBLOX}/units_ve/wb_uart/tb/wb_uart_tb.sv

