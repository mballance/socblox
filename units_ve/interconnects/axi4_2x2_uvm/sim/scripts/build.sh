#!/bin/sh
#****************************************************************************
#* build.sh
#****************************************************************************

try()
{
  $*
  status=$?
  if test $status -ne 0; then
    exit $status
  fi
}

if test "x$SIM_DIR" = "x"; then
  SIM_DIR=`pwd`
fi

if test "x$BUILD_DIR" = "x"; then
  BUILD_DIR=`pwd`
fi

export PROJECT_LOC=`dirname $SIM_DIR`
export SOCBLOX=`cd $SIM_DIR/../../../../ ; pwd`

VLOG_FLAGS="-sv"

vlib work

# Build design and core testbench first
try vlog $VLOG_FLAGS -f ${SIM_DIR}/scripts/rtl_env_types.f 

# Now, compile the bench (including the inFact sequences)
try vlog $VLOG_FLAGS \
  -f ${SIM_DIR}/scripts/seqs_tb_tests.f 

# try vopt ethmac_tb eth_dut_binds -o ethmac_tb_opt +cover+/ethmac_tb/dut. 
try vopt -debugdb axi4_2x2_uvm_tb -o axi4_2x2_uvm_tb_opt -time

try vopt +acc -debugdb axi4_2x2_uvm_tb -o axi4_2x2_uvm_tb_opt_dbg 

exit 0

