/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
 
${UNITS}/bidi_message_queue/bidi_message_queue.sv
${UNITS}/bidi_message_queue/bidi_message_queue_if.sv

${COMMON_RTL}/axi4/axi4_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_dualport_w.sv

${COMMON_RTL}/../sram/generic_sram_line_en.v
${COMMON_RTL}/../sram/generic_sram_line_en_dualport.v

${COMMON_BFM}/axi4_svf/axi4_svf_master_bfm.sv
${COMMON_BFM}/bidi_message_queue_bfm/bidi_message_queue_bfm.sv

${UNITS}/interconnects/axi4/axi4_interconnect_1x1.sv

${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${UNITS}/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv

../../tb/bidi_message_queue_tb.sv




