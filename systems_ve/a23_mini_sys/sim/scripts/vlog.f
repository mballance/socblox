/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
+define+ROM_FILE
-f ${SYSTEMS}/a23_mini_sys/a23_mini_sys.f

${COMMON_RTL}/../sram/generic_sram_line_en.v
${COMMON_BFM}/generic_rom/generic_rom.sv
${COMMON_BFM}/generic_sram_byte_en/generic_sram_byte_en.sv
${COMMON_BFM}/axi4_monitor/axi4_monitor_bfm.sv

${COMMON_BFM}/a23_tracer/a23_tracer_bfm.sv

${SIM_DIR}/../tb/a23_mini_sys_tb.sv



