#!/bin/sh

echo "SYSTEMC=$SYSTEMC"

# make -j4 -f ${SIM_DIR}/scripts/Makefile.vl
make -j 4 -f ${SIM_DIR}/scripts/Makefile.vl

if test $? -ne 0; then
	exit 1
fi



