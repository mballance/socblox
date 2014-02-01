
-f ${SOCBLOX}/common/rtl/common_rtl.f
// -f ${SOCBLOX}/common/bfm/bfm.f
${SOCBLOX}/common/bfm/axi4_svf/axi4_svf_master_bfm.sv
${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv

-f ${SOCBLOX}/units/interconnects/interconnects.f

${SOCBLOX}/units_ve/interconnects/axi4_svf/tb/axi4_interconnect_2x2_tb.sv
