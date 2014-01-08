#!/bin/sh

testname=""
quiet=0

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

# echo "SOCBLOX=$SOCBLOX"  

export LD_LIBRARY_PATH=${SOCBLOX}/libs/linux:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${SOCBLOX}/libs/linux/dpi:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${BUILD_DIR}/libs:$LD_LIBRARY_PATH

argfile=""

if test -f ${SIM_DIR}/${testname}; then
	argfile="-sc_arg -f -sc_arg ${SIM_DIR}/${testname}"
	testname=`basename ${testname}`
	testname=`echo $testname | sed -e 's%\..*$%%g'`
elif test -f $SIM_DIR/tests/${testname}; then
	argfile="-sc_arg -f -sc_arg ${SIM_DIR}/tests/${testname}"
elif test -f $SIM_DIR/tests/${testname}.f; then
	argfile="-sc_arg -f -sc_arg ${SIM_DIR}/tests/${testname}.f"
fi

vmap work ${BUILD_DIR}/work > /dev/null 2>&1


#${BUILD_DIR}/simx +TARGET_EXE=${BUILD_DIR}/core_tests/adc.elf

if test $quiet -eq 1; then
	vsim -c -do "log -r /*; run 1ms; quit -f" axi4_amber23_svf_tb_opt \
		-sc_arg +TESTNAME=${testname} ${argfile} \
		-sv_lib ${SOCBLOX}/libs/linux/dpi/libsvf_dpi \
                -sv_lib ${BUILD_DIR}/libs/liba23_dpi > simx.log 2>&1
else
	vsim -c -do "log -r /*; run 1ms; quit -f" axi4_amber23_svf_tb_opt \
		-sc_arg +TESTNAME=${testname} ${argfile} \
		-sv_lib ${SOCBLOX}/libs/linux/dpi/libsvf_dpi \
                -sv_lib ${BUILD_DIR}/libs/liba23_dpi > simx.log 2>&1 | tee vsim.log
fi

#+TARGET_EXE=${BUILD_DIR}/core_tests/add.elf  \
#+SVF_TESTNAME=axi4_a23_svf_coretest

#gdb --args ${BUILD_DIR}/simx +TARGET_EXE=${BUILD_DIR}/core_tests/adc.elf
# valgrind --tool=memcheck ${BUILD_DIR}/simx

