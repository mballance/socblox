/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/

+define+GLS
+incdir+${COMMON_RTL}/axi4

${COMMON_RTL}/axi4/axi4_if.sv
${COMMON_RTL}/axi4/axi4_monitor.sv

${COMMON_BFM}/axi4_svf/axi4_svf_master_bfm.sv
${COMMON_BFM}/axi4_monitor/axi4_monitor_bfm.sv
${COMMON_BFM}/timebase/timebase.sv

${BUILD_DIR}/axi4_l1_mem_subsystem_synth/simulation/modelsim/axi4_l1_mem_subsystem_top.vo
${UNITS}/axi4_l1_mem_subsystem/axi4_l1_mem_subsystem_top_w.sv

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


${SIM_DIR}/../tb/axi4_l1_mem_subsys_tb.sv


