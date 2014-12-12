#!/bin/sh

project="$1"

if ! test -f ${project}.qpf; then
  echo "Error: project ${project} does not exist"
  exit 1
fi

quartus_cdb --update_mif ${project}
quartus_asm ${project}

