/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
+define+GLS

+incdir+${COMMON_RTL}/axi4
${COMMON_RTL}/axi4/axi4_if.sv

${COMMON_BFM}/axi4_svf/axi4_svf_master_bfm.sv

-f ${COMMON_RTL}/../fpga/altera_cyclonev_libs.f
 
${BUILD_DIR}/axi4_l1_mem_unit_synth/simulation/modelsim/axi4_l1_mem_unit_top.vo
${UNITS}/axi4_l1_mem_unit/axi4_l1_mem_unit_top_w.sv

${SIM_DIR}/../tb/axi4_l1_mem_unit_tb.sv


