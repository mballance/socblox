/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/

-f ${SIM_DIR}/scripts/vlog_rtl.f

${COMMON_RTL}/../sram/generic_sram_byte_en.v
${COMMON_RTL}/../sram/generic_sram_byte_en_dualport.v
${COMMON_RTL}/../sram/generic_sram_line_en.v
${COMMON_RTL}/../sram/generic_sram_line_en_dualport.v

${SIM_DIR}/../tb/axi4_l1_mem_subsys_tb.sv


