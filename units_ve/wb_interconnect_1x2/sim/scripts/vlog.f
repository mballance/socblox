/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/

${COMMON_BFM}/wb_master_bfm/wb_master_bfm.sv
${COMMON_RTL}/wb/wb_if.sv
-f ${COMMON_RTL}/../sram/common_sram.f
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv

${UNITS}/interconnects/wb/wb_interconnect_NxN.sv
${UNITS}/interconnects/wb/wb_interconnect_1x2.sv

${UNITS}/wb_sram_bridges/wb_generic_byte_en_sram_bridge.sv
${UNITS}/wb_sram/wb_sram.sv

${SIM_DIR}/../tb/wb_interconnect_1x2_tb.sv


