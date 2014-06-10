#!/bin/sh

for file in `find -type f`; do
  file=`echo $file | sed -e 's%\./%%'`
  suffix=`echo $file | sed -e 's%.*\(\.[a-zA-Z][a-zA-Z]*\)$%\1%'`

  if test "x$suffix" = "x.sh"; then
   executable=true
  else
   executable=false
  fi

  if test "x$suffix" != "x.svt"; then
    echo "<file executable=\"${executable}\" name="${file}" template=\"${file}\"/>"
  fi
done

