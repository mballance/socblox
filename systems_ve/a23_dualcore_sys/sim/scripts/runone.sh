#!/bin/sh

testname=""
quiet=0
debug=false

PLATFORM=linux
UNIT=a23_dualcore_sys

while test -n "$1"; do
	case $1 in
		-seed)
			shift
			;;
		-quiet)
			shift
			quiet=$1
			;;
		-interactive)
			shift
			;;
		-debug)
			shift
			if test $1 -eq 1; then
				debug=true
			else
				debug=false
			fi
			;;
		-sim)
			shift
			SIM=$1
			;;
		-*)
			# Ignore for now
			echo "Ignore $1"
		;;
		*)
			if test "x$testname" = "x"; then
				testname=$1;
			else
				echo "Unknown argument $1"
				exit 1
			fi
		;;
	esac
	shift
done

if test "x$BUILD_DIR" = "x"; then
  export BUILD_DIR=`pwd`/rundir
fi

if test "x$SOCBLOX" = "x"; then
  export SOCBLOX=`cd ../../../.. ; pwd`
fi  

argfile=""

if test -f ${SIM_DIR}/${testname}; then
	argfile="-f ${SIM_DIR}/${testname}"
	testname=`basename ${testname}`
	testname=`echo $testname | sed -e 's%\..*$%%g'`
elif test -f $SIM_DIR/tests/${testname}; then
	argfile="-f ${SIM_DIR}/tests/${testname}"
elif test -f $SIM_DIR/tests/${testname}.f; then
	argfile="-f ${SIM_DIR}/tests/${testname}.f"
fi

if test $quiet -eq 1; then
	make SIM=${SIM} TESTNAME=${testname} ARGFILE="${argfile}" \
		DEBUG=${debug} \
		-f ${SIM_DIR}/scripts/Makefile run > simx.log 2>&1
else
	make SIM=${SIM} TESTNAME=${testname} ARGFILE="${argfile}" \
		DEBUG=${debug} \
		-f ${SIM_DIR}/scripts/Makefile run 2>&1 | tee simx.log
fi
