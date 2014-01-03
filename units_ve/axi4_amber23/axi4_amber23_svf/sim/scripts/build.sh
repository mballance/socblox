#!/bin/sh

echo "SYSTEMC=$SYSTEMC"

make -j4 -f ${SIM_DIR}/scripts/Makefile

if test $? -ne 0; then
	exit 1
fi



