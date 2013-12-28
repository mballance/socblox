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

echo "SOCBLOX=$SOCBLOX"  

export LD_LIBRARY_PATH=${SOCBLOX}/libs/linux:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${BUILD_DIR}/libs:$LD_LIBRARY_PATH

argfile=""

if test -f ${SIM_DIR}/${testname}; then
	argfile="-f ${SIM_DIR}/${testname}"
	testname=`basename ${testname}`
	testname=`echo $testname | sed -e 's%\..*$%%g'`
elif test -f $SIM_DIR/tests/${testname}.f; then
	argfile="-f ${SIM_DIR}/tests/${testname}.f"
fi


#${BUILD_DIR}/simx +TARGET_EXE=${BUILD_DIR}/core_tests/adc.elf

if test $quiet -eq 1; then
	${BUILD_DIR}/simx +TESTNAME=${testname} ${argfile} > simx.log 2>&1
else
	${BUILD_DIR}/simx +TESTNAME=${testname} ${argfile} 2>&1 | tee simx.log
fi

#+TARGET_EXE=${BUILD_DIR}/core_tests/add.elf  \
#+SVM_TESTNAME=axi4_a23_svm_coretest

#gdb --args ${BUILD_DIR}/simx +TARGET_EXE=${BUILD_DIR}/core_tests/adc.elf
# valgrind --tool=memcheck ${BUILD_DIR}/simx

