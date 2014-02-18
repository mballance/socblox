
-f ${SOCBLOX}/common/rtl/common_rtl.f
+define+AXI4_SVF_ROM_NAME=axi4_rom
${SOCBLOX}/common/bfm/axi4_rom/axi4_svf_rom.sv
+define+AXI4_SVF_SRAM_NAME=axi4_sram
${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv
${SOCBLOX}/common/bfm/a23_tracer/axi4_a23_svf_tracer.sv

${SOCBLOX}/common/sram/generic_sram_byte_en.v
${SOCBLOX}/common/sram/generic_sram_line_en.v

-f ${SOCBLOX}/units/axi4_a23/axi4_a23.f

-f ${SOCBLOX}/units/interconnects/axi4/axi4_interconnects.f
-f ${SOCBLOX}/units/interconnects/wb/wb_interconnects.f

${SOCBLOX}/units/interconnects/axi4/axi4_wb_bridge.sv
${SOCBLOX}/units/wb_uart/wb_uart.sv

${SOCBLOX}/common/bfm/uart/uart_bfm.sv

${SOCBLOX}/units/a23_dualcore_subsys/a23_dualcore_subsys.sv
${SOCBLOX}/systems/a23_dualcore/a23_dualcore_sys.sv

/*
${SOCBLOX}/units/interconnects/axi4/axi4_interconnect_2x2.sv
${SOCBLOX}/units/interconnects/axi4/axi4_wb_bridge.sv
${SOCBLOX}/units/interconnects/wb/wb_interconnect_2x2.sv
${SOCBLOX}/units/timer/timer.sv
${SOCBLOX}/units/wb_uart/wb_uart.sv

+incdir+${SOCBLOX}/common/bfm/wb_svf
${SOCBLOX}/common/bfm/wb_svf/wb_svf_master_bfm.sv
${SOCBLOX}/common/bfm/wb_svf/wb_sram_bfm.sv
+incdir+${SOCBLOX}/common/bfm/axi4_svf
${SOCBLOX}/common/bfm/axi4_svf/axi4_svf_master_bfm.sv
+incdir+${SOCBLOX}/common/bfm/axi4_svf_sram
${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv


${SOCBLOX}/units_ve/interconnects/axi4_wb_bridge/tb/axi4_wb_bridge_tb.sv
 */
${SOCBLOX}/systems_ve/a23_dualcore_sys/tb/a23_dualcore_sys_tb.sv


