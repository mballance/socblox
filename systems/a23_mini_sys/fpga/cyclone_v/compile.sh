#!/bin/sh

quartus_map a23_mini_sys

if test $? -ne 0; then
  exit 1
fi

quartus_fit a23_mini_sys

if test $? -ne 0; then
  exit 1
fi

quartus_eda.exe a23_mini_sys --simulation --tool=modelsim --format=verilog --maintain_design_hierarchy=on

if test $? -ne 0; then
  exit 1
fi

