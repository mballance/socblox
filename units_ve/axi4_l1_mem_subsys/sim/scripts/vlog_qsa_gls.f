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

-f ${COMMON_RTL}/../fpga/altera_cyclonev_libs.f

${SIM_DIR}/../tb/axi4_l1_mem_subsys_tb.sv


