#!/bin/sh
#****************************************************************************
#* runone.sh
#*
#* Runs a single simulation
#****************************************************************************

if test "x$SIM_DIR" = "x"; then
  echo "[ERROR] SIM_DIR not set"
  exit 1
fi

if test "x$BUILD_DIR" = "x"; then
  echo "[ERROR] BUILD_DIR not set"
  exit 1
fi

unset MODELSIM

interactive=0
testname=""
seed="random";
quiet=0

while test -n "$1"; do
  case $1 in
    -seed)
      shift
      seed="$1"
      ;;

     -interactive)
      shift
      interactive=$1
      ;;

    -quiet)
      shift
      quiet=$1
      ;;

    -*)
      echo "[ERROR] Unknown option $1"
      exit 1
      ;;

    *)
      if test "x$testname" = "x"; then
        testname="$1";
      else  
        echo "[ERROR] Unknown argument $1"
      fi
      ;;
  esac
  shift
done

TESTNAME="`basename ${testname}`"
TESTNAME=`echo $TESTNAME | sed -e 's/\.f$//g'`
export TESTNAME

if test -f ${SIM_DIR}/tests/${testname}.f; then
    testfile=${SIM_DIR}/tests/${testname}.f
elif test -f ${SIM_DIR}/${testname}; then
    testfile=${SIM_DIR}/${testname}
else
    # Create a testfile that specifies the test name
    echo "+UVM_TESTNAME=${TESTNAME}" > testfile.f
    testfile="testfile.f"
fi


echo "do \$env(SIM_DIR)/scripts/config_cov.do" > run.do

if test $interactive -eq 1; then
  echo "do \$env(SIM_DIR)/scripts/wave.do" >> run.do
fi

if test $interactive -eq 0; then
  echo "do \$env(SIM_DIR)/scripts/run.do" >> run.do
fi

VSIM_OPTIONS="$VSIM_OPTIONS -do run.do"
VSIM_OPTIONS="$VSIM_OPTIONS -sv_seed $seed"
VSIM_OPTIONS="$VSIM_OPTIONS -f ${testfile}"
# VSIM_OPTIONS="$VSIM_OPTIONS -uvmcontrol=struct"
# VSIM_OPTIONS="$VSIM_OPTIONS -solveengine bdd"
VSIM_OPTIONS="$VSIM_OPTIONS -msgmode both -displaymsgmode both"

BATCH="-c"

if test $interactive -eq 0; then
  ROOT=axi4_2x2_uvm_tb_opt
else
  ROOT=axi4_2x2_uvm_tb_opt_dbg
fi

# Map in the libraries
vmap work ${BUILD_DIR}/work

if test $interactive -eq 0; then
  if test $quiet -eq 1; then
    vsim -printsimstats $BATCH $VSIM_OPTIONS $ROOT -nostdout > /dev/null 2>&1
  else
    vsim -printsimstats $BATCH $VSIM_OPTIONS $ROOT 
  fi
else
  vsim $VSIM_OPTIONS $ROOT
fi


