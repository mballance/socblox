/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/

+incdir+${COMMON_RTL}/axi4

${COMMON_RTL}/axi4/axi4_if.sv
${COMMON_RTL}/axi4/axi4_monitor.sv

${UNITS}/interconnects/axi4/axi4_interconnect_1x3.sv

${UNITS}/axi4_l1_interconnect/axi4_l1_cache_2.sv
${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect_2.sv

${COMMON_RTL}/../sram/generic_sram_byte_en.v
${COMMON_RTL}/../sram/generic_sram_byte_en_dualport.v
${COMMON_RTL}/../sram/generic_sram_line_en.v
${COMMON_RTL}/../sram/generic_sram_line_en_dualport.v

${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_w.sv

${UNITS}/axi4_sram/axi4_sram.sv
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv

${COMMON_BFM}/axi4_svf/axi4_svf_master_bfm.sv
${COMMON_BFM}/axi4_monitor/axi4_monitor_bfm.sv
${COMMON_BFM}/timebase/timebase.sv

${UNITS}/axi4_l1_mem_subsystem/axi4_l1_mem_subsystem.sv

${SIM_DIR}/../tb/axi4_l1_mem_subsys_tb.sv


