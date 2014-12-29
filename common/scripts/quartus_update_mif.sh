#!/bin/sh

project="$1"
sim_img="$2"

if test "x${project}" = "x"; then
  echo "Error: First argument (project) not specified"
  exit 1
fi

if ! test -f ${project}.qpf; then
  echo "Error: project ${project} does not exist"
  exit 1
fi

if test "x$sim_img" != "xsim" && test "x$sim_img" != "ximg"; then
  echo "Error: Expect second argument to be 'img' or 'sim'"
  exit 1
fi

quartus_cdb --update_mif ${project}

if test "$sim_img" = "sim"; then
  quartus_eda ${project} --tool=modelsim --format=verilog \
    --gen-testbench 
  quartus_eda ${project} --simulation --tool=modelsim \
    --format=verilog --maintain_design_hierarchy=on \
    --gen_script=rtl_and_gate_level
else
  quartus_asm ${project}
fi

