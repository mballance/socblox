#!/bin/sh

vlib work
vlog -sv -f ${COMMON_DIR}/fpga/altera_cyclonev_libs.f
vlog simulation/modelsim/a23_mini_sys.vo
vlog ${SYSTEMS}/a23_mini_sys/synth/gate_sim_top.sv

vopt -o gate_sim_top_opt +acc+a23_mini_sys gate_sim_top

