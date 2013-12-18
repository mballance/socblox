#!/bin/sh

make -f ${SIM_DIR}/scripts/Makefile

if test $? -ne 0; then
	exit 1
fi



