#!/bin/sh

export SOCBLOX=`cd ../../../.. ; pwd`

quartus_sh \
  -t ../../../../common/scripts/quartus_utils.tcl \
  -f a23_unicore_synth.f

