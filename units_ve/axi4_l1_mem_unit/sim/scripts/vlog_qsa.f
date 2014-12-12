
+define+FPGA

// -f ${COMMON_RTL}/../fpga/altera_cyclonev_libs.f

${COMMON_RTL}/../sram/fpga/altera/generic_sram_byte_en.v
${COMMON_RTL}/../sram/fpga/altera/generic_sram_line_en.v
${COMMON_RTL}/../sram/fpga/altera/generic_sram_byte_en_dualport.v
${COMMON_RTL}/../sram/fpga/altera/generic_sram_line_en_dualport.v

-f ${SIM_DIR}/scripts/vlog_rtl.f
-f ${COMMON_RTL}/../fpga/altera_cyclonev_libs.f

${SIM_DIR}/../tb/axi4_l1_mem_unit_tb.sv
