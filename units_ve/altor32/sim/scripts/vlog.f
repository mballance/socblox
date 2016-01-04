/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
 
${COMMON_RTL}/wb/wb_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_rom_w.sv

-f ${COMMON_RTL}/../sram/common_sram.f

${UNITS}/interconnects/wb/wb_interconnect_NxN.sv
${UNITS}/interconnects/wb/wb_interconnect_2x2.sv

-f ${UNITS}/wb_sram_bridges/wb_sram_bridges.f
${UNITS}/wb_sram/wb_sram.sv
${UNITS}/wb_rom/wb_rom.sv

-f ${UNITS}/altor32/altor32.f

${SIM_DIR}/../tb/altor32_tb.sv


