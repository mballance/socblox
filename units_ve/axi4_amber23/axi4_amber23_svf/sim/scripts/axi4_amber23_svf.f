
+define+A23_TRACE

-f ${SOCBLOX}/common/rtl/common_rtl.f
-f ${SOCBLOX}/common/sram/common_sram.f
-f ${SOCBLOX}/units/axi4_amber23/axi4_amber23.f
${SOCBLOX}/units/interconnects/axi4/axi4_interconnect_1x1.sv
${SOCBLOX}/units/axi4_sram/axi4_sram.sv
${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv
${SOCBLOX}/units_ve/axi4_amber23/axi4_amber23_svf/svf/a23_tracer/axi4_a23_svf_tracer.sv
${SOCBLOX}/units_ve/axi4_amber23/axi4_amber23_svf/tb/axi4_amber23_svf_tb.sv

