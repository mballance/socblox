#!/bin/sh

cwd=`pwd`

vm_cwd=`echo $cwd | sed -e 's%^/[a-zA-Z]%%'`

ssh $USERNAME@localhost ". /home/${USERNAME}/.tools ; cd $vm_cwd ; ./runtest.pl $*"

