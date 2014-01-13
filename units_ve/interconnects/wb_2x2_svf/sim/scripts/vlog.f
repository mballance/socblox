
-f ${SOCBLOX}/common/rtl/common_rtl.f
${SOCBLOX}/units/interconnects/wb/wb_interconnect_2x2.sv
${SOCBLOX}/units/timer/timer.sv

+incdir+${SOCBLOX}/common/bfm/wb_svf
${SOCBLOX}/common/bfm/wb_svf/wb_svf_master_bfm.sv

// -f ${SOCBLOX}/common/sram/common_sram.f
// -f ${SOCBLOX}/units/axi4_a23/axi4_a23.f
// ${SOCBLOX}/units/axi4_sram/axi4_sram.sv
// ${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv
// ${SOCBLOX}/units_ve/axi4_a23/axi4_a23_svf/svf/a23_tracer/axi4_a23_svf_tracer.sv
${SOCBLOX}/units_ve/interconnects/wb_2x2_svf/tb/wb_2x2_svf_tb.sv

