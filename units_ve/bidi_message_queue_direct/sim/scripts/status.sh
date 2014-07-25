#!/bin/sh

testname=$1

if test ! -f simx.log; then
  echo "FAIL: $testname - no log file"
else
  n_fails=`grep "FAIL: [a-zA-Z][a-zA-Z0-9_]*" simx.log | wc -l`
  n_pass=`grep "PASS: [a-zA-Z][a-zA-Z0-9_]*" simx.log | wc -l`

  if test $n_fails -gt 0; then
    tn=`grep "FAIL: [a-zA-Z][a-zA-Z0-9_]*" simx.log | \
      sed -e 's/FAIL: \([a-zA-Z][a-zA-Z0-9_]*\).*$/\1/'`
    echo "FAIL: $tn"
  elif test $n_pass -gt 0; then
    tn=`grep "PASS: [a-zA-Z][a-zA-Z0-9_]*" simx.log | \
      sed -e 's/PASS: \([a-zA-Z][a-zA-Z0-9_]*\).*$/\1/'`
    echo "PASS: $tn"
  else
    echo "FAIL: $testname - no PASS or FAIL"
  fi
fi
