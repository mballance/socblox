#!/bin/sh

while test -n "$1"; do
	case $1 in
		-sim)
			shift
			SIM=$1
			;;
		-*)
			echo "Error: Unknown option $1"
			exit 1
			;;
			
		*)
			echo "Error: Unknown argument $1"
			exit 1
			;;
	esac
	shift
done

CPU_COUNT=2
if test -f /proc/cpuinfo; then
	CPU_COUNT=`cat /proc/cpuinfo | grep processor | wc -l`
fi

make SIM=${SIM} -j ${CPU_COUNT} -f ${SIM_DIR}/scripts/Makefile

if test $? -ne 0; then
	exit 1
fi



