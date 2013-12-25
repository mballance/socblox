#!/bin/sh

echo "runone"

if test "x$BUILD_DIR" = "x"; then
  export BUILD_DIR=`pwd`/rundir
fi

if test "x$SOCBLOX" = "x"; then
  export SOCBLOX=`cd ../../../.. ; pwd`
fi  

echo "SOCBLOX=$SOCBLOX"  

export LD_LIBRARY_PATH=${SOCBLOX}/libs/linux:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${BUILD_DIR}/libs:$LD_LIBRARY_PATH

${BUILD_DIR}/simx +TARGET_EXE=${BUILD_DIR}/core_tests/adc.elf
# gdb --args ${BUILD_DIR}/simx +TARGET_EXE=${BUILD_DIR}/core_tests/adc.elf
# valgrind --tool=memcheck ${BUILD_DIR}/simx

