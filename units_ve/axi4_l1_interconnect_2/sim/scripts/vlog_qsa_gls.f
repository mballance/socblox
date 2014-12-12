/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
+define+GLS

+incdir+${COMMON_RTL}/axi4
${COMMON_RTL}/axi4/axi4_if.sv 
${COMMON_RTL}/axi4/axi4_monitor.sv

/*
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_line_en_w.sv
 */

/*
${COMMON_RTL}/../sram/generic_sram_line_en_dualport.v
${COMMON_RTL}/../sram/generic_sram_byte_en_dualport.v
${COMMON_BFM}/generic_sram_byte_en/generic_sram_byte_en.sv
 */
${COMMON_BFM}/timebase/timebase.sv

${BUILD_DIR}/axi4_sram_synth/simulation/modelsim/axi4_sram_top.vo
${UNITS}/axi4_sram/axi4_sram_top_w.sv

/*
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${UNITS}/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv
 */

// -f ${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect.f
${BUILD_DIR}/axi4_l1_interconnect_synth/simulation/modelsim/axi4_l1_interconnect_2_top.vo
${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect_2_top_w.sv

${COMMON_BFM}/axi4_svf/axi4_svf_master_bfm.sv

${COMMON_BFM}/axi4_monitor/axi4_monitor_bfm.sv

${QUARTUS}/eda/sim_lib/altera_primitives.v
${QUARTUS}/eda/sim_lib/altera_lnsim.sv
${QUARTUS}/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v
${QUARTUS}/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v
${QUARTUS}/eda/sim_lib/cyclonev_atoms.v
${QUARTUS}/eda/sim_lib/220model.v
${QUARTUS}/eda/sim_lib/sgate.v
${QUARTUS}/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v
${QUARTUS}/eda/sim_lib/cyclonev_hssi_atoms.v
${QUARTUS}/eda/sim_lib/altera_mf.v
// ${QUARTUS}/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v
${QUARTUS}/eda/sim_lib/cyclonev_pcie_hip_atoms.v



${SIM_DIR}/../tb/axi4_l1_interconnect_2_tb.sv
