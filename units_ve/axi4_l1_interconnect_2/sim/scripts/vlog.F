/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/

${COMMON_RTL}/axi4/axi4_if.sv 
${COMMON_RTL}/axi4/axi4_monitor.sv

${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_line_en_w.sv

${COMMON_RTL}/../sram/generic_sram_byte_en.v
${COMMON_RTL}/../sram/generic_sram_line_en.v

${UNITS}/axi4_sram/axi4_sram.sv
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${UNITS}/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv

-f ${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect.f

${COMMON_BFM}/axi4_svf/axi4_svf_master_bfm.sv

${SIM_DIR}/../tb/axi4_l1_interconnect_2_tb.sv


