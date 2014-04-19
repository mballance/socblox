/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
../../../../common/rtl/axi4/axi4_if.sv
../../../../common/rtl/wb/wb_if.sv
// ../../../../common/sram/generic_sram_byte_en.v
../../../../common/sram/generic_sram_line_en.v
// ../../../../common/sram/generic_rom.v
../../../../common/bfm/generic_rom/generic_rom.sv
../../../../common/bfm/generic_sram_byte_en/generic_sram_byte_en.sv
../../../../common/bfm/a23_tracer/a23_tracer_bfm.sv
-F ../../../../units/axi4_a23/axi4_a23_f.F

../../../../units/interconnects/axi4/axi4_interconnect_1x4.sv
../../../../units/interconnects/axi4/axi4_wb_bridge.sv

../../../../units/interconnects/wb/wb_interconnect_1x2.sv

../../../../units/axi4_rom/axi4_rom.sv
../../../../units/axi4_sram/axi4_sram.sv

../../../../units/timer/timer.sv
../../../../units/interrupt_controller/interrupt_controller.sv

// ../../../../systems/a23_mini_sys/generic_rom.v

// -f ${SOCBLOX}/units/axi4_a23/axi4_a23.f

../../../../systems/a23_mini_sys/a23_mini_sys.sv

../../tb/a23_mini_sys_tb.sv



