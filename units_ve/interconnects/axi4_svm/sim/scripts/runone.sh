#!/bin/sh

echo "runone"

export LD_LIBRARY_PATH=${SOCBLOX}/libs/linux:$LD_LIBRARY_PATH

${BUILD_DIR}/simx

