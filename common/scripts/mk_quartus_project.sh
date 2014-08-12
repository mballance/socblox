#!/bin/sh

if test -f $0; then
	scripts_dir=`dirname $0`
	scripts_dir=`cd $scripts_dir ; pwd` 
else
	echo "Error: Cannot locate $0"
	exit 1
fi

filelist=$1

if test "x$filelist" = "x"; then
	echo "Error: no filelist supplied"
	exit 1
fi

if test ! -f $filelist; then
	echo "Error: Filelist $filelist does not exist"
	exit 1
fi


${QUARTUS_ROOTDIR}/bin/quartus_sh \
-t $scripts_dir/quartus_utils.tcl \
-f $filelist

if test $? -ne 0; then
	exit 1
fi
