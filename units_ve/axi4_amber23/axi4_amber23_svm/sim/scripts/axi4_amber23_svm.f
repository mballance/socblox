
+define+A23_TRACE

-f ${SOCBLOX}/common/rtl/common_rtl.f
-f ${SOCBLOX}/common/sram/common_sram.f
-f ${SOCBLOX}/units/axi4_amber23/axi4_amber23.f
${SOCBLOX}/units/interconnects/axi4/axi4_interconnect_1x1.sv
${SOCBLOX}/units/axi4_sram/axi4_sram.sv
${SOCBLOX}/units_ve/axi4_amber23/axi4_amber23_svm/tb/axi4_amber23_svm_tracer.sv
${SOCBLOX}/units_ve/axi4_amber23/axi4_amber23_svm/tb/axi4_amber23_svm_tb.sv

