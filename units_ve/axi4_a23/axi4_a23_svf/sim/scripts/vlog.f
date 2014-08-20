
+define+A23_TRACE

-f ${SOCBLOX}/common/rtl/common_rtl.f
// -f ${SOCBLOX}/common/sram/common_sram.f
${COMMON_RTL}/../sram/generic_sram_line_en.v
// ${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
// ${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
-f ${UNITS}/axi4_a23/axi4_a23.f
${SOCBLOX}/units/interconnects/axi4/axi4_interconnect_1x1.sv
${UNITS}/axi4_sram/axi4_sram.sv
${COMMON_BFM}/generic_sram_byte_en/generic_sram_byte_en.sv
${COMMON_BFM}/a23_tracer/a23_tracer_bfm.sv
${SIM_DIR}/../tb/axi4_a23_tb.sv

