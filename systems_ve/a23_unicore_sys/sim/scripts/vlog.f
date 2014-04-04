
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

${SOCBLOX}/units/a23_unicore_subsys/a23_unicore_subsys.sv
${SOCBLOX}/systems/a23_unicore/a23_unicore_sys.sv

${SOCBLOX}/systems_ve/a23_unicore_sys/tb/a23_unicore_sys_tb.sv



