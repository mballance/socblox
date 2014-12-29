#!/bin/sh

project="$1"

if test "x${project}" = "x"; then
  echo "Error: First argument (project) not specified"
  exit 1
fi

if ! test -f ${project}.qpf; then
  echo "Error: project ${project} does not exist"
  exit 1
fi

quartus_asm ${project}

